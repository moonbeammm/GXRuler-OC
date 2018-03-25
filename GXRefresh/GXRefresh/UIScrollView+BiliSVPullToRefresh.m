//
//  UIScrollView+BiliSVPullToRefresh.m
//  
//
//  Created by gx on 17/3/13.
//  Copyright © 2017年 gx. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIScrollView+BiliSVPullToRefresh.h"
#import "BiliPullToRefreshActivityIndicatorBaseView.h"

//fequal() and fequalzro() from https://stackoverflow.com/a/1614761/184130
#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#define fequalzero(a) (fabs(a) < FLT_EPSILON)


#define BiliPullToRefreshActivityIndicatorViewHeight   (100.0f)


static CGFloat const BiliSVPullToRefreshAutoHeight = 40;












@interface BiliSVPullToRefreshView ()

@property (nonatomic, copy) void (^pullToRefreshActionHandler)(void);
@property (nonatomic, strong, readwrite) BiliPullToRefreshActivityIndicatorBaseView *activityIndicatorView;
@property (nonatomic, readwrite) SVPullToRefreshState state;
@property (nonatomic, readwrite) SVPullToRefreshPosition position;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, readwrite) CGFloat originalTopInset;
@property (nonatomic, readwrite) CGFloat originalBottomInset;

@property (nonatomic, assign) BOOL wasTriggeredByUser;
@property (nonatomic, assign) BOOL showsPullToRefresh;
@property(nonatomic, assign) BOOL isObserving;

- (void)resetScrollViewContentInset;
- (void)setScrollViewContentInsetForLoading;
- (void)setScrollViewContentInset:(UIEdgeInsets)insets;
@end

#pragma mark - UIScrollView (SVPullToRefresh)
#import <objc/runtime.h>

static char UIScrollViewPullToRefreshView;
@implementation UIScrollView (BiliSVPullToRefresh)

@dynamic pullToRefreshView, showsPullToRefresh;

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler position:(SVPullToRefreshPosition)position {
    
    if(!self.pullToRefreshView) {
        CGFloat yOrigin;
        switch (position) {
            case SVPullToRefreshPositionTop:
                yOrigin = -BiliPullToRefreshActivityIndicatorViewHeight;
                break;
            case SVPullToRefreshPositionBottom:
                yOrigin = self.contentSize.height;
                break;
            default:
                return;
        }
        BiliSVPullToRefreshView *view = [[BiliSVPullToRefreshView alloc] initWithFrame:CGRectMake(0, yOrigin, self.bounds.size.width, BiliPullToRefreshActivityIndicatorViewHeight)];
        view.pullToRefreshActionHandler = actionHandler;
        view.scrollView = self;
        [self addSubview:view];
        
        view.originalTopInset = self.contentInset.top;
        view.originalBottomInset = self.contentInset.bottom;
        view.position = position;
        self.pullToRefreshView = view;
        self.showsPullToRefresh = YES;
    }
}

- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler {
    [self addPullToRefreshWithActionHandler:actionHandler position:SVPullToRefreshPositionTop];
}

- (void)triggerPullToRefresh {
    self.pullToRefreshView.state = SVPullToRefreshStateTriggered;
    [self.pullToRefreshView startAnimating];
}

- (void)setPullToRefreshView:(BiliSVPullToRefreshView *)pullToRefreshView {
    [self willChangeValueForKey:@"SVPullToRefreshView"];
    objc_setAssociatedObject(self, &UIScrollViewPullToRefreshView,
                             pullToRefreshView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"SVPullToRefreshView"];
}

- (BiliSVPullToRefreshView *)pullToRefreshView {
    return objc_getAssociatedObject(self, &UIScrollViewPullToRefreshView);
}

