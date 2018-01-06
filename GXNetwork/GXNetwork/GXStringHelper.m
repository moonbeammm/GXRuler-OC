//
//  GXStringHelper.m
//  GXNetwork
//
//  Created by sunguangxin on 2017/9/8.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXStringHelper.h"

@implementation GXStringHelper

+ (nonnull NSMutableString *)getQueryStrWithParams:(NSMutableDictionary * _Nullable)params
{
    NSMutableArray *allKeys = [[NSMutableArray alloc] initWithCapacity:10];
    
    [allKeys addObjectsFromArray:[params allKeys]];
    [allKeys sortUsingSelector:@selector(compare:)];
    
    NSMutableString *queryString = [[NSMutableString alloc] init];
    
    for (int i = 0; i < [allKeys count]; i++) {
        NSString *key = [allKeys objectAtIndex:i];
        
        if ([key isEqual:@"api"]) {
            continue;
        }
        
        if (([key length] >= 2) && [[key substringFromIndex:[key length] - 2] isEqualToString:@"[]"]) {
            if ([[params objectForKey:key] isKindOfClass:[NSArray class]]) {
                NSMutableArray *values = [NSMutableArray arrayWithArray:[params objectForKey:key]];
                [values sortUsingSelector:@selector(compare:)];
                
                for (int j = 0; j < [values count]; j++) {
                    NSString *value = [values objectAtIndex:j];
                    
                    [queryString appendFormat:@"%@=%@", [self encodeWithUrlStr:key], [self encodeWithUrlStr:value]];
                    
                    if (j + 1 != [values count]) {
                        [queryString appendString:@"&"];
                    }
                }
            }
        } else {
            NSString *v = [params objectForKey:[self encodeWithUrlStr:key]];
            if ([v isKindOfClass:[NSString class]]) {
                [queryString appendFormat:@"%@=%@", [self encodeWithUrlStr:key], [self encodeWithUrlStr:v]];
            }
        }
        
        if (i + 1 != [allKeys count]) {
            [queryString appendString:@"&"];
        }
    }
    
    return queryString;
}

+ (NSString *)encodeWithUrlStr:(NSString *)str
{
    __autoreleasing NSString *encodeStr = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)str, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    return encodeStr;
}

@end
