//
//  BBPhonePayHelper.h
//  PayDemo
//
//  Created by sunguangxin on 16/8/15.
//  Copyright © 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBPhonePayResultModel.h"

typedef NS_ENUM(NSUInteger, BBPhoneBuyVipPayWay) {
    BBPhoneBuyVipPayWayAlipay = 1,
    BBPhoneBuyVipPayWayWeixin = 2,
    BBPhoneBuyVipPayWayIAP = 3
};

typedef void(^BBPhonePayHelperHandleBlock)(id extParam);
typedef void(^BBPhonePayHelperResultBlcok)(BBPhonePayResultModel *result);

@interface BBPhonePayHelper : NSObject

/**
 *  创建订单
 */
+ (void)createVIPPaymentWithPayWay:(BBPhoneBuyVipPayWay)payWay month:(NSInteger)month productID:(NSString *)productID resultBlock:(BBPhonePayHelperResultBlcok)resultBlock;


/**
 *  appdelegate回调接口
 */
+ (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options callbackIfNeed:(BBPhonePayHelperHandleBlock)callback;
+ (BOOL)handleOpenURL:(NSURL *)url annotation:(id)annotation sourceApplication:(NSString *)sourceApplication callbackIfNeed:(BBPhonePayHelperHandleBlock)callback;


/**
 *  微信register
 */
+ (void)registerApp:(NSString *)appid withDes:(NSString *)appdes;


+ (NSString *)getVIPProductIDWithMonth:(NSInteger)month;
+ (BBPhoneBuyVipPayWay)getPayWayWithPayWayString:(NSString *)payWay;

@end
