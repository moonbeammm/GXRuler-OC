//
//  GXBaseCollectionViewCell.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXBaseCollectionViewCell : UICollectionViewCell

- (void)jumpDetail:(id)params;

- (void)installWithModel:(id)model params:(NSDictionary *)params;
+ (NSInteger)getHeightWithModel:(id)model params:(NSDictionary *)params;
+ (NSInteger)getWidthWithModel:(id)model params:(NSDictionary *)params;

@end
