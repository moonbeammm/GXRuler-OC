//
//  GXTopBarColorHelper.h
//  GXPageView
//
//  Created by sunguangxin on 2017/9/6.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 使用方法:
 
 UIColor *lastTitleColor = [GXTopBarColorHelper transformGradualColorWithColorRGBArr:self.selectedColorArr deltaRGBArr:self.deltaRGBArr progress:progress add:NO];
 UIColor *terminalTitleColor = [GXTopBarColorHelper transformGradualColorWithColorRGBArr:self.normalColorArr deltaRGBArr:self.deltaRGBArr progress:progress add:YES];
 
 [lastTitleView setTitleColor:lastTitleColor forState:UIControlStateNormal];
 [terminalTitleView setTitleColor:terminalTitleColor forState:UIControlStateNormal];
 
 // 懒加载
 
 -(NSArray *)selectedColorArr
 {
 if (_selectedColorArr == nil) {
 _selectedColorArr = [GXTopBarColorHelper getRGBColorArr:self.topBarStyle.selTitleColor];
 }
 return _selectedColorArr;
 }
 
 - (NSArray *)normalColorArr
 {
 if (_normalColorArr == nil) {
 _normalColorArr = [GXTopBarColorHelper getRGBColorArr:self.topBarStyle.norTitleColor];
 
 }
 return _normalColorArr;
 }
 
 - (NSArray *)deltaRGBArr
 {
 if (_deltaRGBArr == nil) {
 _deltaRGBArr = [GXTopBarColorHelper getDeltaRGBWithColorA:self.selectedColorArr colorB:self.normalColorArr];
 }
 return _deltaRGBArr;
 } 
 */

@interface GXTopBarColorHelper : NSObject

+ (NSArray *)getRGBColorArr:(UIColor *)color;
+ (NSArray *)getDeltaRGBWithColorA:(NSArray *)colorARGBArr colorB:(NSArray *)colorBRGBArr;
+ (UIColor *)transformGradualColorWithColorRGBArr:(NSArray *)colorRGBArr deltaRGBArr:(NSArray *)deltaRGBArr progress:(CGFloat)progress add:(BOOL)add;

@end
