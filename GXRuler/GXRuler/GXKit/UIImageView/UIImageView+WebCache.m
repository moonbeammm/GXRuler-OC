//
//  UIImageView+WebCache.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "UIImageView+WebCache.h"

//#import <YYWebImage/UIImageView+YYWebImage.h>
//#import <YYWebImage/YYWebImageManager.h>
//#import <YYCache/YYMemoryCache.h>
//#import <YYCache/YYDiskCache.h>
//#import <YYImage/YYImage.h>

#import "GXReachability.h"
#import "NSURL+Utility.h"
#import "UIDevice+Device.h"

#define EMPTY_URL_ERROR                 [NSError errorWithDomain:@"GXWebImageError" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"图片URL为空"}]
#define GX_WEB_IMG_QUALITY_SETTING    (@"image_quality_type")
#define GX_WEB_IMG_LOAD_FAILED_COUNT  (@"GXWebImageLoadFailedCount")
#define GX_WEB_IMG_LOAD_TOTAL_COUNT   (@"GXWebImageLoadTotalCount")
#define GX_WEB_IMG_REPORT_MAX_COUNT   300
#define GX_WEB_IMG_CACHE_FAILED_COUNT 100

long _currentImgQualitySettingType = -1;

@implementation UIImageView (WebCache)


/// 当前下载的图片质量
//+ (GXWebImageQualityType)GX_currentImgQualitySettingType
//{
//    if (_currentImgQualitySettingType < 0 || _currentImgQualitySettingType > 2) {
//        _currentImgQualitySettingType = [[NSUserDefaults standardUserDefaults] integerForKey:GX_WEB_IMG_QUALITY_SETTING];
//        if (_currentImgQualitySettingType < 0 || _currentImgQualitySettingType > 2) {
//            _currentImgQualitySettingType = 0;
//        }
//    }
//    return (GXWebImageQualityType)_currentImgQualitySettingType;
//}
//
///// 设置当前下载的图片质量
//+ (void)GX_updateCurrentImgQualitySetting:(GXWebImageQualityType)type
//{
//    if (type == _currentImgQualitySettingType) {
//        return;
//    }
//    _currentImgQualitySettingType = type;
//    [[NSUserDefaults standardUserDefaults] setInteger:type forKey:GX_WEB_IMG_QUALITY_SETTING];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

//+ (void)GX_setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads
//{
//    [YYWebImageManager sharedManager].queue.maxConcurrentOperationCount = maxConcurrentDownloads;
//}
//
//+ (void)GX_setMaxMemoryCost:(NSUInteger)maxMemoryCost
//{
//    [YYImageCache sharedCache].memoryCache.costLimit = maxMemoryCost;
//    [YYWebImageManager sharedManager].cache.memoryCache.costLimit = maxMemoryCost;
//}
//
//+ (unsigned long long)GX_getImageCacheSize {
//    return MAX([YYWebImageManager sharedManager].cache.diskCache.totalCost, 0);
//}
//
//+ (void)GX_clearImageCache {
//    [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
//}
//
//+ (void)GX_setCacheLimit:(NSUInteger)limit {
//    [YYWebImageManager sharedManager].cache.diskCache.costLimit = limit;
//}
//
//+ (UIImage *)GX_getCachedImage:(NSString *)name
//{
//    UIImage *image = [[YYImageCache sharedCache] getImageForKey:name];
//    return image;
//}
//
//+ (void)GX_removeCachedImageForKey:(NSString *)key isOnlyMemeryCache:(BOOL)isOnlyMemeryCache
//{
//    [[YYImageCache sharedCache] removeImageForKey:key withType:isOnlyMemeryCache ? YYImageCacheTypeMemory : YYImageCacheTypeAll];
//}

//+ (BOOL)GX_containsImageForKey:(NSString *)url
//{
//    BOOL isExistCache = [[YYWebImageManager sharedManager].cache containsImageForKey:[[YYWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]]];
//    return isExistCache;
//}

