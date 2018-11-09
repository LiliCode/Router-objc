//
//  NativeConnector.h
//  Router
//
//  Created by 唯赢 on 2018/11/8.
//  Copyright © 2018 李立. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLConnector.h"

NS_ASSUME_NONNULL_BEGIN

@interface NativeConnector : NSObject<URLConnector>


/**
 本地组件和接口调用

 @param target 接口类名称，本地类名称
 @param action 要调用的接口或者本地类的方法
 @param parameter 方法参数 NSDictionary *
 @param error NSError 错误对象
 @return 返回action 的返回值
 */
- (id)performTarget:(NSString *)target withAction:(NSString *)action withParameter:(NSDictionary *)parameter error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
