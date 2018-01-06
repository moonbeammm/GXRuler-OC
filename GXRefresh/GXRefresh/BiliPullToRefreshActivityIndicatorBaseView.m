//
//  BiliPullToRefreshActivityIndicatorBaseView.m
//  BiliCore
//
//  Created by chenguang on 17/3/8.
//  Copyright © 2017年 bilibili. All rights reserved.
//

#import "BiliPullToRefreshActivityIndicatorBaseView.h"


@implementation BiliPullToRefreshActivityIndicatorBaseView

+ (id)view
{
    // override me
    return [BiliPullToRefreshActivityIndicatorBaseView new];
}

- (void)statePercentage:(CGFloat)percentage
{
    // override me
}

- (void)stopAnimating
{
    // override me
}

- (void)startAnimating
{
    // override me
}

- (void)setStateStrings:(NSArray *)titles
{
    // override me
}

@end

@interface BiliPullToRefreshActivityIndicatorView ()

@property(nonatomic,strong) IBOutlet UIImageView *bgImageView;

@property(nonatomic,strong) IBOutlet UIView *statusView;
@property(nonatomic,strong) IBOutlet UIImageView *statusImageView;
@property(nonatomic,strong) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property(nonatomic,strong) IBOutlet UILabel *titleLabel;

@property (nonatomic) IBOutlet UIImageView *defaultTv;
@property (nonatomic) IBOutlet UIImageView *jumpTv;

@property (nonatomic, assign) CGFloat percentage;

@property(nonatomic,strong) NSArray *titleStrings;

@end

@implementation BiliPullToRefreshActivityIndicatorView

+ (id)view {
//    NSArray *array = [[NSBundle bundleWithIdentifier:@"com.sgx.GXRefreshShell"] loadNibNamed:@"BiliPullToRefreshHeaderView" owner:nil options:nil];
    BiliPullToRefreshActivityIndicatorView *view = [[BiliPullToRefreshActivityIndicatorView alloc] init];
    [view configSubviews];
    [view initControls];
    return view;
}

#pragma mark - Public Method

#pragma mark - Event Response

#pragma mark - Private Method

#pragma mark - Initialize Method

- (void)configSubviews
{
    
    [self addSubview:self.titleLabel];
    
}

- (UIImageView *)bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        
    }
    return _bgImageView;
}

