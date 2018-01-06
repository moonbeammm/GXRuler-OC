//
//  BBPhoneVIPPayVerifyAPI.m
//  BBPhoneBase
//
//  Created by sunguangxin on 16/8/18.
//  Copyright © 2016年. All rights reserved.
//

#import "BBPhoneVIPPayVerifyAPI.h"
#import "BBPhoneVIPPayVerifyModel.h"

@implementation BBPhoneVIPPayVerifyAPI
- (NSDictionary *)apiConfig
{
//    NSMutableDictionary * mConfig = [NSMutableDictionary dictionaryWithDictionary:[super apiConfig]];
//    mConfig[ConfigApiPath] = @"";
//    mConfig[ConfigRequestMethod] = @(GET);
//    return mConfig;
    return nil;
}

- (NSDictionary<NSString *,NSString *> *)params
{
    return @{
             @"order_no": _order_no ? : @""
             };
}

@end
