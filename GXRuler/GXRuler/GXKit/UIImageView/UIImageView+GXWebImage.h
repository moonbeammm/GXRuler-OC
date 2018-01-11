//
//  UIImageView+GXWebImage.h
//  GXRuler
//
//  Created by sunguangxin on 2017/10/20.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 当前下载的图片质量
typedef NS_ENUM(NSInteger, GXWebImageQualityType) {
    /// 高清（质量高，图片更清晰）
    GXWebImageQualityHigh = 0,
    /// 普通（流量少，速度加载快）
    GXWebImageQualityLow,
    /// 自动（wifi下使用清晰，流量下使用普通）
    GXWebImageQualityAuto
};

typedef NS_ENUM(NSInteger, GXWebImageCacheType) {
    /// No value.
    GXWebImageCacheNone = 0,
    
    /// Fetched from memory cache.
    GXWebImageCacheMemeory,
    
    /// Fetched from disk cache.
    GXWebImageCacheDisk
};

typedef NS_OPTIONS(NSInteger, GXWebImageOptions) {
    /// Do not load image from/to disk cache.
    GXWebImageMemoryOnly = 1 << 0,
    
    /// Display progressive/interlaced/baseline image during download (same as web browser).
    GXWebImageProgressive = 1 << 1,
    
    /// Load the image from remote and refresh the image cache.
    GXWebImageRefreshCache = 1 << 2,
    
    /// Allows background task to download image when app is in background.
    GXWebImageAllowBackgroundTask = 1 << 3,
    
    /// Handles cookies stored in NSHTTPCookieStore.
    GXWebImageHandleCookies = 1 << 4,
    
    /// Allows untrusted SSL ceriticates.
    GXWebImageAllowInvalidSSL = 1 << 5,
    
    /// Do not change the view's image before set a new URL to it.
    GXWebImageIgnorePlaceHolder = 1 << 6,
    
    /// Ignore multi-frame image decoding.
    /// This will handle the GIF/APNG/WebP/ICO image as single frame image.
    GXWebImageIgnoreAnimatedImage = 1 << 7,
    
    /// This flag will add the URL to a blacklist (in memory) when the URL fail to be downloaded,
    /// so the library won't keep trying.
    GXWebImageIgnoreFailedURL = 1 << 8
};

typedef void(^GXWebImageProgressBlock)(NSInteger receivedSize, 
                                       NSInteger ptSize);

typedef void(^GXWebImageCompletionBlock)(UIImage * _Nullable image, 
                                         NSError * _Nullable error,
                                          GXWebImageCacheType cacheType, 
                                         NSURL *_Nullable imageURL);

typedef void(^GXWebImageDownloadCompletedBlock)(UIImage * _Nullable image, 
                                                NSError * _Nullable error, 
                                                NSURL * _Nullable imageURL);

@interface UIImageView (GXWebImage)

- (void)gx_setImageWithURL:(NSString *_Nullable)url;
- (void)gx_setImageWithURL:(NSString *_Nullable)url ptSize:(CGSize)size;
- (void)gx_setImageWithURL:(NSString *_Nullable)url completed:(GXWebImageCompletionBlock _Nonnull )completedBlock;
- (void)gx_setImageWithURL:(NSString *_Nullable)url ptSize:(CGSize)size placeholderImage:(UIImage *_Nullable)placeholder;
- (void)gx_setImageWithURL:(NSString *_Nullable)url
          placeholderImage:(UIImage *_Nullable)placeholder
                 completed:(GXWebImageCompletionBlock _Nullable )completedBlock;
- (void)gx_setImageWithURL:(NSString *_Nullable)url
                    ptSize:(CGSize)size
          placeholderImage:(UIImage *_Nullable)placeholder
                   options:(GXWebImageOptions)options
                 completed:(GXWebImageCompletionBlock _Nullable )completedBlock;
- (void)gx_setImageWithURL:(NSString *_Nullable)url 
                    ptSize:(CGSize)size 
          placeholderImage:(nullable UIImage *)placeholder
                     options:(GXWebImageOptions)options 
                  progress:(nullable GXWebImageProgressBlock)progressBlock
                   completed:(nullable GXWebImageCompletionBlock)completedBlock;
+ (void)gx_downloadImageWithURL:(NSString *_Nullable)url ptSize:(CGSize)size 
                        options:(GXWebImageOptions)options 
                       progress:(nullable GXWebImageProgressBlock)progressBlock 
                      completed:(nullable GXWebImageDownloadCompletedBlock)completedBlock;

@end















