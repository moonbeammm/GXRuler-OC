//
//  BBPhoneBuyVipOrderAPI.m
//  BBPhone
//
//  Created by sunguangxin on 16/8/15.
//  Copyright © 2016年. All rights reserved.
//

#import "BBPhoneBuyVipOrderAPI.h"
#import "BBPhoneBuyVipOrderModel.h"

@implementation BBPhoneBuyVipOrderAPI
- (NSDictionary *)apiConfig
{
//    NSMutableDictionary * mConfig = [NSMutableDictionary dictionaryWithDictionary:[super apiConfig]];
//    mConfig[ApiPath] = @"";
//    mConfig[RequestMethod] = @(POST);
//    return mConfig;
    return nil;
}

- (NSDictionary *)extHTTPHeaderFields
{
    return @{
             @"Content-Type" : @"application/json"
             };
}

- (NSDictionary *)params
{
    NSDictionary *params = @{
                             @"months" : [NSString stringWithFormat:@"%zd",_vipMonth],
                             @"payWay" : _payWay,
                             @"productId":_productId
                             };
    return params;
}

@end
