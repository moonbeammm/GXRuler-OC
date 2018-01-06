//
//  UIImageView+GXWebImage.m
//  GXRuler
//
//  Created by sunguangxin on 2017/10/20.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "UIImageView+GXWebImage.h"
#import <YYWebImage/UIImageView+YYWebImage.h>
#import <YYWebImage/YYWebImageManager.h>

@implementation UIImageView (GXWebImage)

- (void)gx_setImageWithURL:(NSString *)url ptSize:(CGSize)size placeholderImage:(UIImage *)placeholder options:(GXWebImageOptions)options progress:(GXWebImageProgressBlock)progressBlock completed:(GXWebImageCompletionBlock)completedBlock
{
    __weak typeof (self) weakSelf = self;
    NSURL *imageUrl = [NSURL URLWithString:url];
    YYWebImageOptions yy_webImageOptions = [[self class] yy_webImageOptions:options];
    [self yy_setImageWithURL:imageUrl placeholder:placeholder options:yy_webImageOptions manager:nil progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (progressBlock) {
            progressBlock(receivedSize, expectedSize);
        }
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (completedBlock) {
            GXWebImageCacheType cacheType = [[weakSelf class] gx_webImageType:from];
            completedBlock(image,error,cacheType,url);
        }
    }];
    
}

+ (void)gx_downloadImageWithURL:(NSString *)url ptSize:(CGSize)size options:(GXWebImageOptions)options progress:(GXWebImageProgressBlock)progressBlock completed:(GXWebImageDownloadCompletedBlock)completedBlock
{
    YYWebImageOptions yy_webImageOptions = [[self class] yy_webImageOptions:options];
    NSURL *imageUrl = [NSURL URLWithString:url];
    [[YYWebImageManager sharedManager] requestImageWithURL:imageUrl options:yy_webImageOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressBlock) {
                progressBlock(receivedSize,expectedSize);
            }
        });
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completedBlock) {
                completedBlock(image,error,url);
            }
        });
    }];
}

#pragma mark - type transform
+ (GXWebImageCacheType)gx_webImageType:(YYWebImageFromType)yy_webImageType {
    GXWebImageCacheType gx_webImageType = GXWebImageCacheNone;
    switch (yy_webImageType) {
        case YYWebImageFromNone:
        case YYWebImageFromRemote:
            gx_webImageType = GXWebImageCacheNone;
            break;
        case YYWebImageFromDiskCache:
            gx_webImageType = GXWebImageCacheDisk;
            break;
        case YYWebImageFromMemoryCache:
        case YYWebImageFromMemoryCacheFast:
            gx_webImageType = GXWebImageCacheMemeory;
        default:
            break;
    }
    return gx_webImageType;
}

+ (YYWebImageOptions)yy_webImageOptions:(GXWebImageOptions)gx_webImageOptions {
    YYWebImageOptions yy_webImageOptions = YYWebImageOptionSetImageWithFadeAnimation;
    if (gx_webImageOptions & GXWebImageMemoryOnly) {
        yy_webImageOptions |= YYWebImageOptionIgnoreDiskCache;
    }
    if (gx_webImageOptions & GXWebImageProgressive) {
        yy_webImageOptions |= YYWebImageOptionProgressive;
    }
    if (gx_webImageOptions & GXWebImageRefreshCache) {
        yy_webImageOptions |= YYWebImageOptionRefreshImageCache;
    }
    if (gx_webImageOptions & GXWebImageAllowBackgroundTask) {
        yy_webImageOptions |= YYWebImageOptionAllowBackgroundTask;
    }
    if (gx_webImageOptions & GXWebImageHandleCookies) {
        yy_webImageOptions |= YYWebImageOptionHandleCookies;
    }
    if (gx_webImageOptions & GXWebImageAllowInvalidSSL) {
        yy_webImageOptions |= YYWebImageOptionAllowInvalidSSLCertificates;
    }
    if (gx_webImageOptions & GXWebImageIgnorePlaceHolder) {
        yy_webImageOptions |= YYWebImageOptionIgnorePlaceHolder;
    }
    if (gx_webImageOptions & GXWebImageIgnoreAnimatedImage) {
        yy_webImageOptions |= YYWebImageOptionIgnoreAnimatedImage;
    }
    if (gx_webImageOptions & GXWebImageIgnoreFailedURL) {
        yy_webImageOptions |= YYWebImageOptionIgnoreFailedURL;
    }
    return yy_webImageOptions;
}

@end
