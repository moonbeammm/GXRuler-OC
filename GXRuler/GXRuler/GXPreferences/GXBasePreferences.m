//
//  GXBasePreferences.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXBasePreferences.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <libkern/OSAtomic.h>

@interface GXBasePreferences () {
    NSMutableDictionary *_propertyMapping;
    NSMutableDictionary *_configMapping;
    NSUserDefaults *_userDefaults;
    NSRecursiveLock *_lock;
    volatile uint32_t _needSync;
}

- (long long)getLonglongByKey:(NSString *)key;
- (void)setLonglongWithKey:(NSString *)key value:(long long)value;

- (BOOL)getBoolByKey:(NSString *)key;
- (void)setBoolWithKey:(NSString *)key value:(BOOL)value;

- (int)getIntByKey:(NSString *)key;
- (void)setIntWithKey:(NSString *)key value:(int)value;

- (float)getFloatByKey:(NSString *)key;
- (void)setFloatWithKey:(NSString *)key value:(float)value;

- (double)getDoubleByKey:(NSString *)key;
- (void)setDoubleWithKey:(NSString *)key value:(double)value;

- (id)getObjectByKey:(NSString *)key;
- (void)setObjectWithKey:(NSString *)key value:(id)value;

@end

@implementation GXBasePreferences


- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:[self configName]];
    }
    return _userDefaults;
}

- (void)sync
{
    [[self userDefaults] synchronize];
}

- (NSString * __nullable)configName
{
    return nil;
}

- (NSDictionary * __nullable)defaultConfig
{
    return nil;
}

- (void)_setObjectWithKey:(NSString *)key value:(id)value
{
    id ori = _configMapping[key];
    if (ori == value) {
        return;
    }
    [_lock lock];
    [[self userDefaults] setObject:value forKey:key];
    
    if (value) {
        [_configMapping setObject:value forKey:key];
    } else {
        [_configMapping removeObjectForKey:key];
    }
    [_lock unlock];
    
    OSAtomicOr32Barrier(1, & _needSync);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (_needSync) {
            OSAtomicAnd32Barrier(0, & _needSync);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[self userDefaults] synchronize];
            });
        }
    });
}
- (id)_getObjectWithkey:(NSString *)key
{
    id x = nil;
    [_lock lock];
    x = [_configMapping objectForKey:key];
    if (!x) {
        x = [self defaultConfig][key];
    }
    [_lock unlock];
    return x;
}

- (long long)getLonglongByKey:(NSString *)key
{
    return [[self _getObjectWithkey:key] longLongValue];
}

- (void)setLonglongWithKey:(NSString *)key value:(long long)value
{
    long long ori = [self getLonglongByKey:key];
    if (ori == value) {
        return;
    }
    [self _setObjectWithKey:key value:@(value)];
}


- (BOOL)getBoolByKey:(NSString *)key
{
    return [[self _getObjectWithkey:key] boolValue];
}

- (void)setBoolWithKey:(NSString *)key value:(BOOL)value
{
    BOOL ori = [self getBoolByKey:key];
    if (ori == value) {
        return;
    }
    [self _setObjectWithKey:key value:@(value)];
}

- (int)getIntByKey:(NSString *)key
{
    return [[self _getObjectWithkey:key] intValue];
}

- (void)setIntWithKey:(NSString *)key value:(int)value
{
    BOOL ori = [self getIntByKey:key];
    if (ori == value) {
        return;
    }
    [self _setObjectWithKey:key value:@(value)];
}

- (float)getFloatByKey:(NSString *)key
{
    return [[self _getObjectWithkey:key] floatValue];
}

- (void)setFloatWithKey:(NSString *)key value:(float)value
{
    float ori = [self getFloatByKey:key];
    if (ori == value) {
        return;
    }
    [self _setObjectWithKey:key value:@(value)];
}

- (double)getDoubleByKey:(NSString *)key
{
    return [[self _getObjectWithkey:key] doubleValue];
}

- (void)setDoubleWithKey:(NSString *)key value:(double)value
{
    double ori = [self getDoubleByKey:key];
    if (ori == value) {
        return;
    }
    [self _setObjectWithKey:key value:@(value)];
}

- (id)getObjectByKey:(NSString *)key
{
    return [self _getObjectWithkey:key];
}

