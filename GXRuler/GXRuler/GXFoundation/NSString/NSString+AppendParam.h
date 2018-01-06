//
//  NSString+AppendParam.h
//  GXRuler
//
//  Created by sgx on 2018/1/6.
//  Copyright © 2018年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AppendParam)

- (NSString *)appendParamKey:(NSString *)paramKey paramValue:(NSString *)paramValue;

@end
