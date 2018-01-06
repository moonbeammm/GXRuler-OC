//
//  GXContainerContentView.h
//  GXPageView
//
//  Created by sunguangxin on 2017/9/5.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXPageContainerDelegate.h"

@class GXContainerTopBarStyle;
@interface GXContainerContentView : UIView

@property (nonatomic, weak) id<GXPageContainerContentDelegate> contentViewDelegate;
- (instancetype)initWithFrame:(CGRect)frame topBarStyle:(GXContainerTopBarStyle *)topBarStyle parentVC:(UIViewController *)parentVC;

/**
 更新topBar的选中状态和contentoffset
 */
- (void)updateContentOffSetWithIndex:(NSInteger)terminalIndex animated:(BOOL)animated;

@end
