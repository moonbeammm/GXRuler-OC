//
//  GXChildVC.m
//  GXPageView
//
//  Created by sunguangxin on 2017/9/7.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXChildVC.h"

@interface GXChildVC () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *titleIndex;

@end

@implementation GXChildVC

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        self.titleIndex = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSubviews];
}

#pragma mark - Event Response

// 点击事件

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    vc.title = [NSString stringWithFormat:@"HA: %zd",indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

// 设置cell

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell description] forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"cell: %@--->>>%zd",self.titleIndex,indexPath.row];
    return cell;
}

// 设置组头

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
    header.textLabel.text = [NSString stringWithFormat:@"我是组头:%@--->>> %zd",self.titleIndex,section];
    return header;
}

#pragma mark - Initialize Method

- (void)configSubviews
{
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell description]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)dealloc 
{
    NSLog(@"%@销毁",NSStringFromClass([self class]));
}

@end
