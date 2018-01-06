//
//  GXBaseConfig.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXBaseConfig.h"

@implementation GXBaseConfig

+ (instancetype)sharedConfig
{
    static dispatch_once_t onceToken;
    static GXBaseConfig *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString * __nullable)configName
{
    return @"GXBaseConfig";
}

- (NSDictionary * __nullable)defaultConfig
{
    return @{
             @"inReview":@(0),
             @"isNightMode":@(0)
             };
}

@end
