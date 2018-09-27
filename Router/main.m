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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSError *error = nil;
        User *u = _ROUTER(@"app://user/detail?name=Lihuaxiang&uid=2", &error);
        if (!error) {
            NSLog(@"user.uid = %lu; user.name=%@", u.uid, u.name);
        }
    }
    
    return 0;
}
