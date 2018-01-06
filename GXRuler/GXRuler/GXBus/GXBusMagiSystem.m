//
//  GXBusMagiSystem.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXBusMagiSystem.h"
#import "GXBusModel.h"
#import "GXBusValidator.h"
#import "GXBus.h"

#define AsyncFunctionReturn(RESULT) if (resultBlock) { resultBlock(RESULT); } return

@interface GXBusMagiSystem () {
    BOOL _lock;
    NSMutableDictionary *_subBusDict;
}

@end

@implementation GXBusMagiSystem

+ (instancetype)sharedMagiSystem
{
    static GXBusMagiSystem* magiSystem = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        magiSystem = [GXBusMagiSystem new];
    });
    
    return magiSystem;
}

- (instancetype)init
{
    if (self = [super init]) {
        _subBusDict = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Register
- (void)registerSubBus:(GXBus *)subBus {
    if (_lock) {
        NSAssert(NO, @"GXBusMagiSystem: 总线控制中枢已被锁定");
        return;
    }
    if (!(subBus && [subBus isKindOfClass:[GXBus class]] && [subBus.name length] > 0)) {
        NSAssert(NO, @"GXBusMagiSystem: 无效的子总线");
        return;
    }
    if ([_subBusDict.allKeys containsObject:subBus.name]) {
        NSAssert(NO, @"GXBusMagiSystem: 已经存在的子总线");
        return;
    }
    _lock = YES;
    [subBus willBeRegistered];
    [_subBusDict setObject:subBus forKey:subBus.name];
    [subBus didBeenRegistered];
    _lock = NO;
}

+ (void)registerSubBus:(GXBus *)subBus {
    [[GXBusMagiSystem sharedMagiSystem] registerSubBus:subBus];
}

- (void)lock {
    _lock = YES;
}

+ (void)lock {
    [[GXBusMagiSystem sharedMagiSystem] lock];
}

#pragma mark - CallFunction
- (GXBus *)subBusForFunction:(NSString *)function {
    if (!(function && [function isKindOfClass:[NSString class]] && [function length] > 0)) {
        NSAssert(NO, @"GXBusMagiSystem: 无效的总线方法名");
        return nil;
    }
    NSRange range = [function rangeOfString:@"/"];
    if (range.location == NSNotFound || range.location == 0) {
        NSAssert(NO, @"GXBusMagiSystem: 无法检测到子总线名");
        return nil;
    }
    NSString *subBusName = [function substringWithRange:NSMakeRange(0, range.location)];
    if (![_subBusDict.allKeys containsObject:subBusName]) {
        return nil;
    }
    GXBus *subBus = [_subBusDict objectForKey:subBusName];
    if (!(subBus && [subBus isKindOfClass:[GXBus class]] && [subBus.name isEqualToString:subBusName])) {
        NSAssert(NO, @"GXBusMagiSystem: 对应子总线无效");
        return nil;
    }
    return subBus;
}

+ (GXBusModel *)callFunction:(NSString *)function
                    withModel:(GXBusModel *)model
                    validator:(GXBusValidator *)validator {
    GXBus *subBus = [[GXBusMagiSystem sharedMagiSystem] subBusForFunction:function];
    if (!subBus) {
        return nil;
    }
    if (model && ![model isMemberOfClass:[GXBusModel class]]) {
        NSAssert(NO, @"GXBusMagiSystem: 无效的输入模型");
        return nil;
    }
    if (validator && ![validator isMemberOfClass:[GXBusValidator class]]) {
        NSAssert(NO, @"GXBusMagiSystem: 无效的验证器");
        return nil;
    }
    GXBusModel *result = [subBus callFunction:function withModel:model];
    if (validator && ![validator validateModel:result]) {
        NSAssert(NO, @"GXBusMagiSystem: 验证失败");
        return nil;
    }
    return result;
}

+ (void)callAsyncFunction:(NSString *)function
                withModel:(GXBusModel *)model
                validator:(GXBusValidator *)validator
              resultBlock:(GXBusResultBlock)resultBlock {
    GXBus *subBus = [[GXBusMagiSystem sharedMagiSystem] subBusForFunction:function];
    if (!subBus) {
        AsyncFunctionReturn(nil);
    }
    if (model && ![model isMemberOfClass:[GXBusModel class]]) {
        NSAssert(NO, @"GXBusMagiSystem: 无效的输入模型");
        AsyncFunctionReturn(nil);
    }
    if (validator && ![validator isMemberOfClass:[GXBusValidator class]]) {
        NSAssert(NO, @"GXBusMagiSystem: 无效的验证器");
        AsyncFunctionReturn(nil);
    }
    [subBus callAsyncFunction:function withModel:model resultBlock:^(GXBusModel *result) {
        if (validator && ![validator validateModel:result]) {
            NSAssert(NO, @"GXBusMagiSystem: 验证失败");
            AsyncFunctionReturn(nil);
        }
        AsyncFunctionReturn(result);
    }];
}

@end
