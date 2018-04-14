//
//  NSString+TouchID.h
//  QRG_LAContext
//
//  Created by 邱荣贵 on 2018/4/15.
//  Copyright © 2018年 邱久. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TouchID)


/**
 判断支持机型 iPhone 5s 以上

 @return <#return value description#>
 */
+ (BOOL)judueIPhonePlatformSupportTouchID;

@end
