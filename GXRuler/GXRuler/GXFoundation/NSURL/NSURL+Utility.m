//
//  NSURL+Utility.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "NSURL+Utility.h"

@implementation NSURL (Utility)

- (NSURL *)transferHttpToHttps
{
    if ([[self.absoluteString lowercaseString] hasPrefix:@"http://"]) {
        NSURL *url = [NSURL URLWithString:[self.absoluteString stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"https"]];
        return url;
    }
    return self;
}

- (NSURL *)imageURLWithPxSize:(CGSize)pxSize
{
    if (![self needBuildNewUrl]) {
        return self;
    }
    
    //如果域名后面跟着 /group1/ 和 /bfs/ 则缩略图规则是后面跟具体尺寸
    NSRange rangeGroup1 = [self.path rangeOfString:@"/group1/"];
    NSRange rangeBfs = [self.path rangeOfString:@"/bfs/"];
    if (rangeGroup1.location == NSNotFound && rangeBfs.location == NSNotFound) {
        return [self buildURLMode2WithSize:pxSize];
    }
    
    return [self buildURLMode1WithSize:pxSize];
}


/// 获取webp格式图片(仅处理/bfs/路径下图片; 非/bfs/下且size不为CGSizeZero将调用imageURLWithSize:) size为CGSizeZero时不剪裁
- (NSURL *)webpImageURLWithPxSize:(CGSize)pxSize
{
    NSURL *imgUrl = self;
    /// 为了容错, 有些傻屌会配图片url成这样"//xxx.com/xxxx.jpg"
    if (!imgUrl.scheme) {
        imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@", [imgUrl.absoluteString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]]]];
    }
    NSRange rangeDomain = [imgUrl.absoluteString rangeOfString:@"i[0-2].hdslb.com" options:NSRegularExpressionSearch];
    // 服务端gif暂不支持webp
    if (rangeDomain.location == NSNotFound || ![imgUrl.path hasPrefix:@"/bfs/"] || [imgUrl.pathExtension isEqualToString:@"gif"]) {
        if (pxSize.width > 0 && pxSize.height > 0) {
            return [imgUrl imageURLWithPxSize:pxSize];
        } else {
            return imgUrl;
        }
    }
    
    /// https://i0.hdslb.com/bfs/archive/15862966bf50542730d3131836e0d9a0dff3a7c6.jpg@150w_150h_1e_1c.webp
    /// 已经包含@100w_100h这样的剪裁URL
    NSRange rangeAt = [imgUrl.absoluteString rangeOfString:@"@[0-9]+w_[0-9]+h" options:NSRegularExpressionSearch];
    if (rangeAt.location != NSNotFound) {
        return imgUrl;
    }
    
    NSString *absoluteStr = imgUrl.absoluteString;
    /// https://i0.hdslb.com/bfs/archive/15862966bf50542730d3131836e0d9a0dff3a7c6.jpg_52x52.jpg
    /// 将url中的_52x52.jpg去掉
    NSString *regStr = [NSString stringWithFormat:@"_[0-9]+x[0-9]+\\.%@", imgUrl.pathExtension];
    NSRange range = [imgUrl.absoluteString rangeOfString:regStr options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        absoluteStr = [imgUrl.absoluteString stringByReplacingCharactersInRange:range withString:@""];
    }
    if (imgUrl.query) {
        NSRange range = [absoluteStr rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            absoluteStr = [absoluteStr substringToIndex:range.location];
        }
    }
    if (pxSize.width > 0 && pxSize.height > 0) {
        absoluteStr = [NSString stringWithFormat:@"%@@%ldw_%ldh_1e_1c.webp", absoluteStr, (long)pxSize.width, (long)pxSize.height];
    } else {
        range = [imgUrl.absoluteString rangeOfString:@"_[0-9]+x[0-9]+" options:NSRegularExpressionSearch];
        if (range.location != NSNotFound) {
            NSString *widthHeightStr = [imgUrl.absoluteString substringWithRange:range];
            widthHeightStr = [widthHeightStr stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"_"]];
            NSArray *widthHeightArr = [widthHeightStr componentsSeparatedByString:@"x"];
            absoluteStr = [NSString stringWithFormat:@"%@@%dw_%dh_1e_1c.webp", absoluteStr, [widthHeightArr.firstObject intValue], [widthHeightArr.lastObject intValue]];
        } else {
            absoluteStr = [NSString stringWithFormat:@"%@@.webp", absoluteStr];
        }
    }
    if (imgUrl.query) {
        absoluteStr = [[NSString alloc] initWithFormat:@"%@?%@", absoluteStr, imgUrl.query?:@""];
    }
    return [NSURL URLWithString:absoluteStr];
}

