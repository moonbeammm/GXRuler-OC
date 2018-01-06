//
//  BBPhoneWeChatPay.h
//  PayCenter
//
//  Created by sunguangxin on 16/8/16.
//  Copyright © 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBPhonePayResultModel.h"

typedef void(^BBPhoneVIPPayResultBlock)(BBPhonePayResultModel * result);
typedef void(^BBPhonePayHelperHandleBlock)(id extParam);

@interface BBPhoneWeChatPay : NSObject

+ (instancetype)sharedManager;
/**
 *  appdelegate支付结果回调接口
 */
- (BOOL)handleOpenURL:(NSURL *)url callbackIfNeed:(BBPhonePayHelperHandleBlock)callback;

/**
 *  下单接口
 */
- (void)weixinPayWithOrder:(NSDictionary *)order callBack:(BBPhoneVIPPayResultBlock)callBack;

@end
