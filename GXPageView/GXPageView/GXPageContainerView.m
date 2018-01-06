//
//  GXPageContainerView.m
//  GXPageView
//
//  Created by sunguangxin on 2017/8/30.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXPageContainerView.h"
#import "GXContainerTopBarView.h"
#import "GXContainerContentView.h"

@interface GXPageContainerView () <GXPageContainerTopBarDelegate, GXPageContainerContentDelegate>

@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, strong) GXContainerTopBarStyle *topBarStyle;

@property (nonatomic, strong) GXContainerTopBarView *topBarView;
@property (nonatomic, strong) GXContainerContentView *contentView;

@end

@implementation GXPageContainerView

- (instancetype)initWithFrame:(CGRect)frame topBarStyle:(GXContainerTopBarStyle *)topBarStyle parentVC:(UIViewController *)parentVC
{
    if (self = [super initWithFrame:frame]) {
        self.topBarStyle = topBarStyle;
        self.parentVC = parentVC;
        [self configSubviews];
    }
    return self;
}

#pragma mark - Public Method

- (void)reload
{
    
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    [self.topBarView updateTopBarContentOffsetWithIndex:index];
    [self.contentView updateContentOffSetWithIndex:index animated:animated];
}

#pragma mark - GXPageContainerTopBarDelegate

- (void)didSelectedTitleIndex:(NSInteger)index animated:(BOOL)animated
{
    [self.contentView updateContentOffSetWithIndex:index animated:animated];
}

#pragma mark - GXPageContainerContentDelegate

- (void)contentViewDidScroll:(CGFloat)progress lastIndex:(NSInteger)lastIndex terminalIndex:(NSInteger)terminalIndex
{
    [self.topBarView updateTopBarProgress:progress lastIndex:lastIndex terminalIndex:terminalIndex];
}

- (void)contentViewDidEndDecelerating:(NSInteger)terminalIndex
{
    [self.topBarView updateTopBarContentOffsetWithIndex:terminalIndex];
}

- (UIViewController *)childViewController:(UIViewController *)childViewController forIndex:(NSInteger)index
{
    return [self.childVCDelegate pageContainer:self childVC:childViewController forIndex:index];
}

#pragma mark - Initialize Method

- (void)configSubviews
{
    [self addSubview:self.topBarView];
    [self addSubview:self.contentView];
    if (self.topBarStyle.defaultSelIndex > 0) {
        [self setSelectedIndex:self.topBarStyle.defaultSelIndex animated:NO];
    }
}

- (GXContainerTopBarView *)topBarView
{
    if (_topBarView == nil) {
        CGFloat viewWidth = CGRectGetWidth(self.bounds);
        CGRect rect = CGRectMake(0, 0, viewWidth, self.topBarStyle.topBarHeight);
        _topBarView = [[GXContainerTopBarView alloc] initWithFrame:rect topBarStyle:self.topBarStyle];
        _topBarView.topBarDelegate = self;
        _topBarView.backgroundColor = self.topBarStyle.topBarBGColor;
    }
    return _topBarView;
}

- (GXContainerContentView *)contentView
{
    if (_contentView == nil) {
        CGFloat viewWidth = CGRectGetWidth(self.bounds);
        CGFloat viewHeight = CGRectGetHeight(self.bounds);
        CGRect rect = CGRectMake(0, self.topBarView.frame.size.height, viewWidth, viewHeight - self.topBarView.frame.size.height);
        _contentView = [[GXContainerContentView alloc] initWithFrame:rect topBarStyle:self.topBarStyle parentVC:self.parentVC];
        _contentView.contentViewDelegate = self;
        _contentView.backgroundColor = self.topBarStyle.contentBGColor;
    }
    return _contentView;
}

- (void)dealloc 
{
    NSLog(@"%@销毁",NSStringFromClass([self class]));
}

@end
