//
//  Interface_user.h
//  Router
//
//  Created by 李立 on 2018/9/27.
//  Copyright © 2018 李立. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Interface_user : NSObject

/// app://user/detail?uid=x&name=xxx
+ (id)detail:(NSDictionary *)parameter;
/// app://user/userCenter
+ (id)userCenter;

@end

NS_ASSUME_NONNULL_END
