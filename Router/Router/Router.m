//
//  Router.m
//  Router
//
//  Created by 李立 on 2018/9/27.
//  Copyright © 2018 李立. All rights reserved.
//

#import "Router.h"

@interface Router ()
@property (strong, nonatomic) NSMutableDictionary *schemes;

@end

@implementation Router

static Router *router = nil;

+ (instancetype)sharedRouter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[self alloc] init];
    });
    
    return router;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [super allocWithZone:zone];
    });
    
    return router;
}

- (id)copyWithZone:(NSZone *)zone {
    return router;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return router;
}

- (NSMutableDictionary *)schemes {
    if (!_schemes) {
        _schemes = [NSMutableDictionary new];
        [_schemes setObject:@"openWeb:" forKey:@"https"];
        [_schemes setObject:@"openWeb:" forKey:@"http"];
        [_schemes setObject:@"openNative:" forKey:@"app"];
    }
    
    return _schemes;
}

- (id)openURL:(NSURL *)URL error:(NSError **)error {
    if (!URL) {
        *error = [NSError errorWithDomain:@"router" code:404 userInfo:@{NSLocalizedDescriptionKey:@"URL为空"}];
        return nil;
    }
    
    NSString *selector = [self.schemes objectForKey:URL.scheme];
    if (!selector) {
        *error = [NSError errorWithDomain:URL.absoluteString code:404 userInfo:@{NSLocalizedDescriptionKey:@"不支持的URL链接"}];
        return nil;
    }
    
    if (![self respondsToSelector:NSSelectorFromString(selector)]) {
        return nil;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:NSSelectorFromString(selector) withObject:URL];
#pragma clang diagnostic pop
}

- (id)performTarget:(NSString *)target withAction:(NSString *)action withParameter:(NSDictionary *)parameter {
    if (!target.length || !action.length) {
        return nil;
    }
    
    Class class = NSClassFromString(target);
    SEL selector = NSSelectorFromString(action);
    // 判断class是否可以响应selector
    if (![class respondsToSelector:selector]) {
        return nil;
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSMethodSignature *signature = [class methodSignatureForSelector:selector];
    if (!strcmp(signature.methodReturnType, @encode(void))) {
        [class performSelector:selector withObject:parameter];  // 方法无返回值
        return nil;
    }
    
    return [class performSelector:selector withObject:parameter];
#pragma clang diagnostic pop
}

- (id)openNative:(NSURL *)URL {
    // 解析链接：类名、方法、参数
    NSString *urlString = [URL.absoluteString copy];
    // 去掉scheme
    NSString *url = [[urlString componentsSeparatedByString:@"//"] lastObject];
    // 判断是否有参数
    NSRange r = [url rangeOfString:@"?"];
    NSString *targetName = nil, *actionName = nil;
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (NSNotFound == r.location) { // 无参数
        NSArray *components = [url componentsSeparatedByString:@"/"];
        targetName = [components firstObject];
        actionName = [components lastObject];
    } else {
        NSArray *components = [url componentsSeparatedByString:@"?"];
        NSString *targetAction = [components firstObject];
        NSString *paramsString = [components lastObject];
        // 解析类名和方法名
        NSArray *targetActionList = [targetAction componentsSeparatedByString:@"/"];
        targetName = [targetActionList firstObject];
        actionName = [[targetActionList lastObject] stringByAppendingString:@":"];
        // 解析参数
        NSArray *keyValues = [paramsString componentsSeparatedByString:@"&"];
        for (NSString *keyValueString in keyValues) {
            NSArray *keyValueList = [keyValueString componentsSeparatedByString:@"="];
            [params setObject:[keyValueList lastObject] forKey:[keyValueList firstObject]];
        }
    }
    
    return [self performTarget:[NSString stringWithFormat:@"Interface_%@", targetName] withAction:actionName withParameter:[params copy]];
}

- (id)openWeb:(NSURL *)URL {
    return nil;
}

@end
