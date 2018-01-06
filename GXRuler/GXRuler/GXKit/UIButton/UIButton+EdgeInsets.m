//
//  UIButton+EdgeInsets.m
//  测试
//
//  Created by GX on 16/6/8.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "UIButton+EdgeInsets.h"

@implementation UIButton (EdgeInsets)

-(void)setButtonEdgeInsets:(ButtonEdgeInsets)style padding:(CGFloat)padding
{
    if (self.imageView.image == nil || self.titleLabel.text == nil) {
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
    }
    
    //先还原
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.imageEdgeInsets = UIEdgeInsetsZero;
    
    CGFloat imageWidth = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    CGFloat imageX = self.imageView.frame.origin.x;
    CGFloat imageY = self.imageView.frame.origin.y;
    
    CGFloat titleWidth = self.titleLabel.frame.size.width;
    CGFloat titleHeight = self.titleLabel.frame.size.height;
    CGFloat titleX = self.titleLabel.frame.origin.x;
    CGFloat titleY = self.titleLabel.frame.origin.y;
    
    CGFloat totalHeight = imageHeight + padding + titleHeight;
    CGFloat selfHeight = self.frame.size.height;
    CGFloat selfWidth = self.frame.size.width;
    
    switch (style) {
        case ButtonEdgeInsetsLeft:
            if (padding != 0)
            {
                self.titleEdgeInsets = UIEdgeInsetsMake(0, padding/2.0, 0, -padding/2.0);
                self.imageEdgeInsets = UIEdgeInsetsMake(0, -padding/2.0, 0, padding/2.0);
            }
            break;
        case ButtonEdgeInsetsRight:
        {
            //图片在右，文字在左
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + padding/2.0), 0, (imageWidth + padding/2.0));
            self.imageEdgeInsets = UIEdgeInsetsMake(0, (titleWidth+ padding/2.0), 0, -(titleWidth+ padding/2.0));
        }
            break;
        case ButtonEdgeInsetsTop:
        {
            //图片在上，文字在下
            self.titleEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2.0 + imageHeight + padding - titleY),
                                                    (selfWidth/2.0 - titleX - titleWidth /2.0) - (selfWidth - titleWidth) / 2.0,
                                                    -((selfHeight - totalHeight)/2.0 + imageHeight + padding - titleY),
                                                    -(selfWidth/2.0 - titleX - titleWidth /2.0) - (selfWidth - titleWidth) / 2.0);
            
            self.imageEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2.0 - imageY),
                                                    (selfWidth /2.0 - imageX - imageWidth / 2.0),
                                                    -((selfHeight - totalHeight)/2.0 - imageY),
                                                    -(selfWidth /2.0 - imageX - imageWidth / 2.0));
            
        }
            break;
        case ButtonEdgeInsetsBottom:
        {
            //图片在下，文字在上。
            self.titleEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2.0 - titleY),
                                                    (selfWidth/2.0 - titleX - titleWidth / 2.0) - (selfWidth - titleWidth) / 2.0,
                                                    -((selfHeight - totalHeight)/2.0 - titleY),
                                                    -(selfWidth/2.0 - titleX - titleWidth / 2.0) - (selfWidth - titleWidth) / 2.0);
            
            self.imageEdgeInsets = UIEdgeInsetsMake(((selfHeight - totalHeight)/2.0 + titleHeight + padding - imageY),
                                                    (selfWidth /2.0 - imageX - imageWidth / 2.0),
                                                    -((selfHeight - totalHeight)/2.0 + titleHeight + padding - imageY),
                                                    -(selfWidth /2.0 - imageX - imageWidth / 2.0));
        }
            break;
        case ButtonEdgeInsetsCenterTop:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(-(titleY - padding),
                                                    (selfWidth / 2.0 -  titleX - titleWidth / 2.0) - (selfWidth - titleWidth) / 2.0,
                                                    (titleY - padding),
                                                    -(selfWidth / 2.0 -  titleX - titleWidth / 2.0) - (selfWidth - titleWidth) / 2.0);
            
            self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                    (selfWidth / 2.0 - imageX - imageWidth / 2.0),
                                                    0,
                                                    -(selfWidth / 2.0 - imageX - imageWidth / 2.0));
        }
            break;
        case ButtonEdgeInsetsCenterBottom:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake((selfHeight - padding - titleY - titleHeight),
                                                    (selfWidth / 2.0 -  titleX - titleWidth / 2.0) - (selfWidth - titleWidth) / 2.0,
                                                    -(selfHeight - padding - titleY - titleHeight),
                                                    -(selfWidth / 2.0 -  titleX - titleWidth / 2.0) - (selfWidth - titleWidth) / 2.0);
            
            self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                    (selfWidth / 2.0 - imageX - imageWidth / 2.0),
                                                    0,
                                                    -(selfWidth / 2.0 - imageX - imageWidth / 2.0));
        }
            break;
        case ButtonEdgeInsetsCenterUp:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake(-(titleY + titleHeight - imageY + padding),
                                                    (selfWidth / 2.0 -  titleX - titleWidth / 2.0) - (selfWidth - titleWidth) / 2.0,
                                                    (titleY + titleHeight - imageY + padding),
                                                    -(selfWidth / 2.0 -  titleX - titleWidth / 2.0) - (selfWidth - titleWidth) / 2.0);
            
            self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                    (selfWidth / 2.0 - imageX - imageWidth / 2.0),
                                                    0,
                                                    -(selfWidth / 2.0 - imageX - imageWidth / 2.0));
        }
            break;
        case ButtonEdgeInsetsCenterDown:
        {
            self.titleEdgeInsets = UIEdgeInsetsMake((imageY + imageHeight - titleY + padding),
                                                    (selfWidth / 2.0 -  titleX - titleWidth / 2.0) - (selfWidth - titleWidth) / 2.0,
                                                    -(imageY + imageHeight - titleY + padding),
                                                    -(selfWidth / 2.0 -  titleX - titleWidth / 2.0) - (selfWidth - titleWidth) / 2.0);
            
            self.imageEdgeInsets = UIEdgeInsetsMake(0, (selfWidth / 2.0 - imageX - imageWidth / 2.0), 0, -(selfWidth / 2.0 - imageX - imageWidth / 2.0));
        }
            break;
        case ButtonEdgeInsetsRightLeft:
        {
            //图片在右，文字在左，距离按钮两边边距
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(titleX - padding), 0, (titleX - padding));
            self.imageEdgeInsets = UIEdgeInsetsMake(0, (selfWidth - padding - imageX - imageWidth), 0, -(selfWidth - padding - imageX - imageWidth));
        }
            break;
            
        case ButtonEdgeInsetsLeftRight:
        {
            //图片在左，文字在右，距离按钮两边边距
            self.titleEdgeInsets = UIEdgeInsetsMake(0, (selfWidth - padding - titleX - titleWidth), 0, -(selfWidth - padding - titleX - titleWidth));
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -(imageX - padding), 0, (imageX - padding));
        }
            break;
        default:
            break;
    }
}


@end
