//
//  GXOperationQueue.m
//  GXNetwork
//
//  Created by sunguangxin on 2017/9/8.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXOperationQueue.h"

@interface GXOperationQueue () <NSURLSessionDelegate> {
    NSURLSession *_session;
}

@end

@implementation GXOperationQueue

+ (nonnull instancetype)shared
{
    static GXOperationQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[GXOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 3;
        queue->_session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:queue delegateQueue:nil];
    });
    return queue;
}

- (NSURLSession *)session
{
    return self->_session;
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        if([challenge.protectionSpace.host containsString:@"gx"]){
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
            return;
        }
    }
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, challenge.proposedCredential);
}

@end
