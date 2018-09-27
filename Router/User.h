//
//  User.h
//  Router
//
//  Created by 李立 on 2018/9/27.
//  Copyright © 2018 李立. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject
@property (assign, nonatomic) NSUInteger uid;
@property (copy, nonnull) NSString *name;

@end

NS_ASSUME_NONNULL_END
