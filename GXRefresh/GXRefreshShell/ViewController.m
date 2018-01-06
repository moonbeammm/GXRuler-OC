//
//  ViewController.m
//  GXRefreshShell
//
//  Created by sunguangxin on 2017/9/21.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "ViewController.h"
#import <GXRefresh/UIScrollView+BiliSVPullToRefresh.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.title = @"下拉刷新";
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configSubviews];
    [self.tableView addPullToRefreshWithActionHandler:^{
        NSLog(@"下拉刷新.");
    }];
}

#pragma mark - Public Method

#pragma mark - Event Response

#pragma mark - Private Method

#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    NSString *title = @"我是测试下拉刷新的!!";
    cell.textLabel.text = title;
    return cell;
}

#pragma mark - Initialize Method

- (void)configSubviews
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell description]];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        CGRect rect = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor grayColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

@end
