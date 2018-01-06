//
//  UIView+Frame.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (nonatomic, assign) CGPoint viewOrigin;
@property (nonatomic, assign) CGSize viewSize;
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, assign) CGFloat viewHeight;
@property (nonatomic, assign) CGFloat viewMinX;
@property (nonatomic, assign) CGFloat viewMinY;
@property (nonatomic, assign) CGFloat viewMaxX;
@property (nonatomic, assign) CGFloat viewMaxY;
@property (nonatomic, assign) CGFloat viewMidX;
@property (nonatomic, assign) CGFloat viewMidY;

@end
