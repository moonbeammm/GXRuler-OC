//
//  UIImage+Corlor.m
//  GXPhone
//
//  Created by sunguangxin on 2017/11/10.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "UIImage+Corlor.h"

@implementation UIImage (Corlor)

- (UIImage *)drawCircleImage {
    return [self drawCircleImageWithImageViewSize:self.size radius:CGSizeMake(self.size.width/2.0, self.size.height/2.0) type:UIRectCornerAllCorners];
}

- (UIImage *)drawCircleImageWithImageViewSize:(CGSize)size radius:(CGSize)radius type:(UIRectCorner)type {
    
    CGFloat radiusW = radius.width;
    CGFloat radiusH = radius.height;
    
    if (self.size.width != size.width) {
        radiusW = radiusW * (self.size.width / size.width);
    }
    if (self.size.height != size.height) {
        radiusH = radiusH * (self.size.height / size.height);
    }
    radius = CGSizeMake(radiusW, radiusH);
    // 开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    // 画圆
    [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.size.width, self.size.height) byRoundingCorners:type cornerRadii:radius] addClip];
    // 将image绘制到刚才的圆形上
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    // 获得上下文的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius type:(GXRectCorner)type {
    radius = MIN(radius, MIN(size.width / 2, size.height));
    
    size.width = size.width ?: 10;
    size.height= size.height ?: 5;
    NSAssert([NSThread isMainThread], @"defulat image creater must in main thread");
    static NSCache *dict;
    if (!dict) {
        dict = [NSCache new];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * __unused notification) {
            [dict removeAllObjects];
        }];
    }
    NSString *key = NSStringFromCGSize(size);
    key = [key stringByAppendingFormat:@"concern-type%d-%@-%f", type, [UIImage hexStringFromColor:color], radius];
    UIImage *re = [dict objectForKey:key];
    if (!re) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextSaveGState(context);
        
        if (type & GXRectCornerTopLeft)
        {
            CGContextMoveToPoint(context, radius, 0);
            CGContextAddLineToPoint(context, 0, 0);
            CGContextAddLineToPoint(context, 0, radius);
            CGContextAddArc(context, radius, radius, radius, M_PI, 3*M_PI_2, 0);
            CGContextFillPath(context);
            CGContextRestoreGState(context);
        }
        
        if (type & GXRectCornerTopRight)
        {
            CGContextSaveGState(context);
            CGContextMoveToPoint(context, size.width-radius, 0);
            CGContextAddLineToPoint(context, size.width, 0);
            CGContextAddLineToPoint(context, size.width, radius);
            CGContextAddArc(context, size.width-radius, radius, radius, 0, 3*M_PI_2, 1);
            CGContextFillPath(context);
            CGContextRestoreGState(context);
        }
        
        if (type & GXRectCornerBtmLeft)
        {
            CGContextSaveGState(context);
            CGContextMoveToPoint(context, 0, size.height-radius);
            CGContextAddLineToPoint(context, 0, size.height);
            CGContextAddLineToPoint(context, radius, size.height);
            CGContextAddArc(context, radius, size.height-radius, radius, M_PI_2, M_PI, 0);
            CGContextFillPath(context);
            CGContextRestoreGState(context);
        }
        
        if (type & GXRectCornerBtmRight)
        {
            CGContextSaveGState(context);
            CGContextMoveToPoint(context, size.width-radius, size.height);
            CGContextAddLineToPoint(context, size.width, size.height);
            CGContextAddLineToPoint(context, size.width, size.height-radius);
            CGContextAddArc(context, size.width-radius, size.height-radius, radius, 0,M_PI_2, 0);
            CGContextFillPath(context);
            CGContextRestoreGState(context);
        }
        
        re = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (re) {
            [dict setObject:re forKey:key];
        }
    }
    return re;
}

+ (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

@end
