//
//  GXContainerTopBarView.m
//  GXPageView
//
//  Created by sunguangxin on 2017/9/4.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXContainerTopBarView.h"
#import "GXTopBarTitleView.h"
#import "GXTopBarColorHelper.h"
#import "GXContainerTopBarStyle.h"

@interface GXContainerTopBarView () <UIScrollViewDelegate>

@property (nonatomic, strong) GXContainerTopBarStyle *topBarStyle;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *indicator;

// 缓存所有标题label
@property (nonatomic, strong) NSMutableArray *titleViews;
// 缓存计算出来的每个标题的宽度
@property (nonatomic, strong) NSMutableArray *titleWidths;
// 缓存titleView渐变效果的颜色
@property (nonatomic, strong) NSArray *selectedColorArr;
@property (nonatomic, strong) NSArray *normalColorArr;
@property (nonatomic, strong) NSArray *deltaRGBArr;
// content滚动导致topbar滚动的属性
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, assign) NSInteger terminalIndex;

@end

@implementation GXContainerTopBarView

- (instancetype)initWithFrame:(CGRect)frame topBarStyle:(GXContainerTopBarStyle *)topBarStyle
{
    if (self = [super initWithFrame:frame]) {
        self.topBarStyle = topBarStyle;
        [self configSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger contentOffsetX = self.scrollView.contentOffset.x;
    self.scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
}

#pragma mark - Public Method

- (void)updateTopBarProgress:(CGFloat)progress lastIndex:(NSInteger)lastIndex terminalIndex:(NSInteger)terminalIndex
{
    if (lastIndex < 0 ||
        lastIndex >= self.topBarStyle.titles.count ||
        terminalIndex < 0 ||
        terminalIndex >= self.topBarStyle.titles.count
        ) {
        return;
    }
    self.lastIndex = terminalIndex;
    
    GXTopBarTitleView *lastTitleView = (GXTopBarTitleView *)self.titleViews[lastIndex];
    GXTopBarTitleView *terminalTitleView = (GXTopBarTitleView *)self.titleViews[terminalIndex];
    
    // 更新指示器frame
    [self updateIndicatorFrameWithProgress:progress lastTitleView:lastTitleView terminalTitleView:terminalTitleView];
    // 更新titleview的渐变色
    [self updateTitleViewGraduleColorWithProgress:progress lastTitleView:lastTitleView terminalTitleView:terminalTitleView];
    // 更新titleview的缩放
    [self updateTitleViewScaleWithProgress:progress lastTitleView:lastTitleView terminalTitleView:terminalTitleView];
}

#pragma mark - Event Response

- (void)clickTitleViewGesture:(UITapGestureRecognizer *)gesture
{
    GXTopBarTitleView *titleView = (GXTopBarTitleView *)gesture.view;
    if (!titleView) {
        return;
    }
    self.terminalIndex = titleView.tag;
    [UIView animateWithDuration:0.3 animations:^{
        [self didSelectTitleViewIndex:self.terminalIndex];
    }];
}

#pragma mark - Private Method

- (void)didSelectTitleViewIndex:(NSInteger)index
{
    // 更新topbar的titleview和indicator
    [self updateTopBarContentOffsetWithIndex:index];
    if (self.topBarDelegate && [self.topBarDelegate respondsToSelector:@selector(didSelectedTitleIndex:animated:)]) {
        // 回调更新content的contentoffset
        [self.topBarDelegate didSelectedTitleIndex:self.terminalIndex animated:YES];
    }
}

- (void)updateTopBarContentOffsetWithIndex:(NSInteger)terminalIndex
{
    if (self.titleViews.count <= terminalIndex) {
        return;
    }
    self.lastIndex = terminalIndex;
    [self updateTitleViewColorWithIndex:terminalIndex];
    [self updateIndicatorFrameWithIndex:terminalIndex];
    [self updateScrollViewContentOffSetWithIndex:terminalIndex];
}

- (void)updateTitleViewScaleWithProgress:(CGFloat)progress lastTitleView:(GXTopBarTitleView *)lastTitleView terminalTitleView:(GXTopBarTitleView *)terminalTitleView
{
    if (self.topBarStyle.animaScale <= 1) {
        return;
    }
    
    CGFloat deltaScale = self.topBarStyle.animaScale - 1.0;
    [lastTitleView setTransformX:(self.topBarStyle.animaScale - deltaScale * progress)];
    [terminalTitleView setTransformX:(1.0 + deltaScale * progress)];
}

- (void)updateTitleViewColorWithIndex:(NSInteger)index
{
    // 重置渐变/缩放效果附近其他item的缩放和颜色
    for (NSInteger i = 0; i < self.titleViews.count; i++) {
        GXTopBarTitleView *titleView = self.titleViews[i];
        if (i != index) {
            [titleView setTitleColor:self.topBarStyle.norTitleColor];
            [titleView setTransformX:1.0];
        } else {
            [titleView setTitleColor:self.topBarStyle.selTitleColor];
            if (self.topBarStyle.animaScale > 1.0) {
                [titleView setTransformX:self.topBarStyle.animaScale];
            } else {
                [titleView setTransformX:1.0];
            }
        }
    }
}

- (void)updateTitleViewGraduleColorWithProgress:(CGFloat)progress lastTitleView:(GXTopBarTitleView *)lastTitleView terminalTitleView:(GXTopBarTitleView *)terminalTitleView
{
    // 渐变
    if (self.topBarStyle.isHaveGradual) {
        UIColor *lastTitleColor = [GXTopBarColorHelper transformGradualColorWithColorRGBArr:self.selectedColorArr deltaRGBArr:self.deltaRGBArr progress:progress add:NO];
        UIColor *terminalTitleColor = [GXTopBarColorHelper transformGradualColorWithColorRGBArr:self.normalColorArr deltaRGBArr:self.deltaRGBArr progress:progress add:YES];
        [lastTitleView setTitleColor:lastTitleColor];
        [terminalTitleView setTitleColor:terminalTitleColor];
    }
}

- (void)updateIndicatorFrameWithIndex:(NSInteger)index
{
    GXTopBarTitleView *terminalTitleView = (GXTopBarTitleView *)self.titleViews[index];
    [self updateIndicatorFrameWithProgress:1.0 lastTitleView:nil terminalTitleView:terminalTitleView];
}

- (void)updateScrollViewContentOffSetWithIndex:(NSInteger)index
{
    if (self.scrollView.contentSize.width != self.scrollView.bounds.size.width) { // 需要滚动
        GXTopBarTitleView *currentTitleView = (GXTopBarTitleView *)self.titleViews[index];
        
        CGFloat offsetX = currentTitleView.center.x - self.frame.size.width * 0.5;
        if (offsetX < 0) {
            offsetX = 0;
        }
        CGFloat maxoffsetX = self.scrollView.contentSize.width - self.frame.size.width;
        
        if (maxoffsetX < 0) {
            maxoffsetX = 0;
        }
        if (offsetX > maxoffsetX) {
            offsetX = maxoffsetX;
        }
        [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

- (void)updateIndicatorFrameWithProgress:(CGFloat)progress lastTitleView:(GXTopBarTitleView *)lastTitleView terminalTitleView:(GXTopBarTitleView *)terminalTitleView
{
    if (!self.indicator) {
        return;
    }
    CGFloat titleView_X_margin = terminalTitleView.frame.origin.x - lastTitleView.frame.origin.x;
    CGFloat titleView_W_margin = terminalTitleView.frame.size.width - lastTitleView.frame.size.width;
    CGRect frame = self.indicator.frame;
    frame.origin.x = lastTitleView.frame.origin.x + titleView_X_margin * progress;
    frame.size.width = lastTitleView.frame.size.width + titleView_W_margin * progress;
    self.indicator.frame = frame;
}

#pragma mark - Initialize Method

- (void)configSubviews
{
    [self addSubview:self.scrollView];
    [self configureTitleViews];
    [self configureIndicator];
    [self configureScrollviewContentSize];
}

- (void)configureTitleViews
{
    for (NSInteger i = 0; i < self.topBarStyle.titles.count; i++) {
        GXTopBarTitleView *titleView = [self creatTitleViewTag:i];
        [self configureInitTitleColorWithTitleView:titleView tag:i];
        CGFloat titleViewWidth = [titleView getWidth];
        // 内存缓存
        [self.titleWidths addObject:@(titleViewWidth)];
        [self.titleViews addObject:titleView];
        [self.scrollView addSubview:titleView];
    }
    [self configureTitleViewFrame];
}

- (void)configureScrollviewContentSize
{
    GXTopBarTitleView *lastTitleView = [self.titleViews lastObject];
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastTitleView.frame), self.topBarStyle.topBarHeight);
}

- (GXTopBarTitleView *)creatTitleViewTag:(NSInteger)tag
{
    NSString *title = self.topBarStyle.titles[tag];
    GXTopBarTitleView *titleView = [[GXTopBarTitleView alloc] initWithTopBarStyle:self.topBarStyle title:title];
    titleView.tag = tag;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTitleViewGesture:)];
    [titleView addGestureRecognizer:tapGes];
    return titleView;
}

- (void)configureInitTitleColorWithTitleView:(GXTopBarTitleView *)titleView tag:(NSInteger)tag
{
    if (self.topBarStyle.defaultSelIndex == tag) {
        if (self.topBarStyle.animaScale > 1.0) {
            [titleView setTransformX:self.topBarStyle.animaScale];
        }
        [titleView setTitleColor:self.topBarStyle.selTitleColor];
    } else {
        [titleView setTitleColor:self.topBarStyle.norTitleColor];
    }
}

- (void)configureTitleViewFrame
{
    NSInteger startX = [self getTitleViewStartX];
    for (NSInteger i = 0; i < self.titleViews.count; i++) {
        GXTopBarTitleView *titleView = self.titleViews[i];
        NSInteger width = [self.titleWidths[i] integerValue];
        NSInteger height = self.topBarStyle.topBarHeight - self.topBarStyle.topPadding;
        titleView.frame = CGRectMake(startX, self.topBarStyle.topPadding, width, height);
        [titleView updateTitleViewContentFrame];
        startX = (startX + width + self.topBarStyle.titleMargin);
    }
}

- (void)configureIndicator
{
    if (!self.topBarStyle.showIndicator) {
        return;
    }
    switch (self.topBarStyle.indicatorStyle) {
        case GXTopBarIndicatorStyleDefault:
        case GXTopBarIndicatorStyleLine:
        {
            [self.scrollView addSubview:self.indicator];
            GXTopBarTitleView *firstTitleView = (GXTopBarTitleView *)[self.titleViews firstObject];
            NSInteger indicatorX = firstTitleView.frame.origin.x;
            NSInteger indicatorW = firstTitleView.frame.size.width;
            self.indicator.frame = CGRectMake(indicatorX, self.topBarStyle.topBarHeight - self.topBarStyle.indicatorHeight - self.topBarStyle.indicatorBottomPadding, indicatorW, self.topBarStyle.indicatorHeight);
            break;
        }
        case GXTopBarIndicatorStyleArrow:
            
            break;
        case GXTopBarIndicatorStyleSlide:
            
            break;
        default:
            break;
    }
}

- (NSInteger)getTitleViewStartX
{
    NSInteger startX = 0;
    NSInteger titleTotalWidth = 0;
    for (NSInteger i = 0; i < self.titleWidths.count; i++) {
        titleTotalWidth += [self.titleWidths[i] integerValue];
    }
    
    if (self.topBarStyle.titleMargin > 0) {
        titleTotalWidth  += self.topBarStyle.titleMargin * (self.titleWidths.count - 1);
    }
    
    switch (self.topBarStyle.layoutStyle) {
        case GXTopBarLayoutStyleDefault:
        case GXTopBarLayoutStyleCenter:
        {
            startX = (self.scrollView.frame.size.width - titleTotalWidth) / 2.0;
            break;
        }
        case GXTopBarLayoutStyleLeft:
            startX = self.topBarStyle.leftPadding;
            break;
            
        default:
            break;
    }
    return startX;
}

- (UIScrollView *)scrollView 
{
    if (_scrollView == nil) {
        NSInteger width = self.bounds.size.width - 2 * self.topBarStyle.leftPadding;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.topBarStyle.leftPadding, 0, width, self.topBarStyle.topBarHeight)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = self.topBarStyle.topBarBounces;
        _scrollView.pagingEnabled = NO;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (UIView *)indicator 
{
    if (!self.topBarStyle.showIndicator) {
        return nil;
    }
    
    if (_indicator == nil) {
        _indicator = [[UIView alloc] init];
        _indicator.backgroundColor = self.topBarStyle.indicatorColor;
        _indicator.layer.cornerRadius = self.topBarStyle.indicatorHeight / 2.0;
        _indicator.layer.masksToBounds = YES;
    }
    return _indicator;
}

- (NSMutableArray *)titleViews
{
    if (_titleViews == nil) {
        _titleViews = [NSMutableArray array];
    }
    return _titleViews;
}

- (NSMutableArray *)titleWidths
{
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}

-(NSArray *)selectedColorArr
{
    if (_selectedColorArr == nil) {
        _selectedColorArr = [GXTopBarColorHelper getRGBColorArr:self.topBarStyle.selTitleColor];
    }
    return _selectedColorArr;
}

- (NSArray *)normalColorArr
{
    if (_normalColorArr == nil) {
        _normalColorArr = [GXTopBarColorHelper getRGBColorArr:self.topBarStyle.norTitleColor];
        
    }
    return _normalColorArr;
}

- (NSArray *)deltaRGBArr
{
    if (_deltaRGBArr == nil) {
        _deltaRGBArr = [GXTopBarColorHelper getDeltaRGBWithColorA:self.selectedColorArr colorB:self.normalColorArr];
    }
    return _deltaRGBArr;
}

- (void)dealloc 
{
    NSLog(@"%@销毁",NSStringFromClass([self class]));
}

@end
