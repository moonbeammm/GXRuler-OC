//
//  UIImageView+WebCache.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 当前下载的图片质量
//typedef NS_ENUM(NSInteger, GXWebImageQualityType) {
//    /// 高清（质量高，图片更清晰）
//    GXWebImageQualityHigh = 0,
//    /// 普通（流量少，速度加载快）
//    GXWebImageQualityLow,
//    /// 自动（wifi下使用清晰，流量下使用普通）
//    GXWebImageQualityAuto
//};
//
//typedef NS_ENUM(NSInteger, GXWebImageCacheType) {
//    /// No value.
//    GXWebImageCacheNone = 0,
//    
//    /// Fetched from memory cache.
//    GXWebImageCacheMemeory,
//    
//    /// Fetched from disk cache.
//    GXWebImageCacheDisk
//};
//
//typedef NS_OPTIONS(NSInteger, GXWebImageOptions) {
//    /// Do not load image from/to disk cache.
//    GXWebImageCacheMemoryOnly = 1 << 0,
//    
//    /// Display progressive/interlaced/baseline image during download (same as web browser).
//    GXWebImageProgressive = 1 << 1,
//    
//    /// Load the image from remote and refresh the image cache.
//    GXWebImageRefreshCache = 1 << 2,
//    
//    /// Allows background task to download image when app is in background.
//    GXWebImageAllowBackgroundTask = 1 << 3,
//    
//    /// Handles cookies stored in NSHTTPCookieStore.
//    GXWebImageHandleCookies = 1 << 4,
//    
//    /// Allows untrusted SSL ceriticates.
//    GXWebImageAllowInvalidSSL = 1 << 5,
//    
//    /// Do not change the view's image before set a new URL to it.
//    GXWebImageIgnorePlaceHolder = 1 << 6,
//    
//    /// Ignore multi-frame image decoding.
//    /// This will handle the GIF/APNG/WebP/ICO image as single frame image.
//    GXWebImageIgnoreAnimatedImage = 1 << 7,
//    
//    /// This flag will add the URL to a blacklist (in memory) when the URL fail to be downloaded,
//    /// so the library won't keep trying.
//    GXWebImageIgnoreFailedURL = 1 << 8
//};
//
//typedef void(^BFCWebImageProgressBlock)(NSInteger receivedSize, NSInteger ptSize);
//
//typedef void(^BFCWebImageCompletionBlock)(UIImage * _Nullable image, NSError * _Nullable error, GXWebImageCacheType cacheType, NSURL *_Nullable imageURL);
//
//typedef void(^BFCWebImageDownloadCompletedBlock)(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface UIImageView (WebCache)

