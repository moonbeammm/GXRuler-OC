//
//  GXContainerTopBarStyle.h
//  GXPageView
//
//  Created by sunguangxin on 2017/9/5.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GXTopBarTitleContentTypeOnlyText, // 只有文字.默认居中展示
    GXTopBarTitleContentTypeOnlyImage, // 只有图片.默认居中展示
    GXTopBarTitleContentTypeImageLeft, // 图片在左边.文字右边
    GXTopBarTitleContentTypeImageRight, // 图片在右边.文字左边
    GXTopBarTitleContentTypeImageTop, // 图片在上面.文字在下面
} GXTopBarTitleContentType;

typedef enum : NSUInteger {
    GXTopBarIndicatorStyleDefault,
    GXTopBarIndicatorStyleLine,
    GXTopBarIndicatorStyleArrow,
    GXTopBarIndicatorStyleSlide
} GXTopBarIndicatorStyle;

typedef enum : NSUInteger {
    GXTopBarLayoutStyleDefault, // 居中显示
    GXTopBarLayoutStyleCenter, // 居中显示
    GXTopBarLayoutStyleLeft // 贴左显示
} GXTopBarLayoutStyle;

@interface GXContainerTopBarStyle : NSObject

#pragma mark - @required

@property (nonatomic, strong) NSArray *titles;

#pragma mark - @optional

@property (nonatomic, assign) NSInteger defaultSelIndex;

@property (nonatomic, assign) CGFloat titleFontSize; // 标题字体大小
@property (nonatomic, assign) CGFloat animaScale; // 滑动过程中缩放动画

@property (nonatomic, assign) NSInteger topBarHeight; // 默认64高度
@property (nonatomic, assign) NSInteger titleMargin; // topbar里每个titleView的内容间距(图片和标题)
@property (nonatomic, assign) NSInteger leftPadding;
@property (nonatomic, assign) NSInteger topPadding;

@property (nonatomic, assign) NSInteger indicatorBottomPadding;
@property (nonatomic, assign) NSInteger indicatorHeight; // 默认3的高度
@property (nonatomic, assign) BOOL showIndicator; // 是否显示指示器

@property (nonatomic, assign) BOOL topBarBounces; // topBar有没有弹性
@property (nonatomic, assign) BOOL isHaveGradual; // 滑动的时候titile有没有渐变效果
@property (nonatomic, assign) BOOL contentBounces; // contentView有没有弹性

@property (nonatomic, strong) UIColor *norTitleColor;
@property (nonatomic, strong) UIColor *selTitleColor;
@property (nonatomic, strong) UIColor *indicatorColor; // 指示器的颜色
@property (nonatomic, strong) UIColor *contentBGColor;
@property (nonatomic, strong) UIColor *topBarBGColor;

@property (nonatomic, assign) GXTopBarLayoutStyle layoutStyle;
@property (nonatomic, assign) GXTopBarIndicatorStyle indicatorStyle; // 暂时只支持line
@property (nonatomic, assign) GXTopBarTitleContentType titleContentType; // titleView显示内容类型.(兼容文字和图片)



@end
