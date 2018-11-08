//
//  main.m
//  Router
//
//  Created by 李立 on 2018/9/27.
//  Copyright © 2018 李立. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Router/Router.h"
#import "User.h"
#import "WebController.h"
#import "TestConnector.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 创建连接器
        HTTPConnector *httpConnector = [[HTTPConnector alloc] init];
        httpConnector.webControllerClass = [WebController class];
        NativeConnector *nativeConnector = [[NativeConnector alloc] init];
        // 注册连接器
        [[Router sharedRouter] registerConnector:httpConnector forScheme:@"http"];
        [[Router sharedRouter] registerConnector:httpConnector forScheme:@"https"];
        [[Router sharedRouter] registerConnector:nativeConnector forScheme:@"app"];

        // 自定义Connector
        TestConnector *connector = [[TestConnector alloc] init];
        [[Router sharedRouter] registerConnector:connector forScheme:@"test"];
        
        // 测试
        NSError *error = nil;
        User *u = _ROUTER(@"app://user/detail?name=Lihuaxiang&uid=2", &error);
        if (!error) {
            NSLog(@"user.uid = %lu; user.name=%@", u.uid, u.name);
        } else {
            NSLog(@"%@", error.userInfo[NSLocalizedDescriptionKey]);
        }
        
        NSError *webError = nil;
        WebController *web = _ROUTER(@"http://www.aiyuke.com", NULL);
        if (!webError) {
            NSLog(@"URL: %@", web.url);
        } else {
            NSLog(@"%@", webError.userInfo[NSLocalizedDescriptionKey]);
        }
    }
    
    return 0;
}
