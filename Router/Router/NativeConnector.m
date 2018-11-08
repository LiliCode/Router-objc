//
//  NativeConnector.m
//  Router
//
//  Created by 唯赢 on 2018/11/8.
//  Copyright © 2018 李立. All rights reserved.
//

#import "NativeConnector.h"

@implementation NativeConnector

- (BOOL)willPerformURL:(NSURL *)URLObject {
    return YES;
}

- (id)performURL:(NSURL *)URLObject error:(NSError * _Nullable __autoreleasing *)error {
    // 解析链接：类名、方法、参数
    NSString *urlString = [URLObject.absoluteString copy];
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
    
    return [self performTarget:[NSString stringWithFormat:@"Target_%@", targetName] withAction:actionName withParameter:[params copy] error:error];
}

- (id)performTarget:(NSString *)target withAction:(NSString *)action withParameter:(NSDictionary *)parameter error:(NSError * _Nullable __autoreleasing *)error {
    if (!target.length || !action.length) {
        if (error) {
            *error = [NSError errorWithDomain:@"NativeConnector" code:0 userInfo:@{NSLocalizedDescriptionKey:@"链接不符合NativeConnector规范"}];
        }
        
        return nil;
    }
    
    Class class = NSClassFromString(target);
    SEL selector = NSSelectorFromString(action);
    // 判断class是否可以响应selector
    if (![class respondsToSelector:selector]) {
        if (error) {
            NSString *errorMsg = [NSString stringWithFormat:@"%@ 接口类中找不到 %@ 方法", target, action];
            *error = [NSError errorWithDomain:@"NativeConnector" code:0 userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
        }
        
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

@end
