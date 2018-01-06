//
//  BBPhoneVIPPayVerifyModel.h
//  BBPhoneBase
//
//  Created by sunguangxin on 16/8/20.
//  Copyright © 2016年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBPhoneVIPPayVerifyModel : NSObject

/**
 *  订单状态,1:充值中.2:充值成功.3:充值失败
 */
@property (nonatomic, assign) NSInteger status;

/**
 *  消费订单
 */
@property (nonatomic, strong) NSString *orderNo;

@end
