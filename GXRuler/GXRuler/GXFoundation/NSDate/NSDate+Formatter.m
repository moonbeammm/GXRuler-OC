//
//  NSDate+Formatter.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "NSDate+Formatter.h"

@implementation NSDate (Formatter)

+ (NSDate *)dateFromString:(NSString *)str formatterStr:(NSString *)formatterStr
{
    NSDateFormatter *formatter = [self formatterWithStr:formatterStr];
    return [formatter dateFromString:str];
}

+ (NSDateFormatter *)formatterWithStr:(NSString *)formatterStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    return formatter;
}

+ (NSString *)stringFromDate:(NSDate *)date formatterStr:(NSString *)formatterStr
{
    NSDateFormatter *formatter = [self formatterWithStr:formatterStr];
    return [formatter stringFromDate:date];
}

- (NSString *)stringWithTrackerFormat
{
    return [NSDate stringFromDate:self formatterStr:@"yyyyMMddHHmmss"];
}

@end
