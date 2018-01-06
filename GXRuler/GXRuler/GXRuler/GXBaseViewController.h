//
//  GXBaseViewController.h
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXBaseViewModel.h"

@interface GXBaseViewController : UIViewController

@property (nonatomic, strong) NSDictionary *params;

@property (nonatomic, strong) GXBaseViewModel *viewModel;

- (void)gx_viewfirstWillAppear;
- (void)gx_viewfirstDidAppear;

- (BOOL)gx_shouldRegisterKeyboardEvent;
- (void)gx_keyboardHeightChanged:(CGFloat)newHeight;

@end
