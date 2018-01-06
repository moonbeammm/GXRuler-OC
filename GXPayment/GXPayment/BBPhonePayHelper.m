//
//  BBPhonePayHelper.m
//  PayDemo
//
//  Created by sunguangxin on 16/8/15.
//  Copyright © 2016年. All rights reserved.
//

#import "BBPhonePayHelper.h"
#import "BBPhoneAlipay.h"
#import "BBPhoneWeChatPay.h"
#import "WXApi.h"
#import "BBPhoneBuyVipOrderAPI.h"
#import "BBPhoneBuyVipOrderModel.h"
//#import "BBPhoneStore.h"
#import "BBPhoneVIPPayVerifyAPI.h"
#import "BBPhoneVIPPayVerifyModel.h"
//#import "BBPhoneStoreVIPAlertView.h"

@implementation BBPhonePayHelper

+ (void)registerApp:(NSString *)appid withDes:(NSString *)appdes
{
//    [WXApi registerApp:appid withDescription:appdes];
}

#pragma mark - appdelegate回调接口

+ (BOOL)handleOpenURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options callbackIfNeed:(BBPhonePayHelperHandleBlock)callback
{
//    NSString *annotation = options[@"UIApplicationOpenURLOptionsSourceApplicationKey"];
//    return [BBPhonePayHelper handleOpenURL:url annotation:annotation sourceApplication:nil callbackIfNeed:callback];
    return NO;
}

+ (BOOL)handleOpenURL:(NSURL *)url annotation:(id)annotation sourceApplication:(NSString *)sourceApplication callbackIfNeed:(BBPhonePayHelperHandleBlock)callback
{
//    // sgx: 容错处理.此处annotation可能为NSDictionary类型.导致crash
//    if (url == nil && [annotation isKindOfClass:[NSString class]] && [sourceApplication isKindOfClass:[NSString class]]) {
//        return NO;
//    }
//    if ([annotation isEqualToString:@"com.tencent.xin"]) {
//        //微信支付回调
//        return [[BBPhoneWeChatPay sharedManager] handleOpenURL:url callbackIfNeed:callback];
//    }else if ([annotation isEqualToString:@"com.alipay.iphoneclient"]) {
//        //支付宝支付回调
//        [BBPhoneAlipay handleOpenURL:url callbackIfNeed:callback];
//        return YES;
//    }else if ([sourceApplication isEqualToString:@"com.alipay.iphoneclient"]) {
//        //支付宝支付回调
//        [BBPhoneAlipay handleOpenURL:url callbackIfNeed:callback];
//        return YES;
//    }else if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
//        //微信支付回调
//        return [[BBPhoneWeChatPay sharedManager] handleOpenURL:url callbackIfNeed:callback];
//    }
    return NO;
}

#pragma mark - VIP下单接口

//static NSInteger oldVipDueDate;
//static NSInteger oldVipType;

+ (void)createVIPPaymentWithPayWay:(BBPhoneBuyVipPayWay)payWay month:(NSInteger)month productID:(NSString *)productID resultBlock:(BBPhonePayHelperResultBlcok)resultBlock
{
//    BBPhoneBuyVipOrderAPI * api = [BBPhoneBuyVipOrderAPI new];
//    BBPhonePayResultModel * res = [BBPhonePayResultModel new];
//    oldVipDueDate = [[BiliMember sharedMember] memberInfo].vipInfo.vipDueDate;
//    oldVipType = [[BiliMember sharedMember] memberInfo].vipInfo.vipType;
//    api.payWay = [BBPhonePayHelper getPayWayStringWithPayWay:payWay];
//    api.vipMonth = month;
//    api.productId = productID;
//    api.completionHandler = ^(NSDictionary * result){
//        BBPhoneBuyVipOrderModel * order = result[@"/data"];
//        
//        [BBPhonePayHelper payWithPayWay:payWay payOrder:order productID:productID resultBlock:resultBlock];
//    };
//    
//    api.errorHandler = ^(BiliError *error, id x){
//        [[BBPhoneStore defaultStore] stopQuerying];
//        if (resultBlock) {
//            res.resultCode = BBPhonePayTimeOut;
//            res.resultStr = @"网络超时";
//            resultBlock(res);
//        }
//    };
//    [api addToQueueAsync];
}

