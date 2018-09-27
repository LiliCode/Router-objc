//
//  Interface_user.m
//  Router
//
//  Created by 李立 on 2018/9/27.
//  Copyright © 2018 李立. All rights reserved.
//

#import "Interface_user.h"
#import "User.h"

@implementation Interface_user

+ (id)detail:(NSDictionary *)parameter {
    User *u = [User new];
    u.uid = [parameter[@"uid"] integerValue];
    u.name = parameter[@"name"];
    
    return u;
}

+ (id)userCenter {
    return [User new];
}

@end
