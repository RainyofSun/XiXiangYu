//
//  XYDelegate+Services.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYDelegate.h"

@interface XYDelegate (Services)

- (void)startServicesWithOptions:(NSDictionary *)launchOptions;

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;

@end
