//
//  GXBaseViewController.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXBaseViewController.h"

@interface GXBaseViewController () {
    BOOL _firstWillAppeared;
    BOOL _firstDidAppeared;
}

@end

@implementation GXBaseViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_firstWillAppeared) {
        [self gx_viewfirstWillAppear];
        _firstWillAppeared = YES;
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_firstDidAppeared) {
        [self gx_viewfirstDidAppear];
        _firstDidAppeared = YES;
    }
    if ([self gx_shouldRegisterKeyboardEvent]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gx_hideKeyboardHandler:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gx_showKeyboardHandler:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gx_showKeyboardHandler:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self gx_shouldRegisterKeyboardEvent]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }
}

- (void)gx_viewfirstWillAppear
{
    
}

- (void)gx_viewfirstDidAppear
{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Keyboard

- (BOOL)gx_shouldRegisterKeyboardEvent
{
    // override me if you want to receive keyborad height changed event
    return NO;
}

- (void)gx_showKeyboardHandler:(NSNotification *)notification
{
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self gx_keyboardHeightChanged:MIN(CGRectGetHeight(keyboardFrame), CGRectGetWidth(keyboardFrame))];
}

- (void)gx_hideKeyboardHandler:(NSNotification *)notification
{
    [self gx_keyboardHeightChanged:0];
}

- (void)gx_keyboardHeightChanged:(CGFloat)newHeight
{
    // override me to handle keyboard height changed event
}

#pragma mark - 控制屏幕旋转

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#ifdef DEBUG
- (void)dealloc {
    NSLog(@"%@ released", [[self class] description]);
}
#endif

@end
