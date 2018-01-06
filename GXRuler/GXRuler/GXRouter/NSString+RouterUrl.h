//
//  NSString+RouterUrl.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/15.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RouterUrl)

- (BOOL)isWebUrl;
- (BOOL)isDirectOpenUrl;

- (NSString *)tryTransferToAppScheme;

@end
