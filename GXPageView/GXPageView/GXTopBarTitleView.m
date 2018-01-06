//
//  GXTopBarTitleView.m
//  GXPageView
//
//  Created by sunguangxin on 2017/9/5.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXTopBarTitleView.h"
#import "GXContainerTopBarStyle.h"

@interface GXTopBarTitleView ()

@property (nonatomic, strong) GXContainerTopBarStyle *topBarStyle;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GXTopBarTitleView

- (instancetype)initWithTopBarStyle:(GXContainerTopBarStyle *)topBarStyle title:(NSString *)title
{
    if (self = [super init]) {
        self.topBarStyle = topBarStyle;
        self.titleLabel.text = title;
        [self configSubviews];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    switch (self.topBarStyle.titleContentType) {
        case GXTopBarTitleContentTypeOnlyText:
            
            break;
        case GXTopBarTitleContentTypeOnlyImage:
            
            break;
        case GXTopBarTitleContentTypeImageLeft:
            
            break;
        case GXTopBarTitleContentTypeImageTop:
            
            break;
            
        case GXTopBarTitleContentTypeImageRight:
            
            break;
        default:
            break;
    }
}

#pragma mark - Public Method

- (void)setTitleColor:(UIColor *)titleColor
{
    self.titleLabel.textColor = titleColor;
}

- (void)updateTitleViewContentFrame
{
    self.titleLabel.frame = self.bounds;
}

- (NSInteger)getWidth
{
    NSInteger titleViewWidth = 0;
    NSInteger titleWidth = [self titleWidth:self.titleLabel.text];
    switch (self.topBarStyle.titleContentType) {
        case GXTopBarTitleContentTypeOnlyText:
            titleViewWidth = titleWidth + 10;
            break;
        case GXTopBarTitleContentTypeOnlyImage:

            break;
        case GXTopBarTitleContentTypeImageTop:
            
            break;
        case GXTopBarTitleContentTypeImageLeft:
        case GXTopBarTitleContentTypeImageRight:
            
            break;
        default:
            break;
    }
    return titleViewWidth;
}

// 缩放动画
- (void)setTransformX:(CGFloat)x 
{
    self.titleLabel.transform = CGAffineTransformMakeScale(x, x);
}

#pragma mark - Private Method

- (CGFloat)titleWidth:(NSString *)title {
    CGFloat sys_font = self.topBarStyle.animaScale > 1 ? self.topBarStyle.titleFontSize * self.topBarStyle.animaScale : self.topBarStyle.titleFontSize;
    return [title boundingRectWithSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.frame)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:sys_font]} context:nil].size.width;
}

#pragma mark - Event Response

#pragma mark - Initialize Method

- (void)configSubviews
{
    [self addSubview:self.titleLabel];
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:self.topBarStyle.titleFontSize];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (void)dealloc 
{
    NSLog(@"%@销毁",NSStringFromClass([self class]));
}

@end
