//
//  NSString+Encode.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "NSString+Encode.h"

@implementation NSString (Encode)

- (NSString *)stringByUriEncode
{
    NSCharacterSet * characterSet = [NSCharacterSet characterSetWithCharactersInString:@"!*'\"();:@&=+$,/?%#[]%"];
    NSCharacterSet * allowedCharacters = [characterSet invertedSet];
    return [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
}

@end
