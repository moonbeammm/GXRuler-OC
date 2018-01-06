//
//  GXBaseTableViewCell.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXBaseTableViewCell : UITableViewCell

- (void)installWithModel:(id)model params:(NSDictionary *)params;
+ (NSUInteger)getHeigthWithModel:(id)model params:(NSDictionary *)params;

@end
