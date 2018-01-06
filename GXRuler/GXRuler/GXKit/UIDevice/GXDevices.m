//
//  GXDevices.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "GXDevices.h"
#include <sys/utsname.h>

@implementation GXDevices

- (instancetype)initWithPlatform:(NSString *)platform
                        withName:(NSString *)name
                        withRank:(NSInteger)rank
{
    self = [super init];
    if (self) {
        _platform = platform;
        _name     = name;
        _rank     = rank;
    }
    return self;
}

inline static void BFCDeviceRegister(NSMutableDictionary *dict, NSString *platform, NSString *name, NSInteger rank)
{
    GXDevices *device = [[GXDevices alloc] initWithPlatform:platform
                                                     withName:name
                                                     withRank:rank];
    [dict setObject:device forKey:platform];
}

+ (instancetype)modelWithName:(NSString *)name
{
    static GXDevices *sLatestDevice = nil;
    static NSDictionary *sDeviceDictionary = nil;
    static dispatch_once_t sOnceToken = 0;
    dispatch_once(&sOnceToken, ^{
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        // https://en.wikipedia.org/wiki/List_of_iOS_devices
        // Simulator
        BFCDeviceRegister(dict, @"i386",         @"Simulator",       kBFCDeviceRank_Simulator);
        BFCDeviceRegister(dict, @"x86_64",       @"Simulator 64",    kBFCDeviceRank_Simulator);
        
        // iPhone
        BFCDeviceRegister(dict, @"iPhone1",      @"iPhone",          kBFCDeviceRank_Baseline);
        BFCDeviceRegister(dict, @"iPhone1,1",    @"iPhone",          kBFCDeviceRank_Baseline);
        BFCDeviceRegister(dict, @"iPhone1,2",    @"iPhone 3G",       kBFCDeviceRank_Baseline);
        BFCDeviceRegister(dict, @"iPhone2",      @"iPhone 3GS",      kBFCDeviceRank_Baseline);
        BFCDeviceRegister(dict, @"iPhone2,1",    @"iPhone 3GS",      kBFCDeviceRank_Baseline);
        
        BFCDeviceRegister(dict, @"iPhone3",      @"iPhone 4",        kBFCDeviceRank_AppleA4Class);
        BFCDeviceRegister(dict, @"iPhone3,1",    @"iPhone 4",        kBFCDeviceRank_AppleA4Class);
        BFCDeviceRegister(dict, @"iPhone3,2",    @"iPhone 4",        kBFCDeviceRank_AppleA4Class);
        BFCDeviceRegister(dict, @"iPhone3,3",    @"iPhone 4",        kBFCDeviceRank_AppleA4Class);
        
        BFCDeviceRegister(dict, @"iPhone4",      @"iPhone 4s",       kBFCDeviceRank_AppleA5Class);
        BFCDeviceRegister(dict, @"iPhone4,1",    @"iPhone 4s",       kBFCDeviceRank_AppleA5Class);
        
        BFCDeviceRegister(dict, @"iPhone5",      @"iPhone 5/5c",     kBFCDeviceRank_AppleA6Class);
        BFCDeviceRegister(dict, @"iPhone5,1",    @"iPhone 5",        kBFCDeviceRank_AppleA6Class);
        BFCDeviceRegister(dict, @"iPhone5,2",    @"iPhone 5",        kBFCDeviceRank_AppleA6Class);
        BFCDeviceRegister(dict, @"iPhone5,3",    @"iPhone 5c",       kBFCDeviceRank_AppleA6Class);
        BFCDeviceRegister(dict, @"iPhone5,4",    @"iPhone 5c",       kBFCDeviceRank_AppleA6Class);
        
        BFCDeviceRegister(dict, @"iPhone6",      @"iPhone 5s",       kBFCDeviceRank_AppleA7Class);
        BFCDeviceRegister(dict, @"iPhone6,1",    @"iPhone 5s",       kBFCDeviceRank_AppleA7Class);
        BFCDeviceRegister(dict, @"iPhone6,2",    @"iPhone 5s",       kBFCDeviceRank_AppleA7Class);
        
        BFCDeviceRegister(dict, @"iPhone7",      @"iPhone 6/6 Plus", kBFCDeviceRank_AppleA8Class);
        BFCDeviceRegister(dict, @"iPhone7,1",    @"iPhone 6 Plus",   kBFCDeviceRank_AppleA8Class);
        BFCDeviceRegister(dict, @"iPhone7,2",    @"iPhone 6",        kBFCDeviceRank_AppleA8Class);
        
        BFCDeviceRegister(dict, @"iPhone8",      @"iPhone 6s/6s Plus",kBFCDeviceRank_AppleA9Class);
        BFCDeviceRegister(dict, @"iPhone8,2",    @"iPhone 6s Plus",   kBFCDeviceRank_AppleA9Class);
        BFCDeviceRegister(dict, @"iPhone8,1",    @"iPhone 6s",        kBFCDeviceRank_AppleA9Class);
        BFCDeviceRegister(dict, @"iPhone8,4",    @"iPhone SE",        kBFCDeviceRank_AppleA9Class);
        
        BFCDeviceRegister(dict, @"iPhone9",      @"iPhone 7/7 Plus", kBFCDeviceRank_AppleA9Class);
        BFCDeviceRegister(dict, @"iPhone9,1",    @"iPhone 7",        kBFCDeviceRank_AppleA9Class);
        BFCDeviceRegister(dict, @"iPhone9,3",    @"iPhone 7",        kBFCDeviceRank_AppleA9Class);
        BFCDeviceRegister(dict, @"iPhone9,2",    @"iPhone 7 Plus",   kBFCDeviceRank_AppleA9Class);
        BFCDeviceRegister(dict, @"iPhone9,4",    @"iPhone 7 Plus",   kBFCDeviceRank_AppleA9Class);
        
        // iPod Touch
        BFCDeviceRegister(dict, @"iPod1",        @"iPod Touch",      kBFCDeviceRank_Baseline);
        BFCDeviceRegister(dict, @"iPod1,1",      @"iPod Touch",      kBFCDeviceRank_Baseline);
        
        BFCDeviceRegister(dict, @"iPod2",        @"iPod Touch 2G",   kBFCDeviceRank_Baseline);
        BFCDeviceRegister(dict, @"iPod2,1",      @"iPod Touch 2G",   kBFCDeviceRank_Baseline);
        
        BFCDeviceRegister(dict, @"iPod3",        @"iPod Touch 3G",   kBFCDeviceRank_Baseline);
        BFCDeviceRegister(dict, @"iPod3,1",      @"iPod Touch 3G",   kBFCDeviceRank_Baseline);
        
        BFCDeviceRegister(dict, @"iPod4",        @"iPod Touch 4G",   kBFCDeviceRank_AppleA4Class);
        BFCDeviceRegister(dict, @"iPod4,1",      @"iPod Touch 4G",   kBFCDeviceRank_AppleA4Class);
        
        BFCDeviceRegister(dict, @"iPod5",        @"iPod Touch 5G",   kBFCDeviceRank_AppleA5Class);
        BFCDeviceRegister(dict, @"iPod5,1",      @"iPod Touch 5G",   kBFCDeviceRank_AppleA5Class);
        
        BFCDeviceRegister(dict, @"iPod7",        @"iPod Touch 6G",   kBFCDeviceRank_AppleA8LowClass);
        BFCDeviceRegister(dict, @"iPod7,1",      @"iPod Touch 6G",   kBFCDeviceRank_AppleA8LowClass);
        
        // iPad / iPad mini
        BFCDeviceRegister(dict, @"iPad1",        @"iPad",         kBFCDeviceRank_AppleA4Class);
        BFCDeviceRegister(dict, @"iPad1,1",      @"iPad",         kBFCDeviceRank_AppleA4Class);
        
        BFCDeviceRegister(dict, @"iPad2",        @"iPad 2/mini",  kBFCDeviceRank_AppleA5Class);
        BFCDeviceRegister(dict, @"iPad2,1",      @"iPad 2",       kBFCDeviceRank_AppleA5Class);
        BFCDeviceRegister(dict, @"iPad2,2",      @"iPad 2",       kBFCDeviceRank_AppleA5Class);
        BFCDeviceRegister(dict, @"iPad2,3",      @"iPad 2",       kBFCDeviceRank_AppleA5Class);
        BFCDeviceRegister(dict, @"iPad2,4",      @"iPad 2",       kBFCDeviceRank_AppleA5RAClass);
        BFCDeviceRegister(dict, @"iPad2,5",      @"iPad mini",    kBFCDeviceRank_AppleA5RAClass);
        BFCDeviceRegister(dict, @"iPad2,6",      @"iPad mini",    kBFCDeviceRank_AppleA5RAClass);
        BFCDeviceRegister(dict, @"iPad2,7",      @"iPad mini",    kBFCDeviceRank_AppleA5RAClass);
        
        BFCDeviceRegister(dict, @"iPad3",        @"iPad 3/4",     kBFCDeviceRank_AppleA5XClass);
        BFCDeviceRegister(dict, @"iPad3,1",      @"iPad 3",       kBFCDeviceRank_AppleA5XClass);
        BFCDeviceRegister(dict, @"iPad3,2",      @"iPad 3",       kBFCDeviceRank_AppleA5XClass);
        BFCDeviceRegister(dict, @"iPad3,3",      @"iPad 3",       kBFCDeviceRank_AppleA5XClass);
        BFCDeviceRegister(dict, @"iPad3,4",      @"iPad 4",       kBFCDeviceRank_AppleA6XClass);
        BFCDeviceRegister(dict, @"iPad3,5",      @"iPad 4",       kBFCDeviceRank_AppleA6XClass);
        BFCDeviceRegister(dict, @"iPad3,6",      @"iPad 4",       kBFCDeviceRank_AppleA6XClass);
        
        BFCDeviceRegister(dict, @"iPad4",        @"iPad Air/mini 2/mini 3",kBFCDeviceRank_AppleA7Class);
        BFCDeviceRegister(dict, @"iPad4,1",      @"iPad Air",       kBFCDeviceRank_AppleA7Class);
        BFCDeviceRegister(dict, @"iPad4,2",      @"iPad Air",       kBFCDeviceRank_AppleA7Class);
        BFCDeviceRegister(dict, @"iPad4,3",      @"iPad Air",       kBFCDeviceRank_AppleA7Class);
        BFCDeviceRegister(dict, @"iPad4,4",      @"iPad mini 2",    kBFCDeviceRank_AppleA7Class);
        BFCDeviceRegister(dict, @"iPad4,5",      @"iPad mini 2",    kBFCDeviceRank_AppleA7Class);
        BFCDeviceRegister(dict, @"iPad4,6",      @"iPad mini 2",    kBFCDeviceRank_AppleA7Class);
        BFCDeviceRegister(dict, @"iPad4,7",      @"iPad mini 3",    kBFCDeviceRank_AppleA7Class);
        BFCDeviceRegister(dict, @"iPad4,8",      @"iPad mini 3",    kBFCDeviceRank_AppleA7Class);
        BFCDeviceRegister(dict, @"iPad4,9",      @"iPad mini 3",    kBFCDeviceRank_AppleA7Class);
        
        BFCDeviceRegister(dict, @"iPad5",        @"iPad Air 2/mini 4",kBFCDeviceRank_AppleA8XClass);
        BFCDeviceRegister(dict, @"iPad5,1",      @"iPad mini 4",     kBFCDeviceRank_AppleA8XClass);
        BFCDeviceRegister(dict, @"iPad5,2",      @"iPad mini 4",     kBFCDeviceRank_AppleA8XClass);
        BFCDeviceRegister(dict, @"iPad5,3",      @"iPad Air 2",      kBFCDeviceRank_AppleA8XClass);
        BFCDeviceRegister(dict, @"iPad5,4",      @"iPad Air 2",      kBFCDeviceRank_AppleA8XClass);
        
        BFCDeviceRegister(dict, @"iPad6",        @"iPad Pro",        kBFCDeviceRank_AppleA9XClass);
        BFCDeviceRegister(dict, @"iPad6,3",      @"iPad Pro",        kBFCDeviceRank_AppleA9XClass);
        BFCDeviceRegister(dict, @"iPad6,4",      @"iPad Pro",        kBFCDeviceRank_AppleA9XClass);
        BFCDeviceRegister(dict, @"iPad6,7",      @"iPad Pro",        kBFCDeviceRank_AppleA9XClass);
        BFCDeviceRegister(dict, @"iPad6,8",      @"iPad Pro",        kBFCDeviceRank_AppleA9XClass);
        BFCDeviceRegister(dict, @"iPad6,11",     @"iPad 5",          kBFCDeviceRank_AppleA9Class);
        BFCDeviceRegister(dict, @"iPad6,12",     @"iPad 5",          kBFCDeviceRank_AppleA9Class);
        
        sDeviceDictionary = dict;
        
        sLatestDevice = [[GXDevices alloc] initWithPlatform:name
                                                    withName:name
                                                    withRank:kBFCDeviceRank_LatestUnknown];
    });
    
    GXDevices *device = [sDeviceDictionary objectForKey:name];
    if (device == nil) {
        if (device == nil) {
            device = sLatestDevice;
        }
        
        NSArray *components = [name componentsSeparatedByString:@","];
        if (components != nil && components.count > 0) {
            NSString *majorName = components[0];
            if (majorName != nil) {
                majorName = [majorName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                device = [sDeviceDictionary objectForKey:majorName];
            }
        }
    }
    
    return device;
}

+ (NSString *)currentDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithUTF8String:systemInfo.machine];
}

+ (instancetype)currentDevice
{
    return [GXDevices modelWithName:[GXDevices currentDeviceName]];
}


@end