//+ (BOOL)GX_isURLEmpty:(NSURL *)url
//{
//    if (!url ||
//        url.absoluteString.length == 0 ||
//        [url.absoluteString isEqualToString:@"http://"] ||
//        [url.absoluteString isEqualToString:@"https://"]) {
//        return YES;
//    }
//    return NO;
//}
//
//- (void)GX_setImageWithURL:(NSURL *)url ptSize:(CGSize)size 
//{
//    [self GX_setImageWithURL:url ptSize:size placeholderImage:nil options:0 completed:nil];
//}
//
//- (void)GX_setImageWithURL:(NSURL *)url ptSize:(CGSize)size placeholderImage:(UIImage *)placeholder 
//{
//    [self GX_setImageWithURL:url ptSize:size placeholderImage:placeholder options:0 completed:nil];
//}
//
//- (void)GX_setImageWithURL:(NSURL *)url 
//                      ptSize:(CGSize)size 
//            placeholderImage:(UIImage *)placeholder 
//                     options:(GXWebImageOptions)options
//{
//    [self GX_setImageWithURL:url ptSize:size placeholderImage:placeholder options:options completed:nil];
//}
//
//- (void)GX_setImageWithURL:(NSURL *)url 
//                      ptSize:(CGSize)size 
//                   completed:(BFCWebImageCompletionBlock)completedBlock
//{
//    [self GX_setImageWithURL:url ptSize:size placeholderImage:nil options:0 completed:completedBlock];
//}
//
//- (void)GX_setImageWithURL:(NSURL *)url 
//                      ptSize:(CGSize)size 
//            placeholderImage:(UIImage *)placeholder 
//                   completed:(BFCWebImageCompletionBlock)completedBlock
//{
//    [self GX_setImageWithURL:url ptSize:size placeholderImage:placeholder options:0 completed:completedBlock];
//}
//
//- (void)GX_setImageWithURL:(NSURL *)url 
//                      ptSize:(CGSize)size 
//            placeholderImage:(UIImage *)placeholder 
//                     options:(GXWebImageOptions)options 
//                   completed:(BFCWebImageCompletionBlock)completedBlock 
//{
//    [self GX_setImageWithURL:url ptSize:size placeholderImage:placeholder options:0 progress:nil completed:completedBlock];
//}
//
//- (void)GX_setImageWithURL:(NSURL *)url 
//                      ptSize:(CGSize)size 
//            placeholderImage:(UIImage *)placeholder 
//                     options:(GXWebImageOptions)options 
//                    progress:(BFCWebImageProgressBlock)progressBlock 
//                   completed:(BFCWebImageCompletionBlock)completedBlock
//{
//    //NSAssert((size.width != 0 && size.height != 0), @"ptSize参数为零");
//    if ([self.class GX_isURLEmpty:url]) {
//        [self GX_cancelCurrentImageRequest];
//        self.image = placeholder;
//        if (completedBlock) {
//            completedBlock(nil, EMPTY_URL_ERROR, 0, nil);
//        }
//        return;
//    }
//    
//    //    BOOL isWebpEnable = YYImageWebPAvailable();
//    //    NSLog(@"isWebpEnable %@", isWebpEnable ? @"YES":@"NO");
//    if (!(size.width && size.height)) {
//        size = CGSizeMake(self.frame.size.width * [UIScreen mainScreen].scale, self.frame.size.height * [UIScreen mainScreen].scale);
//        if (!(size.width && size.height)) {
//            size = [self GX_getImageSize];
//        }
//    } else {
//        size = CGSizeMake(size.width * [UIScreen mainScreen].scale, size.height * [UIScreen mainScreen].scale);
//    }
//    if (![[self class] GX_containsImageForKey:[[url webpImageURLWithPxSize:size] transferHttpToHttps].absoluteString]) {
//        GXWebImageQualityType type = [[self class] GX_currentImgQualitySettingType];
//        /// 如果是普通模式 或 自动模式且使用流量时使用低质量普通图片
//        if (type == GXWebImageQualityLow || (type == GXWebImageQualityAuto && [BFCReachaGXty currentStatus] != NetworkStatusReachableViaWiFi)) {
//            if (![UIDevice isIPad]) {
//                size = CGSizeMake(size.width / [UIScreen mainScreen].scale, size.height / [UIScreen mainScreen].scale);
//            }
//        }
//    }
//    __weak typeof (self) wself = self;
//    NSURL *imageURL = [[url webpImageURLWithPxSize:size] transferHttpToHttps];
//    [self yy_setImageWithURL:imageURL placeholder:placeholder options:[self.class yyOptions:options] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        if (progressBlock) {
//            progressBlock(receivedSize, expectedSize);
//        }
//    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        [[wself class] reportTotal:YES failed:NO];
//        if (error) {
//            [[wself class] reportTotal:NO failed:YES];
//            [[wself class] sendAppImageDownloadReport:url.absoluteString lib_type:1 error_code:error.code error_desc:error.localizedDescription cache_type:[[wself class] GXCacheTypeFromYY:from]];
//        }
//        if (completedBlock) {
//            completedBlock(image, error, [[wself class] GXCacheTypeFromYY:from], url);
//        }
//    }];
//}

