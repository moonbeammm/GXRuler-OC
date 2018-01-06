//
//  GXApiOptions.h
//  GXNetwork
//
//  Created by sunguangxin on 2017/9/8.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXApiModelDescription.h"

typedef enum : NSUInteger {
    GXApiHttpMethodTypeGET,
    GXApiHttpMethodTypePOST,
    GXApiHttpMethodTypePUT,
} GXApiHttpMethodType;

@interface GXApiOptions : NSObject

@property (nonatomic, strong, nonnull) NSArray <GXApiModelDescription *> *modelDescriptions;
/**
 请求地址
 */
@property (nonatomic, strong) NSString * _Nullable baseUrl;

/**
 请求参数
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> * _Nullable params;

/**
 解析规则
 */
@property (nonatomic, strong) NSArray * _Nullable resolver;

/**
 请求类型
 */
@property (nonatomic, assign) GXApiHttpMethodType httpMethod;


/**
 请求超时
 默认20s
 */
@property (nonatomic, assign) Float64 timeoutInterval;

@property (nonatomic, strong, nullable) NSDictionary <NSString *, NSString *> *exHTTPHeader;

@end
