//
//  HTTPConnector.h
//  Router
//
//  Created by 唯赢 on 2018/11/8.
//  Copyright © 2018 李立. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLConnector.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTTPConnector : NSObject<URLConnector>
@property (strong, nonatomic) Class webControllerClass;

@end

NS_ASSUME_NONNULL_END
