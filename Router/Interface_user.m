//
//  Interface_user.m
//  Router
//
//  Created by 李立 on 2018/9/27.
//  Copyright © 2018 李立. All rights reserved.
//

#import "Interface_user.h"
#import "User.h"

@implementation Target_user

+ (id)detail:(NSDictionary *)parameter {
    User *u = [User new];
    u.uid = [parameter[@"uid"] integerValue];
    u.name = parameter[@"name"];
    NSLog(@"%s", __FUNCTION__);
    return u;
}

+ (id)userCenter {
    NSLog(@"%s", __FUNCTION__);
    return [User new];
}

+ (void)log:(NSDictionary *)parameter {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"日志输出：%@", parameter);
}

+ (void)log {
    NSLog(@"日志输出：User Class %s", __FUNCTION__);
}

@end
