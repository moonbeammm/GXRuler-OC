//
//  GXApiOptions.m
//  GXNetwork
//
//  Created by sunguangxin on 2017/9/8.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXApiOptions.h"

@implementation GXApiOptions
- (instancetype)init
{
    if (self = [super init]) {
        self.timeoutInterval = 20.0;
    }
    return self;
}
@end
