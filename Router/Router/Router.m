//
//  Router.m
//  Router
//
//  Created by 李立 on 2018/9/27.
//  Copyright © 2018 李立. All rights reserved.
//

#import "Router.h"

@interface Router ()
@property (strong, nonatomic) NSMutableDictionary <NSString *, id<URLConnector>>*schemes;

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

- (NSMutableDictionary<NSString *,id<URLConnector>> *)schemes {
    if (!_schemes) {
        _schemes = [NSMutableDictionary new];
    }
    
    return _schemes;
}

- (void)registerConnector:(id<URLConnector>)connector forScheme:(nonnull NSString *)scheme {
    if (!connector || !scheme.length) {
        NSLog(@"%s 注册失败, connector 或 scheme 为空!", __FUNCTION__);
        return;
    }
    
    if (![connector conformsToProtocol:@protocol(URLConnector)]) {
        NSLog(@"%s 注册失败, connector 没有遵循URLConnector协议!", __FUNCTION__);
        return;
    }
    
    [self.schemes setObject:connector forKey:scheme];
}

- (id)openURL:(NSURL *)URL error:(NSError **)error {
    if (!URL) {
        if (error) {
            *error = [NSError errorWithDomain:@"router" code:0 userInfo:@{NSLocalizedDescriptionKey:@"URL为空"}];
        }
        
        return nil;
    }
    
    // 获取连接器
    id <URLConnector> connector = [self.schemes objectForKey:URL.scheme];
    if (!connector) {
        if (error) {
            NSString *errorMsg = [NSString stringWithFormat:@"Router不支持这个URL的Scheme，你可以通过 registerConnector:forScheme: 方法注册%@这个Scheme", URL.scheme];
            *error = [NSError errorWithDomain:@"router" code:0 userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
        }
        
        return nil;
    }
    
    if ([connector willPerformURL:URL]) {   // 判断当前URL是否可以被执行
        return [connector performURL:URL error:error];  // 执行URL，返回对象
    }
    
    return nil;
}

@end
