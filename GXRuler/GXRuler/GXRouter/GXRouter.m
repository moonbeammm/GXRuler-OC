//
//  GXRouter.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXRouter.h"
#import "HHRouter.h"
#import "NSString+RouterUrl.h"
#import "NSString+Encode.h"

@implementation GXRouter

static UINavigationController *_controller;

+ (void)setNavigationController:(UINavigationController *)nav
{
    @synchronized ([GXRouter class]) {
        _controller = nav;
    }
}

+ (UINavigationController *)navigationController
{
    UINavigationController *c = nil;
    @synchronized ([GXRouter class]) {
        c = _controller;
    }
    return c;
}



+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    static GXRouter *r;
    dispatch_once(&onceToken, ^{
        r = [GXRouter new];
    });
    return r;
}








- (void)map:(NSString *)route toControllerClass:(Class)controllerClass
{
    [[HHRouter shared] map:route toControllerClass:controllerClass];
}

- (void)map:(NSString *)route toBlock:(id (^)(NSDictionary *))blockName
{
    [[HHRouter shared] map:route toBlock:blockName];
}

- (id)callBlock:(NSString *)route
{
    return [[HHRouter shared] callBlock:route];
}

- (UIViewController *)matchController:(NSString *)route
{
    return [[HHRouter shared] matchController:route];
}

- (id (^)(NSDictionary *))matchBlock:(NSString *)route
{
    return [[HHRouter shared] matchBlock:route];
}

- (NSDictionary *)paramsInRoute:(NSString *)route
{
    return [[HHRouter shared] paramsInRoute:route];
}










+ (BOOL)pushUrl:(NSString *)url animated:(BOOL)animated
{
    UIViewController *vc = [[HHRouter shared] matchController:url];
    if (!vc) {
        return NO;
    }
    if (vc.params[@"animation"]) {
        animated = [vc.params[@"animation"] boolValue];
    }
    [[GXRouter navigationController] pushViewController:vc animated:animated];
    return YES;
}

+ (BOOL)presentUrl:(NSString *)url animated:(BOOL)animated
{
    UIViewController *vc = [[HHRouter shared] matchController:url];
    if (!vc) {
        return NO;
    }
    if (vc.params[@"animation"]) {
        animated = [vc.params[@"animation"] boolValue];
    }
    [[GXRouter navigationController] presentViewController:vc animated:animated completion:nil];
    return YES;
}

+ (BOOL)processUnknowUrl:(NSString *)url animated:(BOOL)animated
{
    if ([[HHRouter shared] callBlock:url]) {
        return YES;
    };
    
    if ([url isWebUrl]) {
        if ([url isDirectOpenUrl]) {
            // 删除appstore链接后的多余参数
            NSString *clearUrl = url;
            NSInteger paramLoc = NSNotFound;
            if ((paramLoc = [clearUrl rangeOfString:@"&"].location) != NSNotFound) {
                clearUrl = [clearUrl substringToIndex:paramLoc];
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:clearUrl] options:@{} completionHandler:nil];
            return YES;
        }
        [self pushUrl:[NSString stringWithFormat:@"/browser/?url=%@", [url stringByUriEncode]] animated:animated];
        return YES;
    }
    
    NSString *tryAppScheme = [url tryTransferToAppScheme];
    if ([GXRouter pushUrl:tryAppScheme animated:animated]) {
        return YES;
    }
    
    return NO;
}


@end