/// 请求url图片的原图, 不添加任何剪裁参数(除非url自身携带了)
//- (void)GX_setImageWithOutClipURL:(NSURL *)url 
//                   placeholderImage:(nullable UIImage *)placeholder 
//                            options:(GXWebImageOptions)options 
//                           progress:(nullable BFCWebImageProgressBlock)progressBlock 
//                          completed:(nullable BFCWebImageCompletionBlock)completedBlock 
//{
//    [self GX_setImageWithOutClipURL:url placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock noWebp:NO];
//}
//
//- (void)GX_setImageWithOutClipURL:(NSURL *)url 
//                   placeholderImage:(UIImage *)placeholder 
//                            options:(GXWebImageOptions)options 
//                           progress:(BFCWebImageProgressBlock)progressBlock 
//                          completed:(BFCWebImageCompletionBlock)completedBlock noWebp:(BOOL)noWebP 
//{
//    if ([self.class GX_isURLEmpty:url]) {
//        [self GX_cancelCurrentImageRequest];
//        self.image = placeholder;
//        if (completedBlock) {
//            completedBlock(nil, EMPTY_URL_ERROR, 0, nil);
//        }
//        return;
//    }
//    
//    __weak typeof (self) wself = self;
//    NSURL *imageURL = nil;
//    if (noWebP) {
//        imageURL = url;
//    } else {
//        imageURL = [[url webpImageURLWithPxSize:CGSizeZero] transferHttpToHttps];
//    }
//    [self yy_setImageWithURL:imageURL placeholder:placeholder options:[self.class yyOptions:options] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        if (progressBlock) {
//            progressBlock(receivedSize, expectedSize);
//        }
//    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        if (error) {
//            [[wself class] sendAppImageDownloadReport:url.absoluteString lib_type:1 error_code:error.code error_desc:error.localizedDescription cache_type:[[wself class] GXCacheTypeFromYY:from]];
//        }
//        if (completedBlock) {
//            completedBlock(image, error, [[wself class] GXCacheTypeFromYY:from], url);
//        }
//    }];
//}
//
//+ (void)GX_downloadImageWithURL:(NSURL *)url 
//                         progress:(BFCWebImageProgressBlock)progressBlock 
//                        completed:(BFCWebImageDownloadCompletedBlock)completedBlock 
//{
//    [self GX_downloadImageWithURL:url ptSize:CGSizeZero options:0 progress:progressBlock completed:completedBlock];
//}
//
//+ (void)GX_downloadImageWithURL:(NSURL *)url 
//                          options:(GXWebImageOptions)options 
//                         progress:(BFCWebImageProgressBlock)progressBlock 
//                        completed:(BFCWebImageDownloadCompletedBlock)completedBlock 
//{
//    [self GX_downloadImageWithURL:url ptSize:CGSizeZero options:0 progress:progressBlock completed:completedBlock];
//}
//
//+ (void)GX_downloadImageWithURL:(NSURL *)url 
//                           ptSize:(CGSize)size 
//                          options:(GXWebImageOptions)options 
//                         progress:(nullable BFCWebImageProgressBlock)progressBlock 
//                        completed:(nullable BFCWebImageDownloadCompletedBlock)completedBlock
//{
//    if ([self GX_isURLEmpty:url]) {
//        if (completedBlock) {
//            completedBlock(nil, EMPTY_URL_ERROR, nil);
//        }
//        return;
//    }
//    
//    if (size.width && size.height) {
//        size = CGSizeMake(size.width * [UIScreen mainScreen].scale, size.height * [UIScreen mainScreen].scale);
//    }
//    __weak typeof (self) wself = self;
//    if (![self GX_containsImageForKey:[[url webpImageURLWithPxSize:size] transferHttpToHttps].absoluteString]) {
//        GXWebImageQualityType type = [[self class] GX_currentImgQualitySettingType];
//        /// 如果是普通模式 或 自动模式且使用流量时使用低质量普通图片
//        if (type == GXWebImageQualityLow || (type == GXWebImageQualityAuto && [BFCReachaGXty currentStatus] != NetworkStatusReachableViaWiFi)) {
//            if (![UIDevice isIPad]) {
//                size = CGSizeMake(size.width / [UIScreen mainScreen].scale, size.height / [UIScreen mainScreen].scale);
//            }
//        }
//    }
//    NSURL *imgURL = [[url webpImageURLWithPxSize:size] transferHttpToHttps];
//    [[YYWebImageManager sharedManager] requestImageWithURL:imgURL options:[self.class yyOptions:options] progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (progressBlock) {
//                progressBlock(receivedSize, expectedSize);
//            }
//        });
//    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        [[wself class] reportTotal:YES failed:NO];
//        if (error) {
//            [[wself class] reportTotal:NO failed:YES];
//            [[wself class] sendAppImageDownloadReport:url.absoluteString lib_type:1 error_code:error.code error_desc:error.localizedDescription cache_type:[[wself class] GXCacheTypeFromYY:from]];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (completedBlock) {
//                completedBlock(image, error, url);
//            }
//        });
//    }];
//}
//
//- (void)GX_cancelCurrentImageRequest
//{
//    [self yy_cancelCurrentImageRequest];
//}

