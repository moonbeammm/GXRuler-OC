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
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, weak) id<GXOperationProtocol> delegate;

@property (nonatomic, strong) BOOL (^beforeRequestCallback)(void);
@property (nonatomic, strong) void (^afterRequestCallback)(NSData *, NSURLResponse *, NSError *);

- (void)execute:(BOOL)immediately;

@end
