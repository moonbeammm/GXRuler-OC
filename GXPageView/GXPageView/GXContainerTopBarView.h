//
//  GXContainerTopBarView.h
//  GXPageView
//
//  Created by sunguangxin on 2017/9/4.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXPageContainerDelegate.h"

@class GXContainerTopBarStyle;
@interface GXContainerTopBarView : UIView

@property (nonatomic, weak) id<GXPageContainerTopBarDelegate> topBarDelegate;

- (instancetype)initWithFrame:(CGRect)frame topBarStyle:(GXContainerTopBarStyle *)topBarStyle;

/**
 实时更新titleView和indicator的状态
 */
- (void)updateTopBarProgress:(CGFloat)progress lastIndex:(NSInteger)lastIndex terminalIndex:(NSInteger)terminalIndex;

/**
 最后停止滑动了.再最终设置一次titleView和indicator的状态
 */
- (void)updateTopBarContentOffsetWithIndex:(NSInteger)terminalIndex;

@end


