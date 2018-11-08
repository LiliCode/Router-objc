//
//  URLConnector.h
//  Router
//
//  Created by 唯赢 on 2018/11/8.
//  Copyright © 2018 李立. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol URLConnector <NSObject>
@required

/**
 将要执行URL

 @param URLObject NSURL 对象
 @return 是否可以执行URL，YES：允许执行
 */
- (BOOL)willPerformURL:(NSURL *)URLObject;

/**
 开始执行URL链接

 @param URLObject 对象
 @param error NSError 错误对象，如果遇到执行URL出错，error != NULL
 @return 返回URL执行结果，可以是控制器，可以是模型类...
 */
- (id)performURL:(NSURL *)URLObject error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
