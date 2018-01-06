//
//  GXTheme.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GXThemeDelegate.h"

#define GXThemeRegisterViewBackgroundColor(TARGET, COLOR) \
({ \
if (!([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) [[GXTheme sharedTheme] observerBackgroundColorTarget:TARGET obsColorSelector:COLOR]; \
})

#define GXThemeRegisterLabelTextColor(TARGET, COLOR) \
({ \
if (!([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) [[GXTheme sharedTheme] observerTextColorTarget:TARGET obsColorSelector:COLOR]; \
})

#define GXThemeRegisterButtonTextColor(TARGET, COLOR, STATE) \
({ \
if (!([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) [[GXTheme sharedTheme] observerButtonTitleColor:TARGET obsColorSelector:COLOR state:STATE]; \
})

#define GXThemeRegisterAll(TARGET) \
({ \
if (!([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) [[GXTheme sharedTheme] observerTarget:TARGET]; \
})

#define GXThemeUnRegisterAll(TARGET) \
({ \
if (!([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) [[GXTheme sharedTheme] unregisterTarget:TARGET]; \
})

typedef NS_ENUM(NSUInteger, GXThemeType) {
    GXThemeSyoujyoPinkType = 0,
    GXThemeShiroWhiteType,
    GXThemeNightmareType,        /// 噩梦（夜间）模式
    
    GXThemeTypeCountMAX
};

@interface GXTheme : NSObject


@property (nonatomic, readonly) UIStatusBarStyle statusBarStyle;
@property (nonatomic, readonly) UIKeyboardAppearance keyboardStyle;     /// 键盘的外观
@property (nonatomic, readonly) GXThemeType currentThemeType;

+ (instancetype)sharedTheme;

- (NSString*)themeNameWithType: (GXThemeType)themeType;

- (void)syncWithType:(GXThemeType)type;

- (void)observerBackgroundColorTarget:(UIView *)target obsColorSelector:(NSString *)selectorName;
- (void)observerTextColorTarget:(UILabel *)target obsColorSelector:(NSString *)selectorName;

- (void)observerButtonTitleColor:(UIButton *)target obsColorSelector:(NSString *)selectorName state:(UIControlState)state;

- (void)observerTarget:(id <GXThemeDelegate>)target;

- (void)unregisterTarget:(id)target;

@end
