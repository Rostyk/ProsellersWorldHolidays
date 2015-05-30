/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 
 Modified by Eric Horacek for Monospace Ltd. on 2/4/13
 */

#include <sys/sysctl.h>
#import "UIDevice-Hardware.h"

@interface UIDevice (Hardward)

- (NSString *)modelNameForModelIdentifier:(NSString *)modelIdentifier;

@end

@implementation UIDevice (Hardware)

- (NSString *)getSysInfoByName:(char *)typeSpecifier
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

- (NSString *)modelIdentifier
{
    return [self getSysInfoByName:"hw.machine"];
}

- (NSString *)modelName
{
    return [self modelNameForModelIdentifier:[self modelIdentifier]];
}

- (NSString *)modelNameForModelIdentifier:(NSString *)modelIdentifier
{
    // iPhone http://theiphonewiki.com/wiki/IPhone
    
    if ([modelIdentifier isEqualToString:@"iPhone1,1"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone1,2"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone2,1"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone3,1"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone3,2"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone3,3"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone4,1"])    return @"iphone4";
    if ([modelIdentifier isEqualToString:@"iPhone5,1"])    return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPhone5,2"])    return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPhone5,3"])    return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPhone5,4"])    return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPhone6,1"])    return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPhone6,2"])    return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPhone7,1"])    return @"iphone6";
    if ([modelIdentifier isEqualToString:@"iPhone7,2"])    return @"iphone6plus";
    
    // iPad http://theiphonewiki.com/wiki/IPad
    
    if ([modelIdentifier isEqualToString:@"iPad1,1"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad2,1"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad2,2"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad2,3"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad2,4"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad3,1"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad3,2"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad3,3"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad3,4"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad3,5"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad3,6"])      return @"ipad";
    
    if ([modelIdentifier isEqualToString:@"iPad4,1"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad4,2"])      return @"ipad";
    
    // iPad Mini http://theiphonewiki.com/wiki/IPad_mini
    
    if ([modelIdentifier isEqualToString:@"iPad2,5"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad2,6"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad2,7"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad4,4"])      return @"ipad";
    if ([modelIdentifier isEqualToString:@"iPad4,5"])      return @"ipad";
    
    // iPod http://theiphonewiki.com/wiki/IPod
    
    if ([modelIdentifier isEqualToString:@"iPod1,1"])      return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPod2,1"])      return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPod3,1"])      return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPod4,1"])      return @"iphone5";
    if ([modelIdentifier isEqualToString:@"iPod5,1"])      return @"iphone5";
    
    // Simulator
    if ([modelIdentifier hasSuffix:@"86"] || [modelIdentifier isEqual:@"x86_64"])
    {
        BOOL smallerScreen = ([[UIScreen mainScreen] bounds].size.width < 768.0);
        return (smallerScreen ? @"iphone5" : @"ipad");
    }
    
    return modelIdentifier;
}

- (UIDeviceFamily) deviceFamily
{
    NSString *modelIdentifier = [self modelIdentifier];
    if ([modelIdentifier hasPrefix:@"iPhone"]) return UIDeviceFamilyiPhone;
    if ([modelIdentifier hasPrefix:@"iPod"]) return UIDeviceFamilyiPod;
    if ([modelIdentifier hasPrefix:@"iPad"]) return UIDeviceFamilyiPad;
    return UIDeviceFamilyUnknown;
}

@end