- (void)setShowsPullToRefresh:(BOOL)showsPullToRefresh {
    self.pullToRefreshView.hidden = !showsPullToRefresh;
    
    if(!showsPullToRefresh) {
        if (self.pullToRefreshView.isObserving) {
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentOffset"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"contentSize"];
            [self removeObserver:self.pullToRefreshView forKeyPath:@"frame"];
            [self.pullToRefreshView resetScrollViewContentInset];
            self.pullToRefreshView.isObserving = NO;
        }
    }
    else {
        if (!self.pullToRefreshView.isObserving) {
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
            [self addObserver:self.pullToRefreshView forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
            self.pullToRefreshView.isObserving = YES;
            
            CGFloat yOrigin = 0;
            switch (self.pullToRefreshView.position) {
                case SVPullToRefreshPositionTop:
                    yOrigin = -self.pullToRefreshView.bounds.size.height;
                    break;
                case SVPullToRefreshPositionBottom:
                    yOrigin = self.contentSize.height;
                    break;
            }
            
            self.pullToRefreshView.frame = CGRectMake(0, yOrigin, self.bounds.size.width, self.pullToRefreshView.bounds.size.height);
        }
    }
}

- (BOOL)showsPullToRefresh {
    return !self.pullToRefreshView.hidden;
}

@end

















#pragma mark - BiliSVPullToRefresh
@implementation BiliSVPullToRefreshView

// public properties
@synthesize pullToRefreshActionHandler, activityIndicatorViewColor;

@synthesize state = _state;
@synthesize scrollView = _scrollView;
@synthesize showsPullToRefresh = _showsPullToRefresh;
@synthesize activityIndicatorView = _activityIndicatorView;

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self addSubview:self.activityIndicatorView];
        // default styling values
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.state = SVPullToRefreshStateStopped;
        self.wasTriggeredByUser = YES;
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (self.superview && newSuperview == nil) {
        //use self.superview, not self.scrollView. Why self.scrollView == nil here?
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.showsPullToRefresh) {
            if (self.isObserving) {
                //If enter this branch, it is the moment just before "SVPullToRefreshView's dealloc", so remove observer here
                [scrollView removeObserver:self forKeyPath:@"contentOffset"];
                [scrollView removeObserver:self forKeyPath:@"contentSize"];
                [scrollView removeObserver:self forKeyPath:@"frame"];
                self.isObserving = NO;
            }
        }
    }
}

- (void)layoutSubviews
{
    switch (self.state) {
        case SVPullToRefreshStateAll:
        case SVPullToRefreshStateStopped:
            [self.activityIndicatorView stopAnimating];
            break;
            
        case SVPullToRefreshStateTriggered:
            
            break;
            
        case SVPullToRefreshStateLoading:
            [self.activityIndicatorView startAnimating];
            break;
    }
}

#pragma mark - Scroll View

- (void)resetScrollViewContentInset {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    switch (self.position) {
        case SVPullToRefreshPositionTop:
            currentInsets.top = self.originalTopInset;
            break;
        case SVPullToRefreshPositionBottom:
            currentInsets.bottom = self.originalBottomInset;
            currentInsets.top = self.originalTopInset;
            break;
    }
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForLoading {
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    switch (self.position) {
        case SVPullToRefreshPositionTop:
            currentInsets.top = MIN(offset, self.originalTopInset + self.bounds.size.height);
            break;
        case SVPullToRefreshPositionBottom:
            currentInsets.bottom = MIN(offset, self.originalBottomInset + self.bounds.size.height);
            break;
    }
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:nil];
}

