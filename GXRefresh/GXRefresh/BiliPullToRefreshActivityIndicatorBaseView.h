//
//  BiliPullToRefreshActivityIndicatorBaseView.h
//  BiliCore
//
//  Created by chenguang on 17/3/8.
//  Copyright © 2017年 bilibili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BiliPullToRefreshActivityIndicatorBaseView : UIView

+ (id)view;

- (void)statePercentage:(CGFloat)percentage;
- (void)stopAnimating;
- (void)startAnimating;
- (void)setStateStrings:(NSArray *)titles;

@end

@interface BiliPullToRefreshActivityIndicatorView : BiliPullToRefreshActivityIndicatorBaseView

@end

@interface BiliPullToRefreshActivityIndicatorViewM2 : BiliPullToRefreshActivityIndicatorBaseView

@end
