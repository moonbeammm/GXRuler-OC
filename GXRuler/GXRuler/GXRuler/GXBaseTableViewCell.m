//
//  GXBaseTableViewCell.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXBaseTableViewCell.h"

@implementation GXBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)installWithModel:(id)model params:(NSDictionary *)params
{

}

+ (NSUInteger)getHeigthWithModel:(id)model params:(NSDictionary *)params
{
    return 0;
}

@end
