//
//  BBPhoneWeChatPay.m
//  PayCenter
//
//  Created by sunguangxin on 16/8/16.
//  Copyright © 2016年. All rights reserved.
//

#import "BBPhoneWeChatPay.h"
//#import "WXApi.h"

@interface BBPhoneWeChatPay()//<WXApiDelegate>

//@property (nonatomic, copy) void (^resultBlock)(BaseResp * resultResp);

@end

@implementation BBPhoneWeChatPay

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static BBPhoneWeChatPay *instance;
    dispatch_once(&onceToken, ^{
        instance = [[BBPhoneWeChatPay alloc] init];
    });
    return instance;
}

// 从delegate拿到结果后的回调方法.
- (BOOL)handleOpenURL:(NSURL *)url callbackIfNeed:(BBPhonePayHelperHandleBlock)callback
{
//    return [WXApi handleOpenURL:url delegate:self];
    return NO;
}

// 处理支付结果
//- (void)onResp:(BaseResp *)resp
//{
//    if ([resp isKindOfClass:[PayResp class]]) {
//        self.resultBlock(resp);
//    }
//}

- (void)weixinPayWithOrder:(NSDictionary *)order callBack:(BBPhoneVIPPayResultBlock)callBack
{
//    if (![WXApi isWXAppInstalled]) {
//        if (callBack) {
//            BBPhonePayResultModel * result = [BBPhonePayResultModel new];
//            result.resultCode = BBPhonePayUnsupport;
//            result.resultStr = @"未安装微信";
//            callBack(result);
//        }
//        return;
//    }
//    
//    if (order == nil) {
//        if (callBack) {
//            BBPhonePayResultModel *result = [[BBPhonePayResultModel alloc] init];
//            result.resultCode = BBPhonePaySentFail;
//            result.resultStr = @"发生未知错误";
//            callBack(result);
//        }
//        return;
//    }
//    
//    NSAssert(order && [order isKindOfClass:[NSDictionary class]], @"参数Order必须非空，并且必须是键值对.");
//    
//    [self setResultBlock:^(BaseResp * WXResp) {
//        BBPhonePayResultModel * res = [BBPhonePayResultModel new];
//        switch (WXResp.errCode) {
//            case WXSuccess: {
//                res.resultStr = @"成功";
//                res.resultCode = BBPhonePaySuccess;
//            } break;
//                
//            case WXErrCodeUserCancel: {
//                res.resultStr = @"用户点击取消并返回";
//                res.resultCode = BBPhonePayUserCancel;
//            } break;
//                
//            case WXErrCodeSentFail: {
//                res.resultStr = @"发送失败";
//                res.resultCode = BBPhonePaySentFail;
//            } break;
//                
//            case WXErrCodeAuthDeny: {
//                res.resultStr = @"授权失败";
//                res.resultCode = BBPhonePayAuthDeny;
//            } break;
//                
//            case WXErrCodeUnsupport: {
//                res.resultStr = @"微信不支持";
//                res.resultCode = BBPhonePayUnsupport;
//            } break;
//                
//            default: {
//                res.resultCode = BBPhonePayCommon;
//                res.resultStr = @"普通错误";
//            } break;
//        }
//        if (callBack) {
//            callBack(res);
//        }
//    }];
//    
//    // 调起微信支付
//    PayReq* req             = [[PayReq alloc] init];
//    req.partnerId           = order[@"partnerid"];
//    req.prepayId            = order[@"prepayid"];
//    req.nonceStr            = order[@"noncestr"];
//    req.timeStamp           = [order[@"timestamp"] intValue];
//    req.package             = order[@"package"];
//    req.sign                = order[@"sign"];
//    
//    [WXApi sendReq:req];
    
    return;
}

@end
