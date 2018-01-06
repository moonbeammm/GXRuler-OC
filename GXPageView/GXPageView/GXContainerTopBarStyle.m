//
//  GXContainerTopBarStyle.m
//  GXPageView
//
//  Created by sunguangxin on 2017/9/5.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXContainerTopBarStyle.h"

@implementation GXContainerTopBarStyle

- (instancetype)init
{
    if (self = [super init]) {
        self.titleFontSize = 16.0;
        self.animaScale = 1.1;
        
        self.topBarHeight = 64;
        self.indicatorHeight = 3;
        
        self.showIndicator = YES;
        self.topBarBounces = YES;
        self.contentBounces = YES;
        
        self.contentBGColor = [UIColor clearColor];
        
        self.indicatorStyle = GXTopBarIndicatorStyleDefault;
        self.layoutStyle = GXTopBarLayoutStyleDefault;
        self.titleContentType = GXTopBarTitleContentTypeOnlyText;
        
        self.topBarBGColor = [UIColor colorWithRed:251./255 green:114./255 blue:153./255 alpha:1];
        self.norTitleColor = [UIColor whiteColor];
        self.selTitleColor = [UIColor whiteColor];
        self.isHaveGradual = NO;
        self.titleMargin = 18;
        self.topPadding = 20;
        self.leftPadding = 30;
        self.defaultSelIndex = 1;
        self.indicatorBottomPadding = 3;
        self.indicatorColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc 
{
    NSLog(@"%@销毁",NSStringFromClass([self class]));
}

@end
