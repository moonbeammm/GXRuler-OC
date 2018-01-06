//
//  NSDate+Formatter.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Formatter)

+ (NSDate *)dateFromString:(NSString *)str formatterStr:(NSString *)formatterStr;

- (NSString *)stringWithTrackerFormat;

@end
