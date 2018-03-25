//
//  BBPhoneAlipay.m
//  PayCenter
//
//  Created by sunguangxin on 16/8/16.
//  Copyright © 2016年. All rights reserved.
//

#import "BBPhoneAlipay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"

@implementation BBPhoneAlipay

+ (void)handleOpenURL:(NSURL *)url callbackIfNeed:(BBPhoneVIPPayHandleBlock)callback
{
    // 支付宝appdelegate回调方法.
//    if ([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            if (callback) {
//                callback(resultDic);
//            }
//        }];
//    }
}

+ (void)alipayWithOrder:(NSString *)orderString callBack:(BBPhoneVIPPayResultBlock)callBack
{
//    NSString *appScheme = @"gx";
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//        NSInteger code = [[resultDic objectForKey:@"resultStatus"] integerValue];
//        BBPhonePayResultModel * res = [BBPhonePayResultModel new];
//        switch (code) {
//            case 9000:
//            {
//                res.resultStr = @"成功";
//                res.resultCode = BBPhonePaySuccess;
//            }
//                break;
//                
//            case 8000:
//            {
//                res.resultStr = @"正在处理中";
//                res.resultCode = BBPhonePayIsHandle;
//            }
//                break;
//                
//            case 4000:
//            {
//                res.resultStr = @"订单支付失败";
//                res.resultCode = BBPhonePayOrderDealErr;
//            }
//                break;
//                
//            case 6001:
//            {
//                res.resultStr = @"用户点击取消并返回";
//                res.resultCode = BBPhonePayUserCancel;
//                
//            }
//                break;
//                
//            case 6002:
//            {
//                res.resultStr = @"网络连接出错";
//                res.resultCode = BBPhonePayUnsupport;
//            }
//                break;
//                
//            default:
//            {
//                res.resultCode = BBPhonePayCommon;
//                res.resultStr = @"普通错误";
//            }
//                break;
//        }
//        if (callBack) {
//            callBack(res);
//        }
//    }];
}

@end
