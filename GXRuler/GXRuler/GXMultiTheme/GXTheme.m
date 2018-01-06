////
////  GXTheme.m
////  GXRuler
////
////  Created by sunguangxin on 2017/8/14.
////  Copyright © 2017年 sunguangxin. All rights reserved.
////
//
//#import "GXTheme.h"
//
//#import <ReactiveCocoa/ReactiveCocoa.h>
//#import "GXPreferences.h"
//
//@protocol GXThemeWeakWrapperProtocol <NSObject>
//
//- (void)willBeRemoved:(id)x;
//
//@end
//
//@interface GXThemeConfig : GXPreferences
//
//@property (nonatomic) NSUInteger multiThemeType;
//
//@end
//
//@implementation GXThemeConfig
//
//+ (instancetype)sharedConfig
//{
//    static dispatch_once_t onceToken;
//    static GXThemeConfig *sharedInstance = nil;
//    dispatch_once(&onceToken, ^{ sharedInstance = [[self alloc] init]; });
//    return sharedInstance;
//}
//
//- (NSString * __nullable)configName
//{
//    return @"GXThemeName";
//}
//
//- (NSDictionary * __nullable)defaultConfig
//{
//    return @{
//             @"multiThemeType":@(0)
//             };
//}
//
//@end
//
//
//@interface GXThemeSubject : RACSubject
//
//// 0 no param
//// 1 color param
//// 2 tuple color state
//@property (nonatomic) int32_t type;
//@property (nonatomic) NSString *observeredColor;
//@property (nonatomic) NSUInteger param1;
//
//@end
//
//@implementation GXThemeSubject
//
//+ (instancetype)subjectWithType:(int32_t)type color:(NSString *)colorKeyPath {
//    GXThemeSubject *subject = [[self alloc] init];
//    subject.type = type;
//    subject.observeredColor = colorKeyPath;
//    return subject;
//}
//
//@end
//
//@interface GXThemeWeakWrapper : NSObject {
//@public
//    __weak id _obj;
//@private
//    RACDisposable *_disposable;
//}
//
//- (instancetype) initWithWeakObject:(NSObject *)obj targetSelector:(SEL)sel signal:(GXThemeSubject *)signal;
//
//@property (nonatomic, weak) id <GXThemeWeakWrapperProtocol> delegate;
//
//@end
//
//@implementation GXThemeWeakWrapper
//
//- (instancetype) initWithWeakObject:(NSObject *)obj targetSelector:(SEL)sel signal:(GXThemeSubject *)signal
//{
//    if (self = [super init]) {
//        _obj = obj;
//        @weakify(self);
//        switch (signal.type) {
//            case 0: {
//                self->_disposable = [[signal takeUntil:[_obj rac_willDeallocSignal]] subscribeNext:^(id x) {
//                    @strongify(self);
//                    if (!self) {
//                        return ;
//                    }
//                    NSAssert([self->_obj respondsToSelector:sel], @"object has an enknow selector");
//                    ((void (*)(id, SEL))[self->_obj methodForSelector:sel])(self->_obj, sel);
//                } completed:^{
//                    @strongify(self);
//                    [self.delegate willBeRemoved:self];
//                }];
//            }
//                break;
//            case 1: {
//                self->_disposable = [[signal takeUntil:[_obj rac_willDeallocSignal]] subscribeNext:^(UIColor *c) {
//                    @strongify(self);
//                    if (!self) {
//                        return ;
//                    }
//                    NSAssert([c isKindOfClass:[UIColor class]], @"multitheme signal has to be UIColor");
//                    NSAssert([_obj respondsToSelector:sel], @"object has an enknow selector");
//                    ((void (*)(id, SEL, UIColor *))[self->_obj methodForSelector:sel])(self->_obj, sel, c);
//                } completed:^{
//                    @strongify(self);
//                    [self.delegate willBeRemoved:self];
//                }];
//            }
//                break;
//            case 2: {
//                self->_disposable = [[signal takeUntil:[_obj rac_willDeallocSignal]] subscribeNext:^(RACTuple *tuple) {
//                    @strongify(self);
//                    if (!self) {
//                        return ;
//                    }
//                    NSAssert(tuple.count == 2, @"multitheme signal has to be UIColor");
//                    NSAssert([self->_obj respondsToSelector:sel], @"object has an enknow selector");
//                    ((void (*)(id, SEL, UIColor *, NSUInteger state))[self->_obj methodForSelector:sel])(self->_obj, sel, tuple.first, [tuple.second unsignedIntegerValue]);
//                } completed:^{
//                    @strongify(self);
//                    [self.delegate willBeRemoved:self];
//                }];
//            }
//                break;
//            default:
//                break;
//        }
//        
//    }
//    return self;
//}
//
//- (void)dealloc
//{
//    self->_disposable = nil;
//}
//
//@end
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///// 具体的主体颜色类型
//
//@interface GXThemeColor : NSObject
//
//@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
//@property (nonatomic, assign) UIKeyboardAppearance keyboardStyle;
//@property (nonatomic, copy) NSString *themeName;
//
//@end
//
//@implementation GXThemeColor
//
//@end
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//@interface GXTheme () <GXThemeWeakWrapperProtocol> {
//    NSMutableDictionary *_signalTable;
//    NSMutableSet *_targetSet;
//    NSDictionary *_setterMap;
//    NSMutableDictionary<NSNumber*, GXThemeColor*> *_allThemeArray;
//}
//
//@end
//
//@implementation GXTheme
//
//+ (instancetype)sharedTheme
//{
//    static dispatch_once_t once;
//    static GXTheme *theme = nil;
//    dispatch_once(&once, ^{
//        theme = [GXTheme new];
//    });
//    return theme;
//}
//
//- (instancetype)init
//{
//    if (self = [super init]) {
//        _statusBarStyle = UIStatusBarStyleLightContent;
//        _setterMap = @{};
//        
//        _signalTable = [NSMutableDictionary dictionaryWithCapacity:10];
//        _targetSet = [NSMutableSet setWithCapacity:100];
//        [self initAllTheme];
//        [self resetColorWithType:[GXThemeConfig sharedConfig].multiThemeType];
//    }
//    return self;
//}
//
//- (void)resetColorWithType:(GXThemeType)type
//{
//    if (type >= GXThemeTypeCountMAX) {
//        type = GXThemeSyoujyoPinkType;
//    }
//    
//    _currentThemeType = type;
//    
//    GXThemeColor *theme = nil;
//    if (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)) {
//        theme = _allThemeArray[@(GXThemeSyoujyoPinkType)];
//    }
//    else {
//        theme = _allThemeArray[@(type)];
//    }
//    
//    NSAssert(theme, @"Target theme %zd is invalid.", type);
//    if (theme) {
//        [self setThemeWithThemeColor:theme];
//    }
//    
//    return;
//}
//
//- (void)initAllTheme {
//    if (!_allThemeArray) {
//        _allThemeArray = [[NSMutableDictionary alloc] init];
//        
//        GXThemeColor *theme = nil;
//        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//            theme = [[GXThemeColor alloc] init];
//            [theme setThemeName: @"樱花粉"];
//            [theme setStatusBarStyle:UIStatusBarStyleDefault];
//            [theme setKeyboardStyle:UIKeyboardAppearanceDefault];
//            _allThemeArray[@(GXThemeSyoujyoPinkType)] = theme;
//        }
//        else {
//            theme = [[GXThemeColor alloc] init];
//            [theme setThemeName:@"樱花粉"];
//            theme.statusBarStyle = UIStatusBarStyleLightContent;
//            [theme setKeyboardStyle:UIKeyboardAppearanceDefault];
//            _allThemeArray[@(GXThemeSyoujyoPinkType)] = theme;
//            
//            // ------------------------------------
//            
//            theme = [[GXThemeColor alloc] init];
//            [theme setThemeName:@"简洁白"];
//            theme.statusBarStyle = UIStatusBarStyleDefault;
//            [theme setKeyboardStyle:UIKeyboardAppearanceDefault];
//            _allThemeArray[@(GXThemeShiroWhiteType)] = theme;
//            
//            // ------------------------------------
//            
//            theme = [[GXThemeColor alloc] init];
//            [theme setThemeName:@"夜间模式"];
//            theme.statusBarStyle = UIStatusBarStyleLightContent;
//            [theme setKeyboardStyle:UIKeyboardAppearanceDark];
//            _allThemeArray[@(GXThemeNightmareType)] = theme;
//        }
//    }
//    return;
//}
//
//- (void)setThemeWithThemeColor: (GXThemeColor*)aTheme {
//    if (aTheme) {
//        _statusBarStyle = aTheme.statusBarStyle;
//        _keyboardStyle = aTheme.keyboardStyle;
//    }
//    return;
//}
//
//- (NSString*)themeNameWithType: (GXThemeType)themeType
//{
//    if (themeType >= GXThemeTypeCountMAX) {
//        return @"未知主题";
//    }
//    return [self themeWithType:themeType].themeName;
//}
//
//- (GXThemeColor *)themeWithType:(GXThemeType)themeType {
//    if (themeType >= GXThemeTypeCountMAX) {
//        return nil;
//    }
//    return _allThemeArray[@(themeType)];
//}
//
//- (void)syncWithType:(GXThemeType)type
//{
//    [self resetColorWithType:type];
//    [GXThemeConfig sharedConfig].multiThemeType = type;
//    for (GXThemeSubject *subject in _signalTable.allValues) {
//        NSString *colorKeyPath = subject.observeredColor;
//        NSString *setterKeyPath = _setterMap[colorKeyPath];
//        if (colorKeyPath && setterKeyPath) {
//            SEL privateSelector = NSSelectorFromString(colorKeyPath);
//            UIColor *rc = ((UIColor* (*)(id, SEL))[self methodForSelector:privateSelector])(self, privateSelector);
//            SEL setterSelector = NSSelectorFromString(setterKeyPath);
//            ((void (*)(id, SEL, UIColor *))[self methodForSelector:setterSelector])(self, setterSelector, rc);
//            switch (subject.type) {
//                case 1: {
//                    [subject sendNext:rc];
//                }
//                    break;
//                case 2: {
//                    [subject sendNext:RACTuplePack(rc, @(subject.param1))];
//                }
//                    break;
//                default:
//                    break;
//            }
//        }
//    }
//    RACSubject *s = _signalTable[@"any"];
//    [s sendNext:nil];
//}
//
//- (void)_observerTarget:(id)target targetColorSelector:(SEL)sel obsColorSelector:(NSString *)selectorName
//{
//    if (!selectorName) {
//        NSLog(@"theme.error unknow selectorname");
//        return;
//    }
//    
//    SEL colorSel = NSSelectorFromString(selectorName);
//    NSAssert([self respondsToSelector:colorSel], @"object has an enknow selector");
//    UIColor *c = ((UIColor* (*)(id, SEL))[self methodForSelector:colorSel])(self, colorSel);
//    NSAssert([c isKindOfClass:[UIColor class]], @"unknow selectorName");
//    
//    NSString *key = [NSString stringWithFormat:@"%@-%d", selectorName, 1];
//    GXThemeSubject *s = _signalTable[key];
//    if (!s) {
//        s = [GXThemeSubject subjectWithType:1 color:selectorName];
//        _signalTable[key] = s;
//    }
//    
//    GXThemeWeakWrapper *wrapper = [[GXThemeWeakWrapper alloc] initWithWeakObject:target targetSelector:sel signal:s];
//    wrapper.delegate = self;
//    [[((NSArray* (*)(id, SEL))[s methodForSelector:NSSelectorFromString(@"subscribers")])(s, NSSelectorFromString(@"subscribers")) lastObject] sendNext:c];
//    [_targetSet addObject:wrapper];
//}
//
//- (void)observerBackgroundColorTarget:(id)target obsColorSelector:(NSString *)selectorName
//{
//    [self _observerTarget:target targetColorSelector:@selector(setBackgroundColor:) obsColorSelector:selectorName];
//}
//
//- (void)observerTextColorTarget:(UILabel *)target obsColorSelector:(NSString *)selectorName
//{
//    [self _observerTarget:target targetColorSelector:@selector(setTextColor:) obsColorSelector:selectorName];
//}
//
//- (void)observerButtonTitleColor:(UIButton *)target obsColorSelector:(NSString *)selectorName state:(UIControlState)state
//{
//    if (!selectorName) {
//        NSLog(@"theme.error unknow selectorname");
//        return;
//    }
//    
//    SEL colorSel = NSSelectorFromString(selectorName);
//    NSAssert([self respondsToSelector:colorSel], @"object has an enknow selector");
//    UIColor *c = ((UIColor* (*)(id, SEL))[self methodForSelector:colorSel])(self, colorSel);
//    NSAssert([c isKindOfClass:[UIColor class]], @"unknow selectorName");
//    
//    NSString *key = [NSString stringWithFormat:@"%@-%zd-%d", selectorName, state, 2];
//    GXThemeSubject *s = _signalTable[key];
//    if (!s) {
//        s = [GXThemeSubject subjectWithType:2 color:selectorName];
//        s.param1 = state;
//        _signalTable[key] = s;
//    }
//    
//    GXThemeWeakWrapper *wrapper = [[GXThemeWeakWrapper alloc] initWithWeakObject:target targetSelector:@selector(setTitleColor:forState:) signal:s];
//    wrapper.delegate = self;
//    [[((NSArray* (*)(id, SEL))[s methodForSelector:NSSelectorFromString(@"subscribers")])(s, NSSelectorFromString(@"subscribers")) lastObject] sendNext:RACTuplePack(c, @(state))];
//    
//    [_targetSet addObject:wrapper];
//}
//
//- (void)observerTarget:(id <GXThemeDelegate>)target
//{
//    GXThemeSubject *s = _signalTable[@"any"];
//    if (!s) {
//        s = [GXThemeSubject subjectWithType:0 color:nil];
//        _signalTable[@"any"] = s;
//    }
//    
//    GXThemeWeakWrapper *wrapper = [[GXThemeWeakWrapper alloc] initWithWeakObject:target targetSelector:@selector(themeTriggered) signal:s];
//    wrapper.delegate = self;
//    [[((NSArray* (*)(id, SEL))[s methodForSelector:NSSelectorFromString(@"subscribers")])(s, NSSelectorFromString(@"subscribers")) lastObject] sendNext:nil];
//    
//    [_targetSet addObject:wrapper];
//}
//
//- (void)unregisterTarget:(id)target
//{
//    NSMutableArray *needRemove = [NSMutableArray arrayWithCapacity:2];
//    for (GXThemeWeakWrapper *wrapper in _targetSet) {
//        if (wrapper->_obj == target) {
//            [needRemove addObject:wrapper];
//        }
//    }
//    for (id x in needRemove) {
//        [_targetSet removeObject:x];
//    }
//}
//
//- (void)willBeRemoved:(id)x
//{
//    [_targetSet removeObject:x];
//}
//
//@end
//
