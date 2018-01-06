//
//  BBPhoneBuyVipOrderModel.h
//  BBPhoneBase
//
//  Created by sunguangxin on 16/8/19.
//  Copyright © 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBPhoneBuyVipOrderModel : NSObject

/**
*  当pay_way为bp时，1:支付成功，2支付失败
*/
@property (nonatomic, assign) NSInteger status;

/**
 *  充支付中心消费订单号.(未使用)
 */
@property (nonatomic, copy) NSString *payPayOrderNo;

/**
 *  订单号.用来向VIP后台查询结果的.
 */
@property (nonatomic, copy) NSString *orderNo;

/**
 *  订单号,传给微信支付宝的.
 */
@property (nonatomic, copy) NSString *paySign;

/**
 *  IAP的消费单号.用于查询结果
 */
@property (nonatomic, strong) NSString *rechargeOrderNo;

@end
