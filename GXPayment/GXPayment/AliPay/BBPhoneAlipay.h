//
//  BBPhoneAlipay.h
//  PayCenter
//
//  Created by sunguangxin on 16/8/16.
//  Copyright © 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBPhonePayResultModel.h"

typedef void(^BBPhoneVIPPayResultBlock)(BBPhonePayResultModel *result);
typedef void(^BBPhoneVIPPayHandleBlock)(id extParam);

@interface BBPhoneAlipay : NSObject

/**
 *  支付接口
 */
+ (void)alipayWithOrder:(NSString *)order callBack:(BBPhoneVIPPayResultBlock)callBack;

/**
 *  appdelegate回调接口
 */
+ (void)handleOpenURL:(NSURL *)url callbackIfNeed:(BBPhoneVIPPayHandleBlock)callback;

@end
