//
//  Router.h
//  Router
//
//  Created by 李立 on 2018/9/27.
//  Copyright © 2018 李立. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPConnector.h"
#import "NativeConnector.h"

NS_ASSUME_NONNULL_BEGIN

#define _ROUTER(_URL, _error) [[Router sharedRouter] openURL:[NSURL URLWithString:_URL] error:_error]
#define ROUTER(_URL) _ROUTER(_URL, NULL)

@interface Router : NSObject<NSCopying, NSMutableCopying>

/**
 创建一个Router静态实例

 @return Router
 */
+ (instancetype)sharedRouter;

/**
 打开URL指定链接，可以是http、https 链接，也可以是自定义链接

 @param URL URL链接
 @param error 错误对象，如果不能打开这个链接，就会报错
 @return 返回通过URL找到的对象,如果未找到该对象返回空
 */
- (id)openURL:(NSURL *)URL error:(NSError **)error;

/**
 注册Connector连接器

 @param connector URL连接器
 @param scheme URL scheme
 */
- (void)registerConnector:(id<URLConnector>)connector forScheme:(NSString *)scheme;

@end

NS_ASSUME_NONNULL_END
