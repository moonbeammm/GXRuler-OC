//
//  GXTopBarTitleView.h
//  GXPageView
//
//  Created by sunguangxin on 2017/9/5.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXContainerTopBarStyle;
@interface GXTopBarTitleView : UIView

- (instancetype)initWithTopBarStyle:(GXContainerTopBarStyle *)topBarStyle title:(NSString *)title;

- (void)setTitleColor:(UIColor *)titleColor;
- (void)setTransformX:(CGFloat)x;
- (void)updateTitleViewContentFrame;
- (NSInteger)getWidth;

@end
