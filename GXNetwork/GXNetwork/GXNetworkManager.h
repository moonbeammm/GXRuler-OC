//
//  GXNetworkManager.h
//  GXNetwork
//
//  Created by sunguangxin on 2017/4/20.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GXApiOptions.h"

@interface GXNetworkManager : NSObject

/**
 发起异步请求
 */
- (void)requestAsync;

/**
 发起同步请求
 */
- (void)requestSync;

/**
 取消请求
 */
- (void)cancel;

/**
 给两个请求添加依赖关系
 */
- (void)addDependency;

/**
 取消依赖
 */
- (void)removeDependency;

/**
 清除所有缓存
 */
- (void)cleanCache;

@property (atomic, copy, nullable) NSData * _Nullable (^preProcessRawData)(NSData * _Nullable);

/**
 1.设置请求参数.
 2.设置请求完成的回调.
 */
- (instancetype _Nullable )initWithOptions:(GXApiOptions *_Nullable)options
                                   success:(nullable void (^)(NSDictionary * _Nullable result, NSURLResponse * _Nullable response))success
                                   failure:(nullable void (^)(NSDictionary * _Nullable result, NSError * _Nullable error))failure;
- (instancetype _Nullable )initWithOptions:(GXApiOptions *_Nullable)options
                              progress:(nullable void (^)(NSProgress * _Nullable downloadProgress))downloadProgress
                               success:(nullable void (^)(NSDictionary * _Nullable result, NSURLResponse * _Nullable response))success
                               failure:(nullable void (^)(NSDictionary * _Nullable result, NSError * _Nullable error))failure;

@end
