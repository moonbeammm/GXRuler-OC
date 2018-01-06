//
//  UIDevice+Device.m
//  GXRuler
//
//  Created by sunguangxin on 2017/8/14.
//  Copyright © 2017年 sunguangxin. All rights reserved.
//

#import "UIDevice+Device.h"

#import <CommonCrypto/CommonDigest.h>

#include <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <CoreTelephony/CTCarrier.h>

#include <sys/utsname.h>
#include <sys/socket.h>
#include <sys/sysctl.h>

#include <net/if_dl.h>
#include <net/if.h>


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation NSString (MD5String)

- (NSString *)MD5String
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(value, (int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count ++)
    {
        [outputString appendFormat:@"%02x", outputBuffer[count]];
    }
    
    return outputString;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct _DEVICE_INFO
{
    const char *platform;
    const char *platformString;
    iOSDeviceType type;
    int isRetina;
};

static const struct _DEVICE_INFO deviceList[] = {
    {"iPhone1,1",   "iPhone 1G",            iOSDeviceTypePhone, 0}, 
    {"iPhone1,2",   "iPhone 3G",            iOSDeviceTypePhone, 0}, 
    {"iPhone2,1",   "iPhone 3GS",           iOSDeviceTypePhone, 0}, 
    {"iPhone3,1",   "iPhone 4",             iOSDeviceTypePhone, 1}, 
    {"iPhone3,2",   "iPhone 4 (Sprint)",     iOSDeviceTypePhone, 1}, 
    {"iPhone3,3",   "iPhone 4 (Verizon)",    iOSDeviceTypePhone, 1}, 
    {"iPhone4,1",   "iPhone 4S",            iOSDeviceTypePhone, 1}, 
    {"iPod1,1",     "iPod Touch 1",         iOSDeviceTypePhone, 0}, 
    {"iPod2,1",     "iPod Touch 2",         iOSDeviceTypePhone, 0}, 
    {"iPod3,1",     "iPod Touch 3",         iOSDeviceTypePhone, 0}, 
    {"iPod4,1",     "iPod Touch 4",         iOSDeviceTypePhone, 1}, 
    {"iPad1,1",     "iPad (WiFi)",          iOSDeviceTypePhone, 0}, 
    {"iPad1,2",     "iPad (GSM)",           iOSDeviceTypePhone, 0}, 
    {"iPad2,1",     "iPad 2 (WiFi)",        iOSDeviceTypePhone, 0}, 
    {"iPad2,2",     "iPad 2 (GSM)",         iOSDeviceTypePhone, 0}, 
    {"iPad2,3",     "iPad 2 (CDMA)",        iOSDeviceTypePhone, 0}, 
    {"iPad3,1",     "iPad 3 (WiFi)",        iOSDeviceTypePhone, 1}, 
    {"iPad3,2",     "iPad 3 (LTE)",         iOSDeviceTypePhone, 1}, 
    {"i386",        "Simulator",            iOSDeviceTypePhone, -1}, 
    {"x86_64",      "Simulator",            iOSDeviceTypePhone, -1}, 
};

static const int32_t deviceListCount = sizeof(deviceList) / sizeof(struct _DEVICE_INFO);

static int32_t currentDevice = -2;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation UIDevice (Device)


- (BOOL)isJailbroken
{
    BOOL jailbroken = NO;
    
    @try {
        
        NSString *cydiaPath = @"/Applications/Cydia.app";
        NSString *aptPath = @"/private/var/lib/apt/";
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath])
        {
            jailbroken = YES;
        }
        else if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath])
        {
            jailbroken = YES;
        }
    }
    @catch (NSException *exception) {
        ;
    }
    @finally {
        ;
    }
    
    return jailbroken;
}

