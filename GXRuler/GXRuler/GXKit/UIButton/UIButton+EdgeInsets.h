//
//  UIButton+EdgeInsets.h
//  测试
//
//  Created by GX on 16/6/8.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 针对同时设置了Image和Title的场景时UIButton中的图片和文字的关系
 */
typedef NS_ENUM(NSInteger, ButtonEdgeInsets ) {
    ButtonEdgeInsetsDefault = 0,      //图片在左，文字在右，整体居中。
    ButtonEdgeInsetsLeft  = 0,        //图片在左，文字在右，整体居中。
    ButtonEdgeInsetsRight    = 2,    //图片在右，文字在左，整体居中。
    ButtonEdgeInsetsTop  = 3,          //图片在上，文字在下，整体居中。
    ButtonEdgeInsetsBottom    = 4,    //图片在下，文字在上，整体居中。
    ButtonEdgeInsetsCenterTop = 5,    //图片居中，文字在上距离按钮顶部。
    ButtonEdgeInsetsCenterBottom = 6,  //图片居中，文字在下距离按钮底部。
    ButtonEdgeInsetsCenterUp = 7,      //图片居中，文字在图片上面。
    ButtonEdgeInsetsCenterDown = 8,    //图片居中，文字在图片下面。
    ButtonEdgeInsetsRightLeft = 9,    //图片在右，文字在左，距离按钮两边边距
    ButtonEdgeInsetsLeftRight = 10,    //图片在左，文字在右，距离按钮两边边距
};

@interface UIButton (EdgeInsets)

/*
 调整按钮的文本和image的布局，前提是title和image同时存在才会调整。
 padding是调整布局时整个按钮和图文的间隔。
 */
-(void)setButtonEdgeInsets:(ButtonEdgeInsets)style padding:(CGFloat)padding;

@end