#pragma mark - Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"contentSize"]) {
        [self layoutSubviews];
        
        CGFloat yOrigin;
        switch (self.position) {
            case SVPullToRefreshPositionTop:
                yOrigin = -self.bounds.size.height;
                break;
            case SVPullToRefreshPositionBottom:
                yOrigin = MAX(self.scrollView.contentSize.height, self.scrollView.bounds.size.height);
                break;
        }
        self.frame = CGRectMake(0, yOrigin, self.bounds.size.width, self.bounds.size.height);
    }
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
    
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    if(self.state != SVPullToRefreshStateLoading) {
        CGFloat scrollOffsetThreshold = 0;
        switch (self.position) {
            case SVPullToRefreshPositionTop:
                scrollOffsetThreshold = self.frame.origin.y - self.originalTopInset;
                [self.activityIndicatorView statePercentage:ABS(-1.0 * self.scrollView.contentOffset.y / scrollOffsetThreshold)];
                break;
            case SVPullToRefreshPositionBottom:
                scrollOffsetThreshold = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0.0f) + self.bounds.size.height + self.originalBottomInset;
                break;
        }
        
        if(!self.scrollView.isDragging && self.state == SVPullToRefreshStateTriggered)
            self.state = SVPullToRefreshStateLoading;
        else if(contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.state == SVPullToRefreshStateStopped && self.position == SVPullToRefreshPositionTop)
            self.state = SVPullToRefreshStateTriggered;
        else if(contentOffset.y >= scrollOffsetThreshold && self.state != SVPullToRefreshStateStopped && self.position == SVPullToRefreshPositionTop)
            self.state = SVPullToRefreshStateStopped;
        else if(contentOffset.y > scrollOffsetThreshold && self.scrollView.isDragging && self.state == SVPullToRefreshStateStopped && self.position == SVPullToRefreshPositionBottom)
            self.state = SVPullToRefreshStateTriggered;
        else if(contentOffset.y <= scrollOffsetThreshold && self.state != SVPullToRefreshStateStopped && self.position == SVPullToRefreshPositionBottom)
            self.state = SVPullToRefreshStateStopped;
    } else {
        CGFloat offset;
        UIEdgeInsets contentInset;
        switch (self.position) {
            case SVPullToRefreshPositionTop:
                offset = MAX(self.scrollView.contentOffset.y * -1, 0.0f);
                offset = MIN(offset, self.originalTopInset + self.bounds.size.height);
                contentInset = self.scrollView.contentInset;
                self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
                break;
            case SVPullToRefreshPositionBottom:
                if (self.scrollView.contentSize.height >= self.scrollView.bounds.size.height) {
                    offset = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.bounds.size.height, 0.0f);
                    offset = MIN(offset, self.originalBottomInset + self.bounds.size.height);
                    contentInset = self.scrollView.contentInset;
                    self.scrollView.contentInset = UIEdgeInsetsMake(contentInset.top, contentInset.left, offset, contentInset.right);
                } else if (self.wasTriggeredByUser) {
                    offset = MIN(self.bounds.size.height, self.originalBottomInset + self.bounds.size.height);
                    contentInset = self.scrollView.contentInset;
                    self.scrollView.contentInset = UIEdgeInsetsMake(-offset, contentInset.left, contentInset.bottom, contentInset.right);
                }
                break;
        }
    }
}

#pragma mark - Getters
- (BiliPullToRefreshActivityIndicatorBaseView *)activityIndicatorView
{
    if(!_activityIndicatorView) {
        _activityIndicatorView = [BiliPullToRefreshActivityIndicatorView view];
        _activityIndicatorView.frame = CGRectMake(0, 0, self.frame.size.width, BiliPullToRefreshActivityIndicatorViewHeight);
    }
    
    return _activityIndicatorView;
}

#pragma mark -
- (void)triggerRefresh
{
    [self.scrollView triggerPullToRefresh];
}

- (void)startAnimating{
    switch (self.position) {
        case SVPullToRefreshPositionTop:
            
            if(fequalzero(self.scrollView.contentOffset.y)) {
                //                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.frame.size.height) animated:YES];
                CGFloat autoRefreshHeight = BiliSVPullToRefreshAutoHeight;
//                if ([self respondsToSelector:@selector(autoPullToRefreshTrigger)]) {
//                    CGFloat height = ((CGFloat (*)(id, SEL))[self methodForSelector:@selector(autoPullToRefreshTrigger)])(self, @selector(autoPullToRefreshTrigger));
//                    if (height > 0) {
//                        autoRefreshHeight = height;
//                    }
//                }
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -autoRefreshHeight) animated:NO];
                self.wasTriggeredByUser = NO;
            }
            else
                self.wasTriggeredByUser = YES;
            
            break;
        case SVPullToRefreshPositionBottom:
            
            if((fequalzero(self.scrollView.contentOffset.y) && self.scrollView.contentSize.height < self.scrollView.bounds.size.height)
               || fequal(self.scrollView.contentOffset.y, self.scrollView.contentSize.height - self.scrollView.bounds.size.height)) {
                [self.scrollView setContentOffset:(CGPoint){.y = MAX(self.scrollView.contentSize.height - self.scrollView.bounds.size.height, 0.0f) + self.frame.size.height} animated:YES];
                self.wasTriggeredByUser = NO;
            }
            else
                self.wasTriggeredByUser = YES;
            
            break;
    }
    self.state = SVPullToRefreshStateLoading;
}

