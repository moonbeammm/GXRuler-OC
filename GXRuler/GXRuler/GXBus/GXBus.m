//
//  GXBus.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXBus.h"

@interface GXBus (){
    NSString *_name;
}

@end

@implementation GXBus


- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        _name = name;
    }
    return self;
}

+ (instancetype)busWithName:(NSString *)name {
    return [[self alloc] initWithName:name];
}

#pragma mark - Property
- (NSString *)name
{
    return _name;
}

#pragma mark - Register
- (void)willBeRegistered {
    // override me
}

- (void)didBeenRegistered {
    // override me
}

#pragma mark - CallFunction
- (GXBusModel *)callFunction:(NSString *)function
                    withModel:(GXBusModel *)model {
    return nil;
}

- (void)callAsyncFunction:(NSString *)function
                withModel:(GXBusModel *)model
              resultBlock:(GXBusResultBlock)resultBlock {
    if (resultBlock) {
        resultBlock(nil);
    }
}

@end
