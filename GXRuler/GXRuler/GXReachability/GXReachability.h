//
//  GXReachability.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GXNetworkStatus) {
    NetworkStatusNotReachable = 0,
    NetworkStatusReachableViaWiFi,
    NetworkStatusReachableViaWWAN,
};

@class RACSignal;
@interface GXReachability : NSObject

+ (GXNetworkStatus)currentStatus;   // 当前网络状态
+ (RACSignal *)statusSignal;        // 使用此信号获取网络状态更改

+ (BOOL)isReachable;                // 可以联通网络
+ (BOOL)isReachableViaWWAN;         // 通过2G/3G/4G联网
+ (BOOL)isReachableViaWiFi;         // 通过WiFi联网

@end
