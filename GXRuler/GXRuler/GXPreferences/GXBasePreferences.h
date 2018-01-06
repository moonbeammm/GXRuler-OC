//
//  GXBasePreferences.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXBasePreferences : NSObject

+ (instancetype __nullable)shared;
- (void)sync;
/**
 *  Override
 */
- (NSString * __nullable)configName;
- (NSDictionary * __nullable)defaultConfig;

@end
