//
//  HTTPConnector.m
//  Router
//
//  Created by 唯赢 on 2018/11/8.
//  Copyright © 2018 李立. All rights reserved.
//

#import "HTTPConnector.h"

@implementation HTTPConnector

- (BOOL)willPerformURL:(NSURL *)URLObject {
    return YES;
}

- (id)performURL:(NSURL *)URLObject error:(NSError * _Nullable __autoreleasing *)error {
    if (!self.webControllerClass) {
        if (error) {
            *error = [NSError errorWithDomain:@"HTTPConnector" code:0 userInfo:@{NSLocalizedDescriptionKey:@"webControllerClass为空，请设置webControllerClass"}];
        }
        NSLog(@"%s webControllerClass 不能为空!", __FUNCTION__);
        return nil;
    }
    
    id webViewController = [[self.webControllerClass alloc] init];
    @try {
        [webViewController setValue:URLObject.absoluteString forKey:@"url"];
    } @catch (NSException *exception) {
        NSLog(@"%s -> %@", __FUNCTION__, exception);
    }
    
    return webViewController;
}

@end
