//
//  Interface_user.h
//  Router
//
//  Created by 李立 on 2018/9/27.
//  Copyright © 2018 李立. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_User : NSObject

/// app://user/detail?uid=x&name=xxx
+ (id)detail:(NSDictionary *)parameter;
/// app://user/userCenter
+ (id)userCenter;
/// 测试输出日志  app://user/log?text=x
+ (void)log:(NSDictionary *)parameter;
/// app://user/log
+ (void)log;

@end

NS_ASSUME_NONNULL_END