//- (NSURL *)GX_clipUrlWithURL:(NSURL *)url 
//{
//    CGSize size = self.frame.size;
//    size = CGSizeMake(size.width * [UIScreen mainScreen].scale, size.height * [UIScreen mainScreen].scale);
//    return [self GX_clipUrlWithURL:url pxSize:size];
//}
//
//- (NSURL *)GX_clipUrlWithURL:(NSURL *)url pxSize:(CGSize)size 
//{
//    if (size.width && size.height) {
//        return [url imageURLWithPxSize:size];
//    }
//    return url;
//}
//
//- (CGSize)GX_getImageSize 
//{
//    if (self.bounds.size.width && self.bounds.size.height) {
//        if (self.bounds.size.width > self.bounds.size.height) {
//            CGFloat width = MIN(self.bounds.size.width * [UIScreen mainScreen].scale, 320);
//            CGFloat scale = self.bounds.size.width / width;
//            CGFloat height = self.bounds.size.height / scale;
//            return CGSizeMake(width, height);
//        } else {
//            CGFloat height = MIN(self.bounds.size.height * [UIScreen mainScreen].scale, 320);
//            CGFloat scale = self.bounds.size.height / height;
//            CGFloat width = self.bounds.size.width / scale;
//            return CGSizeMake(width, height);
//        }
//    }
//    return CGSizeMake(160 * [UIScreen mainScreen].scale, 100 * [UIScreen mainScreen].scale);
//}
//
//#pragma mark - data report
//+ (void)reportTotal:(BOOL)total failed:(BOOL)failed
//{
//    static NSInteger totalCount = 0;
//    static NSInteger failedCount = 0;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        totalCount = [[NSUserDefaults standardUserDefaults] integerForKey:GX_WEB_IMG_LOAD_TOTAL_COUNT];
//        failedCount = [[NSUserDefaults standardUserDefaults] integerForKey:GX_WEB_IMG_LOAD_FAILED_COUNT];
//    });
//    if (total) {
//        totalCount++;
//    }
//    if (failed) {
//        failedCount++;
//    }
//    if (totalCount >= GX_WEB_IMG_REPORT_MAX_COUNT) {
//        [[self class] sendAppImageDownloadCountReport:totalCount failed:failedCount];
//        totalCount = 0;
//        failedCount = 0;
//    }
//    if (totalCount == 0 || failedCount >= GX_WEB_IMG_CACHE_FAILED_COUNT) {
//        [[NSUserDefaults standardUserDefaults] setInteger:totalCount forKey:GX_WEB_IMG_LOAD_TOTAL_COUNT];
//        [[NSUserDefaults standardUserDefaults] setInteger:failedCount forKey:GX_WEB_IMG_LOAD_FAILED_COUNT];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//}

