//
//  GXOperation.m
//  GXNetwork
//
//  Created by sunguangxin on 2017/9/8.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXOperation.h"
#import "GXOperationQueue.h"

@implementation GXOperation

- (void)execute:(BOOL)immediately
{
    if (immediately) {
        [self main];
    } else {
        [[GXOperationQueue shared] addOperation:self];
    }
}

- (void)main
{
    @autoreleasepool {
        NSAssert(self.request, @"GXNetwork Request Operation has to exist a valid url request");
        
//        if (!self.beforeRequestCallback()) {
//            [_delegate cancelRequest];
//            return;
//        }
        
        NSLog(@"GXOperation start request =%@",[self requestLog]);
        NSCondition *condition = [NSCondition new];
        __block NSData * _Nullable resData = NULL;
        __block NSURLResponse * _Nullable resResponse = NULL;
        __block NSError * _Nullable resError = NULL;
        __block BOOL handled = NO;
        
        
        [[[[GXOperationQueue shared] session] dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            [condition lock];
            
            if (!handled) {
                handled = YES;
                resData = data;
                resResponse = response;
                resError = error;
            }
            
            [condition signal];
            [condition unlock];
        }] resume];
        
        [condition lock];
        [condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:MAX(self.request.timeoutInterval, 10.f)]];
        if (!handled) {
            handled = YES;
        }
        [condition unlock];
        if (self.isCancelled) {
            return;
        }
        self.afterRequestCallback(resData, resResponse, resError);
    }
}

- (void)cancel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelRequest)]) {
        [self.delegate cancelRequest];
    }
}



























- (NSString *)requestLog
{
    NSMutableString *commandString = [NSMutableString stringWithFormat:@"curl --compressed -X %@", self.request.HTTPMethod];
    [[self.request allHTTPHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop) {
        [commandString appendFormat:@" -H \'%@: %@\'", key, val];
    }];
    [commandString appendFormat:@" \'%@\'",  self.request.URL.absoluteString];
    NSData *data = self.request.HTTPBody;
    [commandString appendFormat:@" -d \'%@\'", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
    NSString *locale = [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]];
    NSMutableString *displayString = [NSMutableString stringWithFormat:@"%@\nRequest\n-------\n%@",locale, commandString];
    return displayString;
}

@end
