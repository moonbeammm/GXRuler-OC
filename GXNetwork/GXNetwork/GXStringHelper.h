//
//  GXStringHelper.h
//  GXNetwork
//
//  Created by sunguangxin on 2017/9/8.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXStringHelper : NSObject
+ (nonnull NSMutableString *)getQueryStrWithParams:(NSMutableDictionary * _Nullable)params;
@end
