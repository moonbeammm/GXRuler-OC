//
//  NSURL+Utility.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSURL (Utility)

- (NSURL *)transferHttpToHttps;

/// pxSize: 图片真实像素大小
- (NSURL *)imageURLWithPxSize:(CGSize)pxSize;

/// 获取webp格式图片(仅处理/bfs/路径下图片; 非/bfs/下且size不为CGSizeZero将调用imageURLWithSize:) pxSize为CGSizeZero时不剪裁
/// pxSize: 图片真实像素大小
- (NSURL *)webpImageURLWithPxSize:(CGSize)pxSize;

@end
