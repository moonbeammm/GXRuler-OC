//
//  GXBaseCollectionViewFlowLayout.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GXColletionViewAnimationNull = 0,
    GXColletionViewAnimationLocalFade, // 原地alpha渐变刷新
}GXColletionViewAnimationMode;

@interface GXBaseCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) GXColletionViewAnimationMode animationMode;


@end
