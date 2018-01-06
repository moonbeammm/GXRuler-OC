//
//  GXApiModelProtocol.h
//  GXNetwork
//
//  Created by sunguangxin on 2017/10/20.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXApiModelProtocol <NSObject>
@optional
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper;
+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass;

@end
