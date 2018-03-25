//
//  NSString+RouterUrl.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/15.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "NSString+RouterUrl.h"

#define GXDOMAINSUFFIX "com|tv|cn|co"

static NSRegularExpression *httpRegrex;
static NSRegularExpression *homeRegrex;

@implementation NSString (RouterUrl)

- (BOOL)isWebUrl
{
    if (!self) {
        return NO;
    }
    if ([[self lowercaseString] rangeOfString:@"http"].location == NSNotFound) {
        return NO;
    }
    if (!httpRegrex) {
        NSString *pattern = @"^((?:(http|https|Http|Https|rtsp|Rtsp):\\/\\/(?:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,64}(?:\\:(?:[a-zA-Z0-9\\$\\-\\_\\.\\+\\!\\*\\'\\(\\)\\,\\;\\?\\&\\=]|(?:\\%[a-fA-F0-9]{2})){1,25})?\\@)?)?(?:(([a-zA-Z0-9\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]([a-zA-Z0-9\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF\\-]{0,61}[a-zA-Z0-9\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]){0,1}\\.)+[a-zA-Z0-9\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]{2,63}|((25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9])\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[1-9]|0)\\.(25[0-5]|2[0-4][0-9]|[0-1][0-9]{2}|[1-9][0-9]|[0-9]))))(?:\\:\\d{1,5})?)(\\/(?:(?:[a-zA-Z0-9\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF\\;\\/\\?\\:\\@\\&\\=\\#\\~\\-\\.\\+\\!\\*\\'\\(\\)\\,\\_])|(?:\\%[a-fA-F0-9]{2}))*)?(?:\\b|$)";
        httpRegrex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    }
    
    NSArray *matches = [httpRegrex matchesInString:self
                                           options:0
                                             range:NSMakeRange(0, [self length])];
    if (nil != matches && matches.count > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isDirectOpenUrl
{
    if (!self) {
        return NO;
    }
    if ([[self lowercaseString] hasPrefix:@"https://itunes.apple.com"]) {
        return YES;
    }
    if ([[self lowercaseString] hasPrefix:@"https://appsto.re"]) {
        return YES;
    }
    return NO;
}

- (NSString *)tryTransferToAppScheme
{
    if (!self) {
        return self;
    }
    
    NSString *ans = [self transferToAvScheme];
    if (ans) return ans;
    
    return self;
}

- (NSString *)transferToAvScheme
{
    if (!self) {
        return nil;
    }
    if (!homeRegrex) {
        // @"home\\.("GXDOMAINSUFFIX")\\/(\\d+)\\#\\!epid\\=(\\d+)" 这个url就包含了两个参数
        // 下面这个只有一个参数
        homeRegrex = [NSRegularExpression regularExpressionWithPattern:@"live\\.("GXDOMAINSUFFIX")\\/(\\d+)" options:NSRegularExpressionCaseInsensitive error:nil];
    }

    NSArray *matches = [homeRegrex matchesInString:self
                                           options:0
                                             range:NSMakeRange(0, [self length])];
    if (nil != matches && matches.count > 0) {
        for (NSTextCheckingResult *match in matches) {
            if (match.numberOfRanges == 4) {
                NSRange r = [match rangeAtIndex:2];
                NSRange e = [match rangeAtIndex:3];
                // 这里/?selectedEpId=%@表示为可选项.可能会有这个参数.也可以没有.(selecteEpId为你自定义的参数名.取值得时候就用这个key)
                return [NSString stringWithFormat:@"home/%@/?selectedEpId=%@",[self substringWithRange:r],[self substringWithRange:e]];
            }
        }
    }
    return nil;
}


@end