- (BOOL)needBuildNewUrl
{
    /*
     如果接口返回的url已经包含上述的缩略规则，不能再加如：
     
     https://i0.hdslb.com/group1/M00/B5/36/oYYBAFbmYVaAOcFGAARkrAIZ-zo705.jpg_52x52.jpg_52x52.jpg
     
     https://i0.hdslb.com/52_52/52_52/account/face/1662810/bc968edf/myface.png
     
     这样会导致图片缩略失败。可以替换掉缩略尺寸，或者直接使用接口中的缩略尺寸。
     */
    NSRange rangeDomain = [self.absoluteString rangeOfString:@"i[0-2].hdslb.com" options:NSRegularExpressionSearch];
    if (rangeDomain.location == NSNotFound) {
        return NO;
    }
    NSRange range = [self.absoluteString rangeOfString:@"_[0-9]+x[0-9]+\\." options:NSRegularExpressionSearch];
    NSRange range1 = [self.absoluteString rangeOfString:@"/[0-9]+_[0-9]+/" options:NSRegularExpressionSearch];
    
    if (range.location == NSNotFound && range1.location == NSNotFound) {
        return YES;
    }
    return NO;
}

- (NSURL *)buildURLMode1WithSize:(CGSize)size
{
    /*
     如果域名后面跟着 /group1/ 和 /bfs/ 则缩略图规则是后面跟具体尺寸
     
     https://i0.hdslb.com/group1/M00/B5/36/oYYBAFbmYVaAOcFGAARkrAIZ-zo705.jpg_52x52.jpg
     
     https://i0.hdslb.com/bfs/archive/15862966bf50542730d3131836e0d9a0dff3a7c6.jpg_52x52.jpg
     */
    if (self.query) {
        NSRange range = [self.absoluteString rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            NSString *urlBody = [self.absoluteString substringToIndex:range.location];
            urlBody = [urlBody stringByAppendingString:[[NSString alloc] initWithFormat:@"_%zdx%zd", (NSInteger)size.width, (NSInteger)size.height]];
            if (self.pathExtension.length > 0) {
                urlBody = [urlBody stringByAppendingFormat:@".%@",self.pathExtension];
            }
            NSString *url = [[NSString alloc] initWithFormat:@"%@?%@",urlBody, self.query];
            return [NSURL URLWithString:url];
        }
        else {
            return self;
        }
    }
    
    NSString *url = [self.absoluteString stringByAppendingString:[[NSString alloc] initWithFormat:@"_%zdx%zd", (NSInteger)size.width, (NSInteger)size.height]];
    if (self.pathExtension.length > 0) {
        url = [url stringByAppendingFormat:@".%@",self.pathExtension];
    }
    return [NSURL URLWithString:url];
}


- (NSURL *)buildURLMode2WithSize:(CGSize)size
{
    /*
     如果域名后面跟着 “其余”的path，如account, video等，则缩略图规则是在域名和路径之间加尺寸
     https://i0.hdslb.com/52_52/account/face/1662810/bc968edf/myface.png
     */
    NSRange range = [self.absoluteString rangeOfString:self.path];
    if (range.location != NSNotFound) {
        NSString *str = [self.absoluteString substringToIndex:range.location];
        NSString *str2 = [self.absoluteString substringFromIndex:range.location];
        str = [str stringByAppendingFormat:@"/%zd_%zd%@", (NSInteger)size.width, (NSInteger)size.height, str2];
        return [NSURL URLWithString:str];
    }
    return self;
}

@end