- (void)stopAnimating {
    self.state = SVPullToRefreshStateStopped;
    
    switch (self.position) {
        case SVPullToRefreshPositionTop:
            if(!self.wasTriggeredByUser && self.scrollView.contentOffset.y <= 0)
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, -self.originalTopInset) animated:YES];
            break;
        case SVPullToRefreshPositionBottom:
            if(!self.wasTriggeredByUser)
                [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.originalBottomInset) animated:YES];
            break;
    }
}

- (void)setState:(SVPullToRefreshState)newState {
    
    if(_state == newState)
        return;
    
    SVPullToRefreshState previousState = _state;
    _state = newState;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    switch (newState) {
        case SVPullToRefreshStateAll:
        case SVPullToRefreshStateStopped:
            [self resetScrollViewContentInset];
            break;
            
        case SVPullToRefreshStateTriggered:
            break;
            
        case SVPullToRefreshStateLoading:
            [self setScrollViewContentInsetForLoading];
            
            if(previousState == SVPullToRefreshStateTriggered && pullToRefreshActionHandler)
                pullToRefreshActionHandler();
            
            break;
    }
}

@end


















@interface BiliSVPullToRefreshViewM2 () {
    BiliPullToRefreshActivityIndicatorBaseView *_activityIndicatorViewM2;
}

@end

@implementation BiliSVPullToRefreshViewM2
@dynamic pullToRefreshActionHandler, scrollView;
- (BiliPullToRefreshActivityIndicatorBaseView *)activityIndicatorView
{
    if(!_activityIndicatorViewM2) {
        _activityIndicatorViewM2 = [BiliPullToRefreshActivityIndicatorViewM2 view];
        _activityIndicatorViewM2.frame = CGRectMake(0, 0, self.frame.size.width, 40);
    }
    return _activityIndicatorViewM2;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.activityIndicatorView.frame = CGRectMake(0, 0, self.frame.size.width, 40);
}

@end




















@interface BiliSVCollectionPullToRefreshView ()
@property (nonatomic, assign) CGSize lastContentSize;
@end

@implementation BiliSVCollectionPullToRefreshView
@dynamic pullToRefreshActionHandler, scrollView, originalTopInset;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"])
        [self scrollViewDidScroll:[[change valueForKey:NSKeyValueChangeNewKey] CGPointValue]];
    else if([keyPath isEqualToString:@"contentSize"]) {
        
        if (![[change valueForKey:NSKeyValueChangeNewKey] isEqualToValue:[NSValue valueWithCGSize:self.lastContentSize]]) {
            [self layoutSubviews];
            
            CGFloat yOrigin;
            switch (self.position) {
                case SVPullToRefreshPositionTop:
                    yOrigin = -self.bounds.size.height;
                    break;
                case SVPullToRefreshPositionBottom:
                    yOrigin = MAX(self.scrollView.contentSize.height, self.scrollView.bounds.size.height);
                    break;
            }
            self.frame = CGRectMake(0, yOrigin, self.bounds.size.width, self.bounds.size.height);
            self.lastContentSize = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
        }
        
    }
    else if([keyPath isEqualToString:@"frame"])
        [self layoutSubviews];
    
}

+ (CGFloat)defaultHeight
{
    return BiliPullToRefreshActivityIndicatorViewHeight;
}

@end