#pragma mark - type transform
//+ (GXWebImageCacheType)GXCacheTypeFromYY:(YYWebImageFromType)yyType 
//{
//    GXWebImageCacheType type = GXWebImageCacheNone;
//    
//    switch (yyType) {
//        case YYWebImageFromNone:
//        case YYWebImageFromRemote:
//            type = GXWebImageCacheNone;
//            break;
//        case YYWebImageFromDiskCache:
//            type = GXWebImageCacheDisk;
//            break;
//        case YYWebImageFromMemoryCache:
//        case YYWebImageFromMemoryCacheFast:
//            type = GXWebImageCacheMemeory;
//        default:
//            break;
//    }
//    return type;
//}

//+ (YYWebImageOptions)yyOptions:(GXWebImageOptions)GXOptions 
//{
//    YYWebImageOptions option = YYWebImageOptionSetImageWithFadeAnimation;
//    
//    if (GXOptions & GXWebImageCacheMemoryOnly) {
//        option |= YYWebImageOptionIgnoreDiskCache;
//    }
//    if (GXOptions & GXWebImageProgressive) {
//        option |= YYWebImageOptionProgressive;
//    }
//    if (GXOptions & GXWebImageRefreshCache) {
//        option |= YYWebImageOptionRefreshImageCache;
//    }
//    if (GXOptions & GXWebImageAllowBackgroundTask) {
//        option |= YYWebImageOptionAllowBackgroundTask;
//    }
//    if (GXOptions & GXWebImageHandleCookies) {
//        option |= YYWebImageOptionHandleCookies;
//    }
//    if (GXOptions & GXWebImageAllowInvalidSSL) {
//        option |= YYWebImageOptionAllowInvalidSSLCertificates;
//    }
//    if (GXOptions & GXWebImageIgnorePlaceHolder) {
//        option |= YYWebImageOptionIgnorePlaceHolder;
//    }
//    if (GXOptions & GXWebImageIgnoreAnimatedImage) {
//        option |= YYWebImageOptionIgnoreAnimatedImage;
//    }
//    if (GXOptions & GXWebImageIgnoreFailedURL) {
//        option |= YYWebImageOptionIgnoreFailedURL;
//    }
//    return option;
//}


@end
