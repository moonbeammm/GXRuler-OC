//
//  GXThemeCongfig.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXThemeCongfig.h"

@implementation GXThemeCongfig

+ (instancetype)sharedConfig
{
    static dispatch_once_t onceToken;
    static GXThemeCongfig *sharedInstance = nil;
    dispatch_once(&onceToken, ^{ sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

- (NSString * __nullable)configName
{
    return @"BFCMultiThemeName";
}

- (NSDictionary * __nullable)defaultConfig
{
    return @{
             @"multiThemeType":@(0)
             };
}

@end
