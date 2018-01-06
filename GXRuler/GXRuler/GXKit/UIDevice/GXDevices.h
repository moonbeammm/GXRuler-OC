//
//  GXDevices.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBFCDeviceRank_Baseline                          10
#define kBFCDeviceRank_AppleA4Class                      20   // Cortex-A8 class
#define kBFCDeviceRank_AppleA5Class                      30   // Cortex-A9 class
#define kBFCDeviceRank_AppleA5RAClass                    31   // Cortex-A9 class
#define kBFCDeviceRank_AppleA5XClass                     35   // Cortex-A9 class
#define kBFCDeviceRank_AppleA6Class                      40   // ARMv7s class
#define kBFCDeviceRank_AppleA6XClass                     41   // ARMv7s class
#define kBFCDeviceRank_AppleA7Class                      50   // ARM64 class
#define kBFCDeviceRank_AppleA8LowClass                   55   // ARM64 class
#define kBFCDeviceRank_AppleA8Class                      60   // ARM64 class
#define kBFCDeviceRank_AppleA8XClass                     61   // ARM64 class
#define kBFCDeviceRank_AppleA9Class                      70   // ARM64 class
#define kBFCDeviceRank_AppleA9XClass                     71   // ARM64 class
#define kBFCDeviceRank_LatestUnknown                     90
#define kBFCDeviceRank_Simulator                         100

@interface GXDevices : NSObject

@property(nonatomic, strong) NSString  *platform;
@property(nonatomic, strong) NSString  *name;
@property(nonatomic, assign) NSInteger rank;

+ (instancetype)currentDevice;

@end
