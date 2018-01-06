//
//  GXContainerContentView.m
//  GXPageView
//
//  Created by sunguangxin on 2017/9/5.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXContainerContentView.h"
#import "GXContainerTopBarStyle.h"

@interface GXContainerContentView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UIViewController *parentVC;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) GXContainerTopBarStyle *topBarStyle;

// 滚动需要的属性
@property (nonatomic, assign) BOOL isClickTitle; // 是否是点击标题导致的滚动 
@property (nonatomic, assign) NSInteger lastContentOffsetX;

@property (nonatomic, assign) NSInteger terminalIndex;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, assign) BOOL scrollOverOnePage;

@property (nonatomic, strong) UIViewController *currentChildVC;
@property (strong, nonatomic) NSMutableDictionary<NSString *, UIViewController *> *childVCS;
@property (nonatomic, assign) BOOL isLoadFirstView;
@end

@implementation GXContainerContentView

- (instancetype)initWithFrame:(CGRect)frame topBarStyle:(GXContainerTopBarStyle *)topBarStyle parentVC:(UIViewController *)parentVC
{
    if (self = [super initWithFrame:frame]) {
        self.topBarStyle = topBarStyle;
        self.childVCS = [NSMutableDictionary dictionary];
        self.parentVC = parentVC;
        self.isLoadFirstView = YES;
        [self configSubviews];
    }
    return self;
}

#pragma mark - Public Method

- (void)updateContentOffSetWithIndex:(NSInteger)terminalIndex animated:(BOOL)animated
{
    self.isClickTitle = YES;
    self.lastIndex = self.terminalIndex;
    self.terminalIndex = terminalIndex;
    NSInteger page = labs(self.terminalIndex-self.lastIndex);
    
    // 需要滚动两页以上的时候, 跳过中间页的动画
    self.scrollOverOnePage = page > 2 ?YES:NO;
    
    [self.collectionView setContentOffset:CGPointMake(self.bounds.size.width * terminalIndex, 0.0) animated:!self.scrollOverOnePage];
}

#pragma mark - Private Method

// 更新topbar里title的颜色.选中状态
- (void)updateTopBarContentWithProgress:(CGFloat)progress
{
    if(self.contentViewDelegate) {
        [self.contentViewDelegate contentViewDidScroll:progress lastIndex:self.lastIndex terminalIndex:self.terminalIndex];
    }  
}

// 更新topbar的contentoffset
- (void)updateTopBarOffsetWithTerminalIndex:(NSInteger)terminalIndex
{
    if (self.contentViewDelegate) {
        [self.contentViewDelegate contentViewDidEndDecelerating:terminalIndex];
    }
}

#pragma mark - Event Response

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView 
{
    self.lastContentOffsetX = scrollView.contentOffset.x;
    self.isClickTitle = NO;
}

/** 滚动减速完成时再更新title的位置 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView 
{
    NSInteger terminalIndex = (scrollView.contentOffset.x / self.bounds.size.width);
    [self updateTopBarContentWithProgress:1.0];
    [self updateTopBarOffsetWithTerminalIndex:terminalIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    if (self.isClickTitle || // 点击标题滚动
        scrollView.contentOffset.x <= 0 || // first or last
        scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.size.width) {
        return;
    }
    CGFloat tempProgress = scrollView.contentOffset.x / self.bounds.size.width;
    NSInteger tempIndex = tempProgress;
    
    CGFloat progress = tempProgress - floor(tempProgress);
    CGFloat deltaX = scrollView.contentOffset.x - self.lastContentOffsetX;
    
    if (deltaX > 0) {// 向左
        if (progress == 0.0) {
            return;
        }
        self.terminalIndex = tempIndex+1;
        self.lastIndex = tempIndex;
    } else if (deltaX < 0) {
        progress = 1.0 - progress;
        self.lastIndex = tempIndex+1;
        self.terminalIndex = tempIndex;
    } else {
        return;
    }
    [self updateTopBarContentWithProgress:progress];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.topBarStyle.titles.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[UICollectionViewCell description] forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor clearColor];
    [self setupChildVcForCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)setupChildVcForCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath 
{
    self.currentChildVC = [self.childVCS valueForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
    
    if (self.contentViewDelegate && [self.contentViewDelegate respondsToSelector:@selector(childViewController:forIndex:)]) {
        if (self.currentChildVC == nil) {
            self.currentChildVC = [self.contentViewDelegate childViewController:nil forIndex:indexPath.row];
            
            [self.childVCS setValue:self.currentChildVC forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
        } else {
            [self.contentViewDelegate childViewController:self.currentChildVC forIndex:indexPath.row];
        }
    } else {
        NSAssert(NO, @"必须设置代理和实现代理方法");
    }
    // 这里建立子控制器和父控制器的关系
    if ([self.currentChildVC isKindOfClass:[UINavigationController class]]) {
        NSAssert(NO, @"不要添加UINavigationController包装后的子控制器");
    }
    if (self.currentChildVC.parentViewController != self.parentVC) {
        [self.parentVC addChildViewController:self.currentChildVC];
    }
    self.currentChildVC.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:self.currentChildVC.view];
    [self.currentChildVC didMoveToParentViewController:self.parentVC];
    
    NSLog(@"当前的index:%ld", indexPath.row);
}

#pragma mark - Initialize Method

- (void)configSubviews
{
    [self addSubview:self.collectionView];
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = self.frame.size;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = self.topBarStyle.contentBounces;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[UICollectionViewCell description]];
    }
    return _collectionView;
}

- (void)dealloc 
{
    NSLog(@"%@销毁",NSStringFromClass([self class]));
}

@end
