//
//  BBPhonePayResultModel.h
//  BBPhoneBase
//
//  Created by sunguangxin on 16/8/20.
//  Copyright © 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BBPhonePayErrorType) {
    BBPhonePaySuccess = 100,//成功
    BBPhonePayUserCancel,//用户点击取消并返回 1
    BBPhonePayUnsupport,// 不支持 ,未安装app 2
    BBPhonePayNetError,//网络连接错误 3
    BBPhonePayTimeOut,// 网络超时
    BBPhonePayFailCreateOrder,//创建订单失败 4
    BBPhonePayVerifyFail,// 与后台验证失败 5
    BBPhonePaySentFail,// 发送失败
    BBPhonePayAuthDeny,//授权失败
    BBPhonePayCommon,//未知错误,反正就是错了.
    BBPhonePayRequestingError,// 重复发送请求
    BBPhonePayEmptyOrder,// 订单号为空
    BBPhonePayNoThisWay,//没有这种支付方式
    BBPhonePayIsHandle,//正在处理中
    BBPhonePayOrderDealErr,//订单支付失败
    BBPhonePayIAPAccessErrorType,//内购失败：支付逻辑错误
    BBPhonePayInAppPurchaseErrorType,//连接不到appstore.用户点击取消.
    BBPhonePayIAPCheckReceiptErrorType,//内购成功: 校验失败，请与客服联系
    BBPhonePayCheatErrorType,//越狱导致连接不到appstore
    BBPhonePayCheckOrderErrorType,//内购成功: 查单失败，请与客服联系
    BBPhonePayBusinessErrorType//内购失败：业务逻辑错误
};

@interface BBPhonePayResultModel : NSObject

@property (nonatomic, strong) NSString *resultStr;
@property (nonatomic, assign) BBPhonePayErrorType resultCode;
@property (nonatomic, strong) NSString *orderNo;
/**
 *  0:成为月费会员
 *  1:本来就是年费.又充值了年费.
 *  2:本来不是年费.充值了年费.
 */
@property (nonatomic, assign) NSInteger vipType;


@end
