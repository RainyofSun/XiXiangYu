//
//  XYAppVersion.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYAppVersion : NSObject

/** 判断是否第一次安装 */
+ (BOOL)isFirstInstall;

/** 设置已安装 */
+ (void)setInstalled;

/** 获取当前应用版本号 */
+ (NSString *)currentVersion;

/** 获取沙盒中存储的应用版本号 */
+ (NSString *)currentSandBoxVersion;

/** 存储当前应用版本号 */
+ (void)saveCurrentVersion;

/** 判断是否是新版本 */
+ (BOOL)isNewVersion;

@end
