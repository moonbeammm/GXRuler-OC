//
//  GXTopBarColorHelper.m
//  GXPageView
//
//  Created by sunguangxin on 2017/9/6.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXTopBarColorHelper.h"

@implementation GXTopBarColorHelper

+ (NSArray *)getRGBColorArr:(UIColor *)color 
{
    CGFloat numOfcomponents = CGColorGetNumberOfComponents(color.CGColor);
    NSArray *rgbaComponents;
    if (numOfcomponents != 4) {
        return nil;
    }
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    rgbaComponents = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), @(components[3]), nil];
    return rgbaComponents;
}

+ (NSArray *)getDeltaRGBWithColorA:(NSArray *)colorARGBArr colorB:(NSArray *)colorBRGBArr
{
    NSArray *deltaRGBArr = nil;
    if (colorARGBArr && colorBRGBArr) {
        CGFloat deltaR = [colorARGBArr[0] floatValue] - [colorBRGBArr[0] floatValue];
        CGFloat deltaG = [colorARGBArr[1] floatValue] - [colorBRGBArr[1] floatValue];
        CGFloat deltaB = [colorARGBArr[2] floatValue] - [colorBRGBArr[2] floatValue];
        CGFloat deltaA = [colorARGBArr[3] floatValue] - [colorBRGBArr[3] floatValue];
        deltaRGBArr = [NSArray arrayWithObjects:@(deltaR), @(deltaG), @(deltaB), @(deltaA), nil];
    }
    return deltaRGBArr;
}

+ (UIColor *)transformGradualColorWithColorRGBArr:(NSArray *)colorRGBArr deltaRGBArr:(NSArray *)deltaRGBArr progress:(CGFloat)progress add:(BOOL)add
{
    if (add) {
        return  [UIColor colorWithRed:[colorRGBArr[0] floatValue] + [deltaRGBArr[0] floatValue] * progress
                                green:[colorRGBArr[1] floatValue] + [deltaRGBArr[1] floatValue] * progress
                                 blue:[colorRGBArr[2] floatValue] + [deltaRGBArr[2] floatValue] * progress
                                alpha:[colorRGBArr[3] floatValue] + [deltaRGBArr[3] floatValue] * progress];
    } else {
        return  [UIColor colorWithRed:[colorRGBArr[0] floatValue] - [deltaRGBArr[0] floatValue] * progress
                                green:[colorRGBArr[1] floatValue] - [deltaRGBArr[1] floatValue] * progress
                                 blue:[colorRGBArr[2] floatValue] - [deltaRGBArr[2] floatValue] * progress
                                alpha:[colorRGBArr[3] floatValue] - [deltaRGBArr[3] floatValue] * progress];
    }
}

@end