+ (void)payWithPayWay:(BBPhoneBuyVipPayWay)payway payOrder:(BBPhoneBuyVipOrderModel *)order productID:(NSString *)productID resultBlock:(BBPhonePayHelperResultBlcok)resultBlock
{
//    if (!(order &&
//          order.orderNo &&
//          [order.orderNo length] > 0 &&
//          productID &&
//          [productID length] > 0))
//    {
//        if (resultBlock) {
//            BBPhonePayResultModel * result = [BBPhonePayResultModel new];
//            result.resultCode = BBPhonePayEmptyOrder;
//            result.resultStr = @"订单号为空";
//            resultBlock(result);
//        }
//        return;
//    }
//    
//    switch (payway) {
//        case BBPhoneBuyVipPayWayAlipay:
//        {
//            NSString * orderString = [order.paySign stringByRemovingPercentEncoding];
//            NSString * verifyOrder = order.orderNo;
////            [BBPhoneStoreVIPAlertView close];
//            [BBPhoneAlipay alipayWithOrder:orderString callBack:^(BBPhonePayResultModel *result) {
//                if (result.resultCode) {
//                    if (result.resultCode == BBPhonePaySuccess) {
////                        [BBPhoneStoreVIPAlertView showLoadingView];
//                        [BBPhonePayHelper verifyResultWithOrderNo:verifyOrder checkTime:0 resultBlock:resultBlock];
//                    } else {
//                        if (resultBlock) {
//                            result.orderNo = order.orderNo;
//                            resultBlock(result);
//                        }
//                    }
//                }
//            }];
//        }
//            break;
//
//        case BBPhoneBuyVipPayWayWeixin:
//        {
//            NSDictionary * payOrder = [BBPhonePayHelper dictionaryWithURLString:order.paySign];
//            NSString * verifyOrder = order.orderNo;
////            [BBPhoneStoreVIPAlertView close];
//            [[BBPhoneWeChatPay sharedManager] weixinPayWithOrder:payOrder callBack:^(BBPhonePayResultModel *result) {
//                if (result.resultCode) {
//                    if (result.resultCode == BBPhonePaySuccess) {
////                        [BBPhoneStoreVIPAlertView showLoadingView];
//                        [BBPhonePayHelper verifyResultWithOrderNo:verifyOrder checkTime:0 resultBlock:resultBlock];
//                    } else {
//                        if (resultBlock) {
//                            result.orderNo = order.orderNo;
//                            resultBlock(result);
//                        }
//                    }
//                }
//            }];
//        }
//            break;
//
//        case BBPhoneBuyVipPayWayIAP:
//        {
//            BBPhonePayResultModel * res = [BBPhonePayResultModel new];
//            NSString * verifyOrder = order.orderNo;
//            NSString * rechargeOrderNo = order.rechargeOrderNo;
//            NSString * pay_order_no = order.payPayOrderNo;
//            [[BBPhoneStore defaultStore] vipPayWithProduct_id:productID order_no:rechargeOrderNo info:nil success:^(NSString *productId, NSDictionary *info) {
//                // 支付成功并和后台验证成功.还要跟业务方验证.
//                [BBPhonePayHelper verifyResultWithOrderNo:verifyOrder checkTime:0 resultBlock:resultBlock];
//            } failure:^(BBPhoneStoreErrorType errorType, SKPaymentTransaction *transaction, NSError *error) {
//                if (resultBlock) {
//                    res.resultCode = BBPhonePayCommon;
//                    res.resultStr = @"其他错误";
//                    res.orderNo = order.orderNo;
//                    switch (errorType) {
//                        case BBPhoneStoreInAppPurchaseErrorType:
//                        {
//                            if (transaction.error.code == 2) { // 用户取消
//                                res.resultCode = BBPhonePayUserCancel;
//                                res.resultStr = @"用户取消购买";
//                            } else {
//                                res.resultCode = BBPhonePayCheatErrorType;
//                                res.resultStr = @"越狱导致连接不到appstore";
//                            }
//                        }
//                            break;
//                            
//                        case BBPhoneStoreCheatErrorType:
//                        {
//                            res.resultCode = BBPhonePayCheatErrorType;
//                            res.resultStr = @"内购失败: 检测到越狱渠道";
//                        }
//                            break;
//                            
//                        case BBPhoneStoreBusinessErrorType:
//                        {
//                            res.resultCode = BBPhonePayBusinessErrorType;
//                            res.resultStr = @"内购失败：业务逻辑错误";
//                        }
//                            break;
//                            
//                        case BBPhoneStoreRequestingErrorType:
//                        {
//                            res.resultCode = BBPhonePayRequestingError;
//                            res.resultStr = @"内购失败：之前的内购仍在进行中";
//                        }
//                            break;
//                            
//                        case BBPhoneStoreIAPAccessErrorType:
//                        {
//                            res.resultCode = BBPhonePayIAPAccessErrorType;
//                            res.resultStr = @"内购失败：支付逻辑错误";
//                        }
//                            break;
//                            
//                        case BBPhoneStoreIAPCheckReceiptErrorType:
//                        {
//                            res.resultCode = BBPhonePayIAPCheckReceiptErrorType;
//                            res.resultStr = @"内购成功: 校验失败，请与客服联系";
//                        }
//                            break;
//                            
//                        case BBPhoneStoreCheckOrderErrorType:
//                        {
//                            res.resultCode = BBPhonePayCheckOrderErrorType;
//                            res.resultStr = @"内购成功: 查单失败，请与客服联系";
//                        }
//                            break;
//                            
//                        default:
//                            break;
//                    }
//                    resultBlock(res);
//                }
//            } checkFailure:^(BOOL isChargeSuccess, NSDictionary * info) {
//                if (resultBlock) {
//                    res.resultCode = BBPhonePayVerifyFail;
//                    res.resultStr = @"验证失败";
//                    res.orderNo = order.orderNo;
//                    resultBlock(res);
//                }
//            } isRecharge:YES pay_order_no:pay_order_no];
//        }
//            break;
//
//        default:
//        {
//            if (resultBlock) {
//                BBPhonePayResultModel * result = [BBPhonePayResultModel new];
//                result.resultCode = BBPhonePayNoThisWay;
//                result.resultStr = @"没有这种支付方式";
//                result.orderNo = order.orderNo;
//                resultBlock(result);
//            }
//        }
//            break;
//    }
}

