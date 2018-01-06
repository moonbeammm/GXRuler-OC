//
//  GXImageManager.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXImageManager.h"

@implementation GXImageManager

+ (UIImage *)imageWithImageName:(NSString *)imageName frameworkName:(GXFrameworkName)frameworkName
{
    NSString *bundleIdentifier = GXFrameworkBundleIdentifierFromFrameworkName(frameworkName);
    UIImage *img = [UIImage imageNamed:imageName inBundle:[NSBundle bundleWithIdentifier:bundleIdentifier] compatibleWithTraitCollection:nil];    
    return img;
}

static inline NSString * GXFrameworkBundleIdentifierFromFrameworkName(GXFrameworkName frameworkName) {
    switch (frameworkName) {
        case GXPhone:
            return @"com.sgx.GXPhone";
        case GXHome:
            return @"com.sgx.GXHome";
        default:
            assert(NO);
            return nil;
    }
}

@end
