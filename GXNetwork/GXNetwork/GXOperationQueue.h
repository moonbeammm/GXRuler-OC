//
//  GXOperationQueue.h
//  GXNetwork
//
//  Created by sunguangxin on 2017/9/8.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXOperationQueue : NSOperationQueue

+ (nonnull instancetype)shared;
- (nonnull NSURLSession *)session;

@end