- (UIView *)statusView
{
    if (_statusView == nil) {
        _statusView = [[UIView alloc] init];
        
    }
    return _statusView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.shadowColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (void)initControls {


    self.defaultTv.image = [UIImage imageNamed:@"phone_common_pull_loading_1"];
//    BiliCoreComponentPullToRefresh *pr = [[BiliCCManager shared] getPullToRefreshCoreComponent];
//    if (pr.prompts.count < 4) {
        self.titleStrings = @[@"刷呀刷呀，刷完啦，喵^ω^", @"刷呀刷呀，好累啊，喵^ω^", @"再拉，再拉就刷给你看", @"够了啦，松开人家嘛"];
        self.jumpTv.animationDuration = 1;
        NSArray *imageNameArray = @[
                                    @"phone_common_pull_loading_1",
                                    @"phone_common_pull_loading_2",
                                    @"phone_common_pull_loading_3",
                                    @"phone_common_pull_loading_4"];
        self.jumpTv.animationImages = [self imagesFromImageNameArray:imageNameArray];
        
//    }
//    else {
//        self.titleStrings = pr.prompts;
//        self.jumpTv.animationDuration = pr.duration;
//        NSArray *arr = [pr.animateItem getCachedFilePath];
//        NSMutableArray *images = [NSMutableArray arrayWithCapacity:arr.count];
//        for (NSString *path in arr) {
//            UIImage *img = [UIImage imageWithContentsOfFile:path];
//            if (img) {
//                img = [UIImage imageWithCGImage:img.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
//                [images addObject:img];
//            }
//        }
//        if (images.count > 0) {
//            self.jumpTv.animationImages = images;
//        } else {
//            NSArray *imageNameArray = @[
//                                        @"phone_common_pull_loading_1",
//                                        @"phone_common_pull_loading_2",
//                                        @"phone_common_pull_loading_3",
//                                        @"phone_common_pull_loading_4"];
//            self.jumpTv.animationImages = [self imagesFromImageNameArray:imageNameArray];
//            
//        }
//        arr = [pr.staticItem getCachedFilePath];
//        images = [NSMutableArray arrayWithCapacity:arr.count];
//        for (NSString *path in arr) {
//            UIImage *img = [UIImage imageWithContentsOfFile:path];
//            if (img) {
//                img = [UIImage imageWithCGImage:img.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
//                [images addObject:img];
//            }
//        }
//        if (images.count > 0) {
//            self.defaultTv.image = images[0];
//        }
//        arr = [pr.verticalBgItem getCachedFilePath];
//        images = [NSMutableArray arrayWithCapacity:arr.count];
//        for (NSString *path in arr) {
//            UIImage *img = [UIImage imageWithContentsOfFile:path];
//            if (img) {
//                img = [UIImage imageWithCGImage:img.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
//                [images addObject:img];
//            }
//        }
//        if (images.count > 0) {
//            self.bgImageView.image = images[0];
//        }
//    }
    
}

- (NSArray *)imagesFromImageNameArray:(NSArray *)imageNameArray
{
    NSMutableArray *mulArr = [NSMutableArray arrayWithCapacity:imageNameArray.count];
    for (NSString *imageName in imageNameArray) {
        UIImage *image = [UIImage imageNamed:imageName];
        if (image) {
            [mulArr addObject:image];
        }
    }
    return [mulArr copy];
}


- (void)setStateStrings:(NSArray *)titles
{
    if (titles.count < 4) {
        return;
    }
    self.titleStrings = titles;
}

- (void)statePercentage:(CGFloat)percentage
{
    self.statusImageView.hidden = NO;
    if (self.percentage == 1 && percentage < 1) {
        [self.loadingIndicator stopAnimating];
        self.statusImageView.hidden = NO;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2f];
        
        self.statusImageView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
        [UIView commitAnimations];
        self.titleLabel.text = self.titleStrings[2];
    } else if (self.percentage < 1 && percentage >= 1) {
        [self.loadingIndicator stopAnimating];
        self.statusImageView.hidden = NO;
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2f];
        
        self.statusImageView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        [UIView commitAnimations];
        self.titleLabel.text = self.titleStrings[3];
        
    } else if (self.percentage < 1 && percentage < 1) {
        self.titleLabel.text = self.titleStrings[2];
    }
    self.percentage = percentage > 1 ? 1 : percentage;
    
    
    [self setNeedsDisplay];
}
- (void)stopAnimating
{
    self.titleLabel.text = self.titleStrings[0];
    
    [self.loadingIndicator stopAnimating];
    self.statusImageView.hidden = YES;
    self.defaultTv.hidden = NO;
    self.jumpTv.hidden = YES;
    [self.jumpTv stopAnimating];
}

- (void)startAnimating
{
    self.titleLabel.text = self.titleStrings[1];
    [self.loadingIndicator startAnimating];
    self.statusImageView.hidden = YES;
    self.defaultTv.hidden = YES;
    self.jumpTv.hidden = NO;
    [self.jumpTv startAnimating];
}

@end

@interface BiliPullToRefreshActivityIndicatorViewM2 ()

@property(nonatomic,strong) UIActivityIndicatorView *loadingIndicator;

@end

@implementation BiliPullToRefreshActivityIndicatorViewM2

+ (id)view {
    BiliPullToRefreshActivityIndicatorViewM2 *view = [BiliPullToRefreshActivityIndicatorViewM2 new];
    view.loadingIndicator = [UIActivityIndicatorView new];
    view.loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [view addSubview:view.loadingIndicator];
    return view;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.loadingIndicator.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
}

- (void)stopAnimating
{
    [self.loadingIndicator stopAnimating];
}

- (void)startAnimating
{
    [self.loadingIndicator startAnimating];
}


@end

