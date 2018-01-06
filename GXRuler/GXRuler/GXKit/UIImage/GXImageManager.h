//
//  GXImageManager.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GXImageMake(WHERE_USING, ...) [GXImageManager imageWithImageName:[NSString stringWithFormat:__VA_ARGS__] frameworkName:WHERE_USING]

// 各个库的类型
typedef enum : NSUInteger {
    GXPhone,
    GXHome,
} GXFrameworkName;

/**
 * 封装通过bundleIdentifier获取对应动态库里的图片的方法.
 */
@interface GXImageManager : NSObject

+ (UIImage *)imageWithImageName:(NSString *)imageName frameworkName:(GXFrameworkName)frameworkName;

@end
