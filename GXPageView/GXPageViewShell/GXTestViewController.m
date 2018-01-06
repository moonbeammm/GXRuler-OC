//
//  GXTestViewController.m
//  GXPageView
//
//  Created by sunguangxin on 2017/9/5.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXTestViewController.h"
#import "GXPageContainerView.h"
#import "GXChildVC.h"

@interface GXTestViewController () <GXPageContainerChildVCDelegate>

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) GXPageContainerView *containerView0;
@property (nonatomic, strong) GXPageContainerView *containerView1;
@property (nonatomic, strong) GXPageContainerView *containerView2;
@property (nonatomic, strong) GXPageContainerView *containerView3;
@property (nonatomic, strong) GXPageContainerView *containerView4;

@end

@implementation GXTestViewController

- (instancetype)initWithIndex:(NSInteger)index
{
    if (self = [super init]) {
        self.index = index;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.title = [NSString stringWithFormat:@"%zd",index];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    switch (self.index) {
        case 0:
            [self.view addSubview:self.containerView0];
            break;
        case 1:
            [self.view addSubview:self.containerView1];
            break;
        case 2:
            [self.view addSubview:self.containerView2];
            break;
        case 3:
            [self.view addSubview:self.containerView3];
            break;
        case 4:
            [self.view addSubview:self.containerView4];
            break;
            
        default:
            break;
    }    
}

- (UIViewController *)childViewController:(UIViewController *)childViewController forIndex:(NSInteger)index
{
    GXChildVC *vc = (GXChildVC *)childViewController;
    if (!vc) {
        vc = [[GXChildVC alloc] initWithTitle:[NSString stringWithFormat:@"%zd",index]];
    }
    if (index%2==0) {
        vc.view.backgroundColor = [UIColor orangeColor];
    } else {
        vc.view.backgroundColor = [UIColor blueColor];
    }
    return vc;
}


// 居中显示
- (GXPageContainerView *)containerView0
{
    if (_containerView0 == nil) {
        GXContainerTopBarStyle *topBarStyle = [[GXContainerTopBarStyle alloc] init];
        topBarStyle.titles = @[@"番剧",@"国创",@"电影",@"科技科技"];
        topBarStyle.indicatorColor = [UIColor blueColor];
        topBarStyle.contentBGColor = [UIColor yellowColor];
        CGRect rect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        _containerView0 = [[GXPageContainerView alloc] initWithFrame:rect topBarStyle:topBarStyle parentVC:self];
        _containerView0.childVCDelegate = self;
        _containerView0.backgroundColor = [UIColor whiteColor];
    }
    return _containerView0;
}

// 居左显示
- (GXPageContainerView *)containerView1
{
    if (_containerView1 == nil) {
        GXContainerTopBarStyle *topBarStyle = [[GXContainerTopBarStyle alloc] init];
        topBarStyle.layoutStyle = GXTopBarLayoutStyleLeft;
        topBarStyle.showIndicator = NO;
        topBarStyle.titles = @[@"番剧",@"国创",@"电影",@"科技科技"];
        CGRect rect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        _containerView1 = [[GXPageContainerView alloc] initWithFrame:rect topBarStyle:topBarStyle parentVC:self];
        _containerView1.childVCDelegate = self;
        _containerView1.backgroundColor = [UIColor whiteColor];
    }
    return _containerView1;
}

// 当标题数过多.会自动变为可滑动的.
- (GXPageContainerView *)containerView2
{
    if (_containerView2 == nil) {
        GXContainerTopBarStyle *topBarStyle = [[GXContainerTopBarStyle alloc] init];
        topBarStyle.isHaveGradual = NO;
        topBarStyle.topBarBounces = NO;
        topBarStyle.contentBounces = NO;
        topBarStyle.titles = @[@"番剧",@"国创",@"电影",@"音乐",@"舞蹈",@"游戏",@"生活",@"电视剧",@"专栏",@"小视频",@"科技科技"];
        CGRect rect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        _containerView2 = [[GXPageContainerView alloc] initWithFrame:rect topBarStyle:topBarStyle parentVC:self];
        _containerView2.childVCDelegate = self;
        [_containerView2 setSelectedIndex:4];
        _containerView2.backgroundColor = [UIColor whiteColor];
    }
    return _containerView2;
}

- (GXPageContainerView *)containerView3
{
    if (_containerView3 == nil) {
        GXContainerTopBarStyle *topBarStyle = [[GXContainerTopBarStyle alloc] init];
        topBarStyle.titleMargin = 30;
        topBarStyle.titles = @[@"番剧",@"国创",@"电影",@"音乐",@"舞蹈",@"游戏",@"生活",@"电视剧",@"专栏",@"小视频",@"科技科技"];
        CGRect rect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        _containerView3 = [[GXPageContainerView alloc] initWithFrame:rect topBarStyle:topBarStyle parentVC:self];
        _containerView3.childVCDelegate = self;
        _containerView3.backgroundColor = [UIColor whiteColor];
    }
    return _containerView3;
}

- (GXPageContainerView *)containerView4
{
    if (_containerView4 == nil) {
        GXContainerTopBarStyle *topBarStyle = [[GXContainerTopBarStyle alloc] init];
        topBarStyle.topBarHeight = 80;
        topBarStyle.titles = @[@"番剧",@"国创",@"电影",@"音乐",@"舞蹈",@"游戏",@"生活",@"电视剧",@"专栏",@"小视频",@"科技科技"];
        CGRect rect = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
        _containerView4 = [[GXPageContainerView alloc] initWithFrame:rect topBarStyle:topBarStyle parentVC:self];
        _containerView4.childVCDelegate = self;
        _containerView4.backgroundColor = [UIColor whiteColor];
    }
    return _containerView4;
}

- (void)dealloc 
{
    NSLog(@"我是container: %@销毁",NSStringFromClass([self class]));
}

@end