- (BOOL)isAppSyncExist
{
    static BOOL isappsync = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOOL isbash = NO;
        FILE *f = fopen("/bin/bash", "r");
        if (f != NULL)
        {
            //Device is jailbroken
            isbash = YES;
            fclose(f);
        }
        
        if (isbash)
        {
            if (isappsync == NO)
            {
                f = fopen("/91/DeviceInfo.xml", "r");
                if (f != NULL)
                {
                    isappsync = YES;
                    fclose(f);
                }
            }
            if (isappsync == NO)
            {
                f = fopen("/Library/MobileSubstrate/DynamicLibraries/AppSync.plist", "r");
                if (f != NULL)
                {
                    isappsync = YES;
                    fclose(f);
                }
            }
            if (isappsync == NO)
            {
                NSError *err;
                NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/private/var/lib/dpkg/info" error:&err];
                
                for (int i = 0; i < files.count; i++)
                {
                    NSString *fname = files[i];
                    if ([fname rangeOfString:@"appsync" options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        isappsync = YES;
                        break;
                    }
                }
            }
            if (isappsync == NO)
            {
                NSError *err;
                NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/lib/dpkg/info" error:&err];
                
                for (int i = 0; i < files.count; i++)
                {
                    NSString *fname = files[i];
                    if ([fname rangeOfString:@"appsync" options:NSCaseInsensitiveSearch].location != NSNotFound)
                    {
                        isappsync = YES;
                        break;
                    }
                }
            }
        }
    });
    
    return isappsync == YES;
}

- (NSString *)platform
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return @(systemInfo.machine);
}

- (int32_t)getDeviceID
{
    if (-2 != currentDevice)
        return currentDevice;
    
    currentDevice = -1;
    
    NSString *platform = [self platform];
    
    for (int32_t i = 0; i < deviceListCount; i ++)
    {
        if ([platform isEqualToString:@(deviceList[i].platform)])
        {
            currentDevice = i;
            break;
        }
    }
    
    return currentDevice;
}

- (NSString *)platformString
{
    int32_t deviceID = [self getDeviceID];
    
    switch (deviceID)
    {
        case -1:
            return [self platform];
            
        default:
            return @(deviceList[deviceID].platformString);
    }
}

- (BOOL)isRetina
{
    int32_t deviceID = [self getDeviceID];
    
    switch (deviceID)
    {
        case -1:
            break;
            
        default:
            switch (deviceList[deviceID].isRetina)
        {
            case -1:
                break;
                
            default:
                return deviceList[deviceID].isRetina;
        }
    }
    
    if (([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
         ([UIScreen mainScreen].scale == 2.0)))
        return YES;
    else
        return NO;
    
}

- (enum iOSDeviceType)deviceType
{
    int32_t deviceID = [self getDeviceID];
    
    switch (deviceID)
    {
        case -1:
            return iOSDeviceTypeUnknown;
            
        default:
            return deviceList[deviceID].type;
    }
}

- (NSString *)carrierName
{
    CTCarrier *carrier = [[CTTelephonyNetworkInfo alloc] init].subscriberCellularProvider;
    
    if (nil == [carrier carrierName])
        return @"";
    else
        return [carrier carrierName];
}

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *)macaddress
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

- (NSString *)uniqueGlobalDeviceIdentifier
{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *uniqueIdentifier = [macaddress MD5String];
    
    return uniqueIdentifier;
}

//#ifndef NSFoundationVersionNumber_iOS_7_0
//#define NSFoundationVersionNumber_iOS_7_0 1047.00
//#endif

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

+ (BOOL)isIOS6OrLater
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0");
}

+ (BOOL)isIOS6Befor
{
    return SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"6.5");
}

+ (BOOL)isIOS7
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0 && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
}

+ (BOOL)isIOS7OrLater
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0");
}

+ (BOOL)isIOS7Befor
{
    return SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"6.9");
}

+ (BOOL)isIOS8OrLater
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0");
}

+ (BOOL)isIOS8Befor
{
    return SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"7.9");
}

+ (BOOL)isIOS9OrLater
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0");
}

+ (BOOL)isIOS10OrLater
{
    return SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0");
}

+ (BOOL)isIPad
{
    return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

+ (BOOL)isIPhone5Later
{
    return [[UIScreen mainScreen] currentMode].size.height >= 1136; 
}

+ (BOOL)isIPhone6Later
{
    return [[UIScreen mainScreen] currentMode].size.width >= 750;
}

+ (BOOL)is64bit
{
#if defined(__LP64__) && __LP64__
    return YES;
#else
    return NO;
#endif
}

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPAD_PRO (IS_IPAD && SCREEN_MAX_LENGTH == 1366.0)

+ (BOOL)isIPhone4ORLess
{
    return IS_IPHONE_4_OR_LESS;
}

+ (BOOL)isIPhone5
{
    return IS_IPHONE_5;
}

+ (BOOL)isIPhone6
{
    return IS_IPHONE_6;
}

+ (BOOL)isIphone6P
{
    return IS_IPHONE_6P;
}

+ (BOOL)isIpadPro
{
    return IS_IPAD_PRO;
}

@end
