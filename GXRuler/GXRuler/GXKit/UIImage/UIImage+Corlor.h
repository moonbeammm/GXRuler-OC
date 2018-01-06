//
//  UIImage+Corlor.h
//  GXPhone
//
//  Created by sunguangxin on 2017/11/10.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    GXRectCornerTopLeft = 1 << 0,
    GXRectCornerTopRight = 1 << 1,
    GXRectCornerBtmLeft = 1 << 2,
    GXRectCornerBtmRight = 1 << 3,
    GXRectCornerLeft= GXRectCornerTopLeft | GXRectCornerBtmLeft,
    GXRectCornerRight= GXRectCornerTopRight | GXRectCornerBtmRight,
    GXRectCornerTop = GXRectCornerTopLeft | GXRectCornerTopRight,
    GXRectCornerBtm = GXRectCornerBtmLeft | GXRectCornerBtmRight,
    GXRectCornerAll = GXRectCornerTop | GXRectCornerBtm
}GXRectCorner;

@interface UIImage (Corlor)

- (UIImage *)drawCircleImage;
- (UIImage *)drawCircleImageWithImageViewSize:(CGSize)size radius:(CGSize)radius type:(UIRectCorner)type;
/**
 * 获取一个中间为圆形透明的方形图片.
 * 使用方法
 - (UIImageView *)cornerImgView {
     if (_cornerImgView == nil) {
         _cornerImgView = [[UIImageView alloc] init];
         /// 1.创建一个透明的UIImageView 必须设置为clearColor
         _cornerImgView.backgroundColor = [UIColor clearColor];
         /// 2.创建一张白色图片.size为20 x 20. 中间半径为10的圆镂空(即透明)
         UIImage *image = [UIImage concernImageWithColor:[UIColor whiteColor] size:CGSizeMake(20, 20) cornerRadius:8.0 cornerType:GXRectCornerAll];
         /// 3.以图片的中心作为拉伸点.拉伸图片.
         image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
         /// 4.将图片赋值给imageView.
         _cornerImgView.image = image;
     }
     return _cornerImgView;
 }
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius type:(GXRectCorner)type;

@end
