//
//  GXPageContainerView.h
//  GXPageView
//
//  Created by sunguangxin on 2017/8/30.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXPageContainerDelegate.h"
#import "GXContainerTopBarStyle.h"

@interface GXPageContainerView : UIView

@property (nonatomic, weak) id<GXPageContainerChildVCDelegate> childVCDelegate;


/**
 使用方法.
 1.通过初始化方法创建pageContainer
 2.设置pageContainer的代理
 3.实现pageContainer的代理方法.返回对应的vc
 4.必须设置self.automaticallyAdjustsScrollViewInsets = NO;
 
 初始化pageContainer方法

 @param frame pageContainer的frame
 @param topBarStyle 自定义pageContainer样式.必须设置titles属性.
 @param parentVC pageContainer的父vc
 @return pageContainer
 */
- (instancetype)initWithFrame:(CGRect)frame topBarStyle:(GXContainerTopBarStyle *)topBarStyle parentVC:(UIViewController *)parentVC;

- (void)reload;
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;

@end
