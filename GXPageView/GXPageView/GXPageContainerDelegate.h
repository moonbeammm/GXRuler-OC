//
//  GXPageContainerDelegate.h
//  GXPageView
//
//  Created by sunguangxin on 2017/9/5.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GXPageContainerChildVCDelegate <NSObject>

- (UIViewController *)pageContainer:(UIView *)pageContainer childVC:(UIViewController *)childVC forIndex:(NSInteger)index;

@end

@protocol GXPageContainerContentDelegate <NSObject>

- (UIViewController *)childViewController:(UIViewController *)childViewController forIndex:(NSInteger)index;

- (void)contentViewDidScroll:(CGFloat)progress lastIndex:(NSInteger)lastIndex terminalIndex:(NSInteger)terminalIndex;
- (void)contentViewDidEndDecelerating:(NSInteger)terminalIndex;

@end

@protocol GXPageContainerTopBarDelegate <NSObject>

- (void)didSelectedTitleIndex:(NSInteger)index animated:(BOOL)animated;

@end