#pragma mark - 跟vip端验证

+ (void)verifyResultWithOrderNo:(NSString *)order_no checkTime:(NSInteger)checkTime resultBlock:(BBPhonePayHelperResultBlcok)resultBlock
{
//    BBPhoneVIPPayVerifyAPI *checkApi = [BBPhoneVIPPayVerifyAPI new];
//    checkApi.order_no = order_no;
//    BBPhonePayResultModel * res = [BBPhonePayResultModel new];
//    checkApi.completionHandler = ^(NSDictionary *result) {
//        BBPhoneVIPPayVerifyModel * model = result[@"/data"];
//        if (model.status == 2) {
//            // 验证成功
//            [BBPhonePayHelper verifyVipDueDateWithOrderNo:order_no checkTime:0 resultBlock:resultBlock];
//        } else {
//            // 验证失败
//            if (checkTime < 3) {
//                // 延迟1秒重复三次
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                    [BBPhonePayHelper verifyResultWithOrderNo:order_no checkTime:(checkTime + 1) resultBlock:resultBlock];
//                });
//            } else {
//                // 若三次都验证失败，则认为失败
//                if (resultBlock) {
//                    res.resultStr = @"验证失败";
//                    res.resultCode = BBPhonePayVerifyFail;
//                    res.orderNo = order_no;
//                    resultBlock(res);
//                }
//            }
//        }
//    };
//    checkApi.errorHandler = ^(BiliError *error, id result) {
//        if (resultBlock) {
//            res.resultStr = @"网络异常";
//            res.resultCode = BBPhonePayNetError;
//            res.orderNo = order_no;
//            resultBlock(res);
//        }
//    };
//    [checkApi addToQueueAsync];
}

#pragma mark - 跟myinfo接口的vipDueDate验证

