//
//  UIDevice+Device.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum iOSDeviceType {
    iOSDeviceTypeUnknown = 0,
    iOSDeviceTypePhone = 1,
    iOSDeviceTypePod,
    iOSDeviceTypePad,
    iOSDeviceTypeTV,
} iOSDeviceType;

@interface UIDevice (Device)

- (BOOL)isJailbroken;
- (BOOL)isAppSyncExist;
- (NSString *)platform;
- (NSString *)platformString;
- (BOOL)isRetina;
- (iOSDeviceType)deviceType;
- (NSString *)carrierName;
- (NSString *)uniqueGlobalDeviceIdentifier;

+ (BOOL)isIOS6OrLater;
+ (BOOL)isIOS6Befor;
+ (BOOL)isIOS7;
+ (BOOL)isIOS7OrLater;
+ (BOOL)isIOS7Befor;
+ (BOOL)isIOS8OrLater;
+ (BOOL)isIOS8Befor;
+ (BOOL)isIPad;
+ (BOOL)isIPhone5Later;
+ (BOOL)isIPhone6Later;
+ (BOOL)is64bit;
+ (BOOL)isIOS9OrLater;
+ (BOOL)isIOS10OrLater;

+ (BOOL)isIPhone4ORLess;
+ (BOOL)isIPhone5;
+ (BOOL)isIPhone6;
+ (BOOL)isIphone6P;
+ (BOOL)isIpadPro;

@end
