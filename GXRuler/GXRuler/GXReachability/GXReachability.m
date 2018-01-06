//
//  GXReachability.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXReachability.h"
#import "Reachability.h"

@interface GXReachability ()

@property (nonatomic, strong) Reachability *reach;
//@property (nonatomic, strong) RACSubject *subject;
@property (atomic   , assign) GXNetworkStatus status;

@end

@implementation GXReachability


+ (GXReachability *)sharedReachability
{
    static GXReachability *sharedReachability_;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedReachability_ = [GXReachability new];
        [[NSNotificationCenter defaultCenter] addObserver:sharedReachability_
                                                 selector:@selector(reachNotifHandler:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        if ([NSThread isMainThread]) {
            [sharedReachability_.reach startNotifier];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [sharedReachability_.reach startNotifier];
            });
        }
    });
    
    return sharedReachability_;
}

+ (GXNetworkStatus)currentStatus
{
    return [GXReachability sharedReachability].status;
}

+ (RACSignal *)statusSignal
{
    return nil;//[GXReachability sharedReachability].subject;
}

+ (BOOL)isReachable
{
    return [GXReachability sharedReachability].status != NetworkStatusNotReachable;
}

+ (BOOL)isReachableViaWiFi
{
    return [GXReachability sharedReachability].status == NetworkStatusReachableViaWiFi;
}

+ (BOOL)isReachableViaWWAN
{
    return [GXReachability sharedReachability].status == NetworkStatusReachableViaWWAN;
}

- (instancetype)init
{
    if (self = [super init]) {
        _reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        _status = (GXNetworkStatus)[self.reach currentReachabilityStatus];
//        _subject = [RACSubject subject];
    }
    return self;
}

- (void)reachNotifHandler:(NSNotification *)notification
{
    Reachability *reach = [notification object];
    if (reach && reach == self.reach && self.status != [reach currentReachabilityStatus]) {
        self.status = (GXNetworkStatus)[reach currentReachabilityStatus];
//        [self.subject sendNext:@(self.status)];
    }
}

@end
