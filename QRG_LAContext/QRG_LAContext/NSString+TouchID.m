//
//  NSString+TouchID.m
//  QRG_LAContext
//
//  Created by 邱荣贵 on 2018/4/15.
//  Copyright © 2018年 邱久. All rights reserved.
//


#define IOS8_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)

#define IS_PAD (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)

#import "NSString+TouchID.h"

#import <sys/sysctl.h>

@implementation NSString (TouchID)

+ (NSString *)platform{
    
    
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
    
}


+ (BOOL)judueIPhonePlatformSupportTouchID{
    
    /*
     if ([platform isEqualToString:@"iPhone1,1"])   return @"iPhone1G GSM";
     if ([platform isEqualToString:@"iPhone1,2"])   return @"iPhone3G GSM";
     if ([platform isEqualToString:@"iPhone2,1"])   return @"iPhone3GS GSM";
     if ([platform isEqualToString:@"iPhone3,1"])   return @"iPhone4 GSM";
     if ([platform isEqualToString:@"iPhone3,3"])   return @"iPhone4 CDMA";
     if ([platform isEqualToString:@"iPhone4,1"])   return @"iPhone4S";
     if ([platform isEqualToString:@"iPhone5,1"])   return @"iPhone5";
     if ([platform isEqualToString:@"iPhone5,2"])   return @"iPhone5";
     if ([platform isEqualToString:@"iPhone5,3"])   return @"iPhone 5c (A1456/A1532)";
     if ([platform isEqualToString:@"iPhone5,4"])   return @"iPhone 5c (A1507/A1516/A1526/A1529)";
     if ([platform isEqualToString:@"iPhone6,1"])   return @"iPhone 5s (A1453/A1533)";
     if ([platform isEqualToString:@"iPhone6,2"])   return @"iPhone 5s (A1457/A1518/A1528/A1530)";
     */
    
    if(IS_IPHONE)
    {
        if([self platform].length > 6 )
        {
            NSString * numberPlatformStr = [[self platform] substringWithRange:NSMakeRange(6, 1)];
            NSInteger numberPlatform = [numberPlatformStr integerValue];
            // 是否是5s以上的设备
            if(numberPlatform > 5)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    else
    {
        // 我们不支持iPad 设备
        return NO;
    }
    
    return YES;
}
@end
