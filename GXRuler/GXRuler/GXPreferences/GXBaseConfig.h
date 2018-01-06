//
//  GXBaseConfig.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXBasePreferences.h"

/**
 * 全局通用基础信息保存类
 */
@interface GXBaseConfig : GXBasePreferences

// 你要保存的字段名
@property (nonatomic, assign) BOOL inReview;

@property (nonatomic, assign) BOOL isNightMode;

@end
