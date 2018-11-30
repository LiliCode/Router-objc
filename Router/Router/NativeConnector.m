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
    // 解析URL
    NSURLComponents *components = [NSURLComponents componentsWithString:URLObject.absoluteString];
    // 获取path（action）
    NSString *path = [[components.path componentsSeparatedByString:@"/"] lastObject];
    // 转换成Action
    NSString *action = [path copy];
    if (components.query.length) {
        action = [action stringByAppendingString:@":"];
    }
    // 解析query（参数）
    NSMutableDictionary *params = [NSMutableDictionary new];
    for (NSURLQueryItem *item in components.queryItems) {
        [params setObject:item.value forKey:item.name];
    }
    
    // 接口类 Target_ 后面名称首字母大写
    NSMutableString *mTargetName = [components.host mutableCopy];
    NSString *targetName = nil;
    if (mTargetName.length) {
        NSUInteger index = 1;
        NSString *firstChar = [mTargetName substringToIndex:index];
        NSString *suffixString = [mTargetName substringFromIndex:index];
        targetName = [[firstChar uppercaseString] stringByAppendingString:suffixString];
    }
    
    return [self performTarget:[NSString stringWithFormat:@"Target_%@", targetName] withAction:action withParameter:[params copy] error:error];
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
    
    NSMethodSignature *signature = [class methodSignatureForSelector:selector];
    if (!strcmp(signature.methodReturnType, @encode(void))) {   // 方法无返回值
        // 使用 runtime 动态调用 class 中的方法: 参考: https://www.jianshu.com/p/6517ab655be7
        // 也可以使用 performSelector 的方法动态调用，只不过在ARC下面编译器会出现警告(爆栈)
        ((void (*)(id, SEL, id))[class methodForSelector:selector])(class, selector, parameter);
        return nil;
    }
    
    return ((id (*)(id, SEL, id))[class methodForSelector:selector])(class, selector, parameter);
}

@end
