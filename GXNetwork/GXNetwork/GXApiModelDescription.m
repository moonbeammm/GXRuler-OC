//
//  GXApiModelDescription.m
//  GXNetwork
//
//  Created by sunguangxin on 2017/10/20.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXApiModelDescription.h"

@implementation GXApiModelDescription

+ (instancetype)modelWith:(NSString *)keyPath mappingClass:(Class)mappingClass isArray:(BOOL)isArray
{
    return [self modelWith:keyPath mappingClass:mappingClass isArray:isArray isOptional:NO];
}

+ (instancetype)modelWith:(NSString *)keyPath mappingClass:(Class)mappingClass isArray:(BOOL)isArray isOptional:(BOOL)isOption;
{
    NSAssert(keyPath && [keyPath length], @"keypath 不能为空");
    NSAssert(mappingClass, @"Class 不能为空");
    GXApiModelDescription *model = [GXApiModelDescription new];
    model.keyPath = keyPath ? : @"result";
    model.mappingClass = mappingClass ? : [NSDictionary class];
    model.isArray = isArray;
    model.isOptional = isOption;
    return model;
}

@end
