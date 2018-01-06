//
//  NSString+AppendParam.m
//  GXRuler
//
//  Created by sgx on 2018/1/6.
//  Copyright © 2018年 sunguangxin. All rights reserved.
//

#import "NSString+AppendParam.h"

@implementation NSString (AppendParam)

- (NSString *)appendParamKey:(NSString *)paramKey paramValue:(NSString *)paramValue
{
    if (!self || self.length <= 0) {
        return nil;
    }
    NSURLComponents *oriUrlCpts = [NSURLComponents componentsWithString:self];
    // 长链没有参数.且没有标识符
    if (oriUrlCpts.rangeOfQuery.location == NSNotFound &&
        oriUrlCpts.rangeOfFragment.location == NSNotFound) {
        return [NSString stringWithFormat:@"%@?%@=%@",self, paramKey, paramValue];
    }
    
    // 长链里本来就有该参数.直接返回
    for (NSURLQueryItem *item in oriUrlCpts.queryItems) {
        if (item.name && item.value && [item.name isEqualToString:paramKey]) {
            return self;
        }
    }
    
    // 长链有标识符
    if (oriUrlCpts.fragment && oriUrlCpts.fragment.length > 0) {
        oriUrlCpts.fragment = [oriUrlCpts.fragment stringByAddingPercentEncodingWithAllowedCharacters:
                               [NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSMutableString *mutStr = [NSMutableString stringWithString:self];
        NSRange fragmentRange = [oriUrlCpts rangeOfFragment];
        NSString *symbol = (oriUrlCpts.rangeOfQuery.location == NSNotFound) ? @"?":@"&";
        [mutStr insertString:[NSString stringWithFormat:@"%@%@=%@",symbol, paramKey, paramValue] atIndex:(fragmentRange.location-1)];
        return [mutStr copy];
    }
    // 长链有参数.且没有标识符.
    return [NSString stringWithFormat:@"%@&%@=%@",self, paramKey, paramValue];
}

@end
