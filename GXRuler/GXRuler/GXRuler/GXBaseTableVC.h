//
//  GXBaseTableVC.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXBaseViewController.h"

@interface GXBaseTableVC : GXBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readonly) UITableView *tableView;

@end