- (void)setObjectWithKey:(NSString *)key value:(id)value
{
    id ori = [self getObjectByKey:key];
    if (ori == value) {
        return;
    }
    [self _setObjectWithKey:key value:value];
}

- (NSString *)_defaultsKeyForPropertyNamed:(char const *)propertyName {
    NSString *key = [NSString stringWithFormat:@"%s", propertyName];
    return key;
}

- (NSString *)_defaultsKeyForSelector:(SEL)selector {
    return [_propertyMapping objectForKey:NSStringFromSelector(selector)];
}

+ (instancetype)shared
{
    NSAssert(NO, @"sub config has to implement");
    return nil;
}

static long long _longLongGetter(GXBasePreferences *self, SEL _cmd) {
    NSString *key = [self _defaultsKeyForSelector:_cmd];
    return [self getLonglongByKey:key];
}

static void _longLongSetter(GXBasePreferences *self, SEL _cmd, long long value) {
    NSString *key = [self _defaultsKeyForSelector:_cmd];
    [self setLonglongWithKey:key value:value];
}

static bool _boolGetter(GXBasePreferences *self, SEL _cmd) {
    NSString *key = [self _defaultsKeyForSelector:_cmd];
    return [self getBoolByKey:key];
}

static void _boolSetter(GXBasePreferences *self, SEL _cmd, bool value) {
    NSString *key = [self _defaultsKeyForSelector:_cmd];
    [self setBoolWithKey:key value:value];
}

static int _integerGetter(GXBasePreferences *self, SEL _cmd) {
    NSString *key = [self _defaultsKeyForSelector:_cmd];
    return [self getIntByKey:key];
}

static void _integerSetter(GXBasePreferences *self, SEL _cmd, int value) {
    NSString *key = [self _defaultsKeyForSelector:_cmd];
    [self setIntWithKey:key value:value];
}

static float _floatGetter(GXBasePreferences *self, SEL _cmd) {
    NSString *key = [self _defaultsKeyForSelector:_cmd];
    return [self getFloatByKey:key];
}

static void _floatSetter(GXBasePreferences *self, SEL _cmd, float value) {
    NSString *key = [self _defaultsKeyForSelector:_cmd];
    [self setFloatWithKey:key value:value];
}

static double _doubleGetter(GXBasePreferences *self, SEL _cmd) {
    NSString *key = [self _defaultsKeyForSelector:_cmd];
    return [self getDoubleByKey:key];
}

static void _doubleSetter(GXBasePreferences *self, SEL _cmd, double value) {
    NSString *key = [self _defaultsKeyForSelector:_cmd];
    [self setDoubleWithKey:key value:value];
}

static id _objectGetter(GXBasePreferences *self, SEL _cmd) {
    NSString *key = [self _defaultsKeyForSelector:_cmd];
    return [self getObjectByKey:key];
}

static void _objectSetter(GXBasePreferences *self, SEL _cmd, id object) {
    NSString *key = [self _defaultsKeyForSelector:_cmd];
    [self setObjectWithKey:key value:object];
}