/// 当前下载的图片质量
//+ (GXWebImageQualityType)GX_currentImgQualitySettingType;
///// 设置当前下载的图片质量
//+ (void)GX_updateCurrentImgQualitySetting:(GXWebImageQualityType)type;
//
//// 图片下载最大并行任务数
//+ (void)GX_setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads;
//
//+ (void)GX_setMaxMemoryCost:(NSUInteger)maxMemoryCost;
//
//+ (unsigned long long)GX_getImageCacheSize;
//
//+ (void)GX_clearImageCache;
//
//+ (void)GX_setCacheLimit:(NSUInteger)limit;
//
//// 从缓存中取图片
//+ (UIImage *_Nullable)GX_getCachedImage:(NSString *_Nonnull)name;
//
///// 删除缓存了的图片, isOnlyMemeryCache表示是否仅删除内存中的缓存, 不清除磁盘缓存
//+ (void)GX_removeCachedImageForKey:(NSString *_Nonnull)key isOnlyMemeryCache:(BOOL)isOnlyMemeryCache;
//
//
///// 剪裁图片的像素大小(px) = 屏幕分辨率(pt) * [UIScreen mainScreen].scale
///// ptSize: 一般情况下等同于UIImageView.frame.size, 也即图片对应的屏幕分辨率大小 (注意: 当前函数中会自动乘以[UIScreen mainScreen].scale)
//- (void)GX_setImageWithURL:(NSURL *_Nonnull)url ptSize:(CGSize)size;
//
///// 剪裁图片的像素大小(px) = 屏幕分辨率(pt) * [UIScreen mainScreen].scale
///// ptSize: 一般情况下等同于UIImageView.frame.size, 也即图片对应的屏幕分辨率大小 (注意: 当前函数中会自动乘以[UIScreen mainScreen].scale)
//- (void)GX_setImageWithURL:(NSURL *_Nonnull)url ptSize:(CGSize)size placeholderImage:(nullable UIImage *)placeholder;
//
///// 剪裁图片的像素大小(px) = 屏幕分辨率(pt) * [UIScreen mainScreen].scale
///// ptSize: 一般情况下等同于UIImageView.frame.size, 也即图片对应的屏幕分辨率大小 (注意: 当前函数中会自动乘以[UIScreen mainScreen].scale)
//- (void)GX_setImageWithURL:(NSURL *_Nonnull)url ptSize:(CGSize)size placeholderImage:(nullable UIImage *)placeholder
//                     options:(GXWebImageOptions)options;
//
///// 剪裁图片的像素大小(px) = 屏幕分辨率(pt) * [UIScreen mainScreen].scale
///// ptSize: 一般情况下等同于UIImageView.frame.size, 也即图片对应的屏幕分辨率大小 (注意: 当前函数中会自动乘以[UIScreen mainScreen].scale)
//- (void)GX_setImageWithURL:(NSURL *_Nonnull)url ptSize:(CGSize)size completed:(nullable BFCWebImageCompletionBlock)completedBlock;
//
///// 剪裁图片的像素大小(px) = 屏幕分辨率(pt) * [UIScreen mainScreen].scale
///// ptSize: 一般情况下等同于UIImageView.frame.size, 也即图片对应的屏幕分辨率大小 (注意: 当前函数中会自动乘以[UIScreen mainScreen].scale)
//- (void)GX_setImageWithURL:(NSURL *_Nonnull)url ptSize:(CGSize)size placeholderImage:(nullable UIImage *)placeholder
//                   completed:(nullable BFCWebImageCompletionBlock)completedBlock;
//
///// 剪裁图片的像素大小(px) = 屏幕分辨率(pt) * [UIScreen mainScreen].scale
///// ptSize: 一般情况下等同于UIImageView.frame.size, 也即图片对应的屏幕分辨率大小 (注意: 当前函数中会自动乘以[UIScreen mainScreen].scale)
//- (void)GX_setImageWithURL:(NSURL *_Nonnull)url ptSize:(CGSize)size placeholderImage:(nullable UIImage *)placeholder
//                     options:(GXWebImageOptions)options completed:(nullable BFCWebImageCompletionBlock)completedBlock;
//
///// 剪裁图片的像素大小(px) = 屏幕分辨率(pt) * [UIScreen mainScreen].scale
///// ptSize: 一般情况下等同于UIImageView.frame.size, 也即图片对应的屏幕分辨率大小 (注意: 当前函数中会自动乘以[UIScreen mainScreen].scale)
//- (void)GX_setImageWithURL:(NSURL *_Nonnull)url ptSize:(CGSize)size placeholderImage:(nullable UIImage *)placeholder
//                     options:(GXWebImageOptions)options progress:(nullable BFCWebImageProgressBlock)progressBlock
//                   completed:(nullable BFCWebImageCompletionBlock)completedBlock;
//
///// 请求url图片的原图, 不添加任何剪裁参数(除非url自身携带了)
//- (void)GX_setImageWithOutClipURL:(NSURL *_Nonnull)url placeholderImage:(nullable UIImage *)placeholder options:(GXWebImageOptions)options progress:(nullable BFCWebImageProgressBlock)progressBlock completed:(nullable BFCWebImageCompletionBlock)completedBlock;
//
///// 请求url图片的原图，也不转换成WebP，啥也不干 _(:3 」∠)_
//- (void)GX_setImageWithOutClipURL:(NSURL *_Nonnull)url placeholderImage:(nullable UIImage *)placeholder options:(GXWebImageOptions)options progress:(nullable BFCWebImageProgressBlock)progressBlock completed:(nullable BFCWebImageCompletionBlock)completedBlock
//                             noWebp:(BOOL)noWebP;
//
//- (NSURL *_Nullable)GX_clipUrlWithURL:(NSURL *_Nonnull)url;
//
///// pxSize: 剪裁图片的像素大小(px)
//- (NSURL *_Nullable)GX_clipUrlWithURL:(NSURL *_Nonnull)url pxSize:(CGSize)size;
//
//// 图片预加载
//+ (void)GX_downloadImageWithURL:(NSURL *_Nonnull)url progress:(nullable BFCWebImageProgressBlock)progressBlock
//                        completed:(nullable BFCWebImageDownloadCompletedBlock)completedBlock;
//
//+ (void)GX_downloadImageWithURL:(NSURL *_Nonnull)url options:(GXWebImageOptions)options progress:(nullable BFCWebImageProgressBlock)progressBlock completed:(nullable BFCWebImageDownloadCompletedBlock)completedBlock;
//
///// 剪裁图片的像素大小(px) = 屏幕分辨率(pt) * [UIScreen mainScreen].scale
///// ptSize: 一般情况下等同于UIImageView.frame.size, 也即图片对应的屏幕分辨率大小 (注意: 当前函数中会自动乘以[UIScreen mainScreen].scale)
//+ (void)GX_downloadImageWithURL:(NSURL *_Nonnull)url ptSize:(CGSize)size options:(GXWebImageOptions)options progress:(nullable BFCWebImageProgressBlock)progressBlock completed:(nullable BFCWebImageDownloadCompletedBlock)completedBlock;

@end
