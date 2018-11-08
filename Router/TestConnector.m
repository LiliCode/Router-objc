//
//  TestConnector.m
//  Router
//
//  Created by 唯赢 on 2018/11/8.
//  Copyright © 2018 李立. All rights reserved.
//

#import "TestConnector.h"

@implementation TestConnector

- (BOOL)willPerformURL:(NSURL *)URLObject {
    // 在这里做URL拦截处理，判断是否允许URL进行路由
    
    return YES;
}

- (id)performURL:(NSURL *)URLObject error:(NSError * _Nullable __autoreleasing *)error {
    // URL路由逻辑，可以参考 HTTPConnector、NativeConnector
    
    return nil;
}

@end