- (instancetype)init
{
    if (self = [super init]) {
        _lock = [NSRecursiveLock new];
        [[self userDefaults] registerDefaults:[self defaultConfig]?:@{}];
        unsigned int count = 0;
        _configMapping = [NSMutableDictionary dictionaryWithCapacity:count];
        _propertyMapping = [NSMutableDictionary dictionaryWithCapacity:0];
        Class currentMappingClass = [self class];
        
        do {
            count = 0;
            objc_property_t *properties = class_copyPropertyList(currentMappingClass, &count);
            NSMutableDictionary *propertyMapping = [NSMutableDictionary dictionaryWithCapacity:count];
            for (int i = 0; i < count; i++) {
                objc_property_t property = properties[i];
                const char *name = property_getName(property);
                const char *attributes = property_getAttributes(property);
                char *getter = strstr(attributes, ",G");
                if (getter) {
                    getter = strdup(getter + 2);
                    getter = strsep(&getter, ",");
                } else {
                    getter = strdup(name);
                }
                SEL getterSel = sel_registerName(getter);
                free(getter);
                char *setter = strstr(attributes, ",S");
                if (setter) {
                    setter = strdup(setter + 2);
                    setter = strsep(&setter, ",");
                } else {
                    asprintf(&setter, "set%c%s:", toupper(name[0]), name + 1);
                }
                SEL setterSel = sel_registerName(setter);
                free(setter);
                NSString *key = [self _defaultsKeyForPropertyNamed:name];
                id defaultObj = [[self userDefaults] objectForKey:key];
                [propertyMapping setValue:key forKey:NSStringFromSelector(getterSel)];
                [propertyMapping setValue:key forKey:NSStringFromSelector(setterSel)];
                IMP getterImp = NULL;
                IMP setterImp = NULL;
                char type = attributes[1];
                switch (type) {
                    case 's':
                    case 'l':
                    case 'q':
                    case 'C':
                    case 'S':
                    case 'I':
                    case 'L':
                    case 'Q':
                    {
                        getterImp = (IMP)_longLongGetter;
                        setterImp = (IMP)_longLongSetter;
                        break;
                    }
                    case 'B':
                    case 'c':
                    {
                        getterImp = (IMP)_boolGetter;
                        setterImp = (IMP)_boolSetter;
                        break;
                    }
                    case 'i':
                    {
                        getterImp = (IMP)_integerGetter;
                        setterImp = (IMP)_integerSetter;
                        break;
                    }
                    case 'f':
                    {
                        getterImp = (IMP)_floatGetter;
                        setterImp = (IMP)_floatSetter;
                        break;
                    }
                    case 'd':
                    {
                        getterImp = (IMP)_doubleGetter;
                        setterImp = (IMP)_doubleSetter;
                        break;
                    }
                    case '@':
                    {
                        getterImp = (IMP)_objectGetter;
                        setterImp = (IMP)_objectSetter;
                        break;
                    }
                    default:
                        free(properties);
                        [NSException raise:NSInternalInconsistencyException format:@"Unsupported type of property \"%s\" in class %@", name, self];
                        break;
                }
                [_propertyMapping addEntriesFromDictionary:propertyMapping];
                char types[5];
                
                snprintf(types, 4, "%c@:", type);
                
                Method oriMethod = class_getInstanceMethod([self class], getterSel);
                if (!class_addMethod([self class], getterSel, getterImp, types)) {
                    method_setImplementation(oriMethod, getterImp);
                }
                
                snprintf(types, 5, "v@:%c", type);
                oriMethod = class_getInstanceMethod([self class], setterSel);
                if (!class_addMethod([self class], setterSel, setterImp, types)) {
                    method_setImplementation(oriMethod, setterImp);
                }
                
                switch (type) {
                    case 's':
                    case 'l':
                    case 'q':
                    case 'C':
                    case 'S':
                    case 'I':
                    case 'L':
                    case 'Q':
                    {
                        long long x = [defaultObj longLongValue];
                        _longLongSetter(self, setterSel, x);
                        break;
                    }
                    case 'B':
                    case 'c':
                    {
//                        getterImp = (IMP)_boolGetter;
//                        setterImp = (IMP)_boolSetter;
                        BOOL x = [defaultObj boolValue];
                        _boolSetter(self, setterSel, x);
                        break;
                    }
                    case 'i':
                    {
//                        getterImp = (IMP)_integerGetter;
//                        setterImp = (IMP)_integerSetter;
                        int x = [defaultObj intValue];
                        _integerSetter(self, setterSel, x);
                        break;
                    }
                    case 'f':
                    {
//                        getterImp = (IMP)_floatGetter;
//                        setterImp = (IMP)_floatSetter;
                        float x = [defaultObj floatValue];
                        _floatSetter(self, setterSel, x);
                        break;
                    }
                    case 'd':
                    {
//                        getterImp = (IMP)_doubleGetter;
//                        setterImp = (IMP)_doubleSetter;
                        double x = [defaultObj doubleValue];
                        _doubleSetter(self, setterSel, x);
                        break;
                    }
                    case '@':
                    {
//                        getterImp = (IMP)_objectGetter;
//                        setterImp = (IMP)_objectSetter;
                        _objectSetter(self, setterSel, defaultObj);
                        break;
                    }
                    default:
                        free(properties);
                        [NSException raise:NSInternalInconsistencyException format:@"Unsupported type of property \"%s\" in class %@", name, self];
                        break;
                }
            }
            free(properties);
            currentMappingClass = class_getSuperclass(currentMappingClass);
        } while (currentMappingClass != [NSObject class]);
    }
    return self;
}


@end
