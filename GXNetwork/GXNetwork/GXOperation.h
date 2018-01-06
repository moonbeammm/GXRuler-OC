//
//  GXOperation.h
//  GXNetwork
//
//  Created by sunguangxin on 2017/9/8.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GXOperationProtocol <NSObject>

- (void)cancelRequest;

@end

@interface GXOperation : NSOperation
@property (nonatomic, strong, nonnull) NSURLRequest *request;
@property (nonatomic, weak) id<GXOperationProtocol> delegate;


@property (nonatomic, strong, nonnull) BOOL (^beforeRequestCallback)(void);
@property (nonatomic, strong, nonnull) void (^afterRequestCallback)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

- (void)execute:(BOOL)immediately;

@end
