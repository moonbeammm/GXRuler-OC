//
//  GXRouter.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXRouter : NSObject

+ (instancetype)shared;

+ (UINavigationController *)navigationController;
+ (void)setNavigationController:(UINavigationController *)nav;


+ (BOOL)pushUrl:(NSString *)url animated:(BOOL)animated;
+ (BOOL)presentUrl:(NSString *)url animated:(BOOL)animated;
+ (BOOL)processUnknowUrl:(NSString *)url animated:(BOOL)animated;


- (void)map:(NSString *)route toControllerClass:(Class)controllerClass;
- (void)map:(NSString *)route toBlock:(id (^)(NSDictionary *))blockName;

- (UIViewController *)matchController:(NSString *)route;
- (id (^)(NSDictionary *))matchBlock:(NSString *)route;
- (id)callBlock:(NSString *)route;


- (NSDictionary *)paramsInRoute:(NSString *)route;

@end