+ (void)verifyVipDueDateWithOrderNo:(NSString *)order_no checkTime:(NSInteger)checkTime resultBlock:(BBPhonePayHelperResultBlcok)resultBlock
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //异步获取myinfo信息,延时0,5s.让后台有同步的时间.
//        [[BiliMember sharedMember] updateMemberInfoSyncBlock:^(BiliMemberInfo *memberInfo) {
//            if (memberInfo.vipInfo.vipDueDate != oldVipDueDate) {
//                dispatch_async(dispatch_get_main_queue(), ^(){
//                    [BBPhonePayHelper verifyWithNewVipType:memberInfo.vipInfo.vipType orderNo:order_no resultBlock:resultBlock];
//                });
//            }
//            else {
//                if (checkTime < 3) {
//                    [BBPhonePayHelper verifyVipDueDateWithOrderNo:order_no checkTime:(checkTime + 1) resultBlock:resultBlock];
//                } else {
//                    dispatch_async(dispatch_get_main_queue(), ^(){
//                        //主线程报失败
//                        if (resultBlock) {
//                            BBPhonePayResultModel * res = [BBPhonePayResultModel new];
//                            res.resultCode = BBPhonePayVerifyFail;
//                            res.resultStr = @"验证失败";
//                            res.orderNo = order_no;
//                            resultBlock(res);
//                        }
//                    });
//                }
//            }
//        }];
//    });
}

#pragma makr - 跟myinfo接口的viptype验证

+ (void)verifyWithNewVipType:(NSInteger)newVipType orderNo:(NSString *)orderNo resultBlock:(BBPhonePayHelperResultBlcok)resultBlock
{
//    BBPhonePayResultModel * res = [BBPhonePayResultModel new];
//    res.orderNo = orderNo;
//    if (newVipType == 2) {
//        if (oldVipType == 2) {
//            // 显示普通年费弹窗
//            res.resultCode = BBPhonePaySuccess;
//            res.resultStr = @"支付成功";
//            res.vipType = 1;
//        } else {
//            // 显示年费弹窗
//            res.resultCode = BBPhonePaySuccess;
//            res.resultStr = @"支付成功";
//            res.vipType = 2;
//        }
//    } else if (newVipType == 1) {
//        //显示月费弹窗
//        res.resultCode = BBPhonePaySuccess;
//        res.resultStr = @"支付成功";
//        res.vipType = 0;
//    } else {
//        res.resultCode = BBPhonePayVerifyFail;
//        res.resultStr = @"验证失败";
//        res.vipType = -1;
//    }
//    
//    if (resultBlock) {
//        resultBlock(res);
//    }
}

#pragma mark - Helper

/**
 *  转换支付方式
 */
+ (NSString *)getPayWayStringWithPayWay:(BBPhoneBuyVipPayWay)payWay
{
    NSString * string = nil;
    switch (payWay) {
        case BBPhoneBuyVipPayWayIAP:
        {
            string = @"iospay";
        }
            break;
            
        case BBPhoneBuyVipPayWayAlipay:
        {
            string = @"alipay";
        }
            break;
            
        case BBPhoneBuyVipPayWayWeixin:
        {
            string = @"wechat";
        }
            break;
            
        default:
            break;
    }
    return string;
}

/**
 *  将后台返回的paySign(URLString)解析成字典.
 */
+ (NSDictionary *)dictionaryWithURLString:(NSString *)URLStr
{
    if (URLStr == nil) {
        return nil;
    }
    NSString * encoded = URLStr;
    NSString * decoded = [encoded stringByRemovingPercentEncoding];
    NSData *jsonData = [decoded dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return dic;
}

+ (NSString *)getVIPProductIDWithMonth:(NSInteger)month
{
//    switch (month) {
//        case 1:
//        {
//            return BILI_IAP_VIP_1;
//        }
//            break;
//            
//        case 3:
//        {
//            return BILI_IAP_VIP_3;
//        }
//            break;
//            
//        case 12:
//        {
//            return BILI_IAP_VIP_12;
//        }
//            break;
//            
//        default:
//            return @"unknown productID";
//            break;
//    }
    return nil;
}

+ (BBPhoneBuyVipPayWay)getPayWayWithPayWayString:(NSString *)payWay
{
    if ([payWay isEqualToString:@"iospay"]) {
        return BBPhoneBuyVipPayWayIAP;
    } else if ([payWay isEqualToString:@"alipay"]) {
        return BBPhoneBuyVipPayWayAlipay;
    } else if ([payWay isEqualToString:@"wechat"]) {
        return BBPhoneBuyVipPayWayWeixin;
    }
    return 0;
}

@end
