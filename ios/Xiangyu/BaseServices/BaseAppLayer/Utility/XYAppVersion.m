//
//  XYAppVersion.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYAppVersion.h"

static NSString *const XYInstallStatusPrimaryKey = @"XYInstallStatusPrimaryKey";

static NSString *const XYCurrentVersionPrimaryKey = @"XYCurrentVersionPrimaryKey";

#define XYUserDefault [NSUserDefaults standardUserDefaults]

@implementation XYAppVersion

+ (BOOL)isFirstInstall {
    NSString *status = [XYUserDefault valueForKey:XYInstallStatusPrimaryKey];
     return status.isNotBlank;
    
}
+ (void)setInstalled {
    [XYUserDefault setValue:@"1" forKey:XYInstallStatusPrimaryKey];
    [XYUserDefault synchronize];
}
+ (NSString *)currentVersion {
    return [[[NSBundle mainBundle] infoDictionary]
            objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)currentSandBoxVersion {
    return [XYUserDefault valueForKey:XYCurrentVersionPrimaryKey];
}

+ (void)saveCurrentVersion {
    
    [XYUserDefault setValue:[self currentVersion]
                     forKey:XYCurrentVersionPrimaryKey];
    
    [XYUserDefault synchronize];
}

+ (BOOL)isNewVersion {
    NSString *cut = [self currentVersion];
    NSString *pre = [self currentSandBoxVersion];
    if ([cut isEqualToString:pre]) {
        return NO;
    } else {
        return YES;
    }
}
@end
