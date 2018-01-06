//
//  GXBaseViewModel.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXBaseViewModel.h"

@implementation GXBaseViewModel

- (void)tryLoadData
{
    if (self.isLoading) {
        return;
    } else {
        [self loadData];
    }
}

- (void)loadData
{
    self.isLoading = YES;
    self.isEnd = NO;
}

- (void)tryLoadMoreData
{

}

- (Class)getCellClassWithModelName:(NSString *)modelName
{
    // 通过model的类型名获得cell的类型
    return nil;
}

- (NSDictionary *)dataCellClassMapping
{
    //key为model类型.value为cell类型
    return @{};
}

@end
