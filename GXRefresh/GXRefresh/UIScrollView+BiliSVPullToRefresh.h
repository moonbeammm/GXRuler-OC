//
//  UIScrollView+BiliSVPullToRefresh.h
//
//
//  Created by gx on 17/3/13.
//  Copyright © 2017年 gx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AvailabilityMacros.h>

@class BiliPullToRefreshActivityIndicatorBaseView;
typedef NS_ENUM(NSUInteger, SVPullToRefreshState) {
    SVPullToRefreshStateStopped = 0,
    SVPullToRefreshStateTriggered,
    SVPullToRefreshStateLoading,
    SVPullToRefreshStateAll = 10
};

typedef NS_ENUM(NSUInteger, SVPullToRefreshPosition) {
    SVPullToRefreshPositionTop = 0,
    SVPullToRefreshPositionBottom,
};










@interface BiliSVPullToRefreshView : UIView

@property (nonatomic, strong, readwrite) UIColor *activityIndicatorViewColor NS_AVAILABLE_IOS(5_0);
@property (nonatomic, readonly) BiliPullToRefreshActivityIndicatorBaseView *activityIndicatorView;

@property (nonatomic, readonly) SVPullToRefreshState state;
@property (nonatomic, readonly) SVPullToRefreshPosition position;

- (void)startAnimating;
- (void)stopAnimating;

// deprecated; use [self.scrollView triggerPullToRefresh] instead
- (void)triggerRefresh DEPRECATED_ATTRIBUTE;

@end











@interface UIScrollView (BiliSVPullToRefresh)
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(SVPullToRefreshPosition)position;
- (void)triggerPullToRefresh;

@property (nonatomic, strong) BiliSVPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showsPullToRefresh;
@end














@interface BiliSVPullToRefreshViewM2 : BiliSVPullToRefreshView

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
@property (nonatomic, weak) UIScrollView *scrollView;

@end
















// 给UICollectionView添加下拉刷新 top view（因collectionView滚动时会条用setContentSize方法，所以重写监听方法)
@interface BiliSVCollectionPullToRefreshView : BiliSVPullToRefreshView
@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalTopInset;

+ (CGFloat)defaultHeight;

@end


