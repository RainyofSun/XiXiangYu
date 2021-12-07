//
//  XYNotificationService.h
//  Xiangyu
//
//  Created by dimon on 27/01/2021.
//

#import <Foundation/Foundation.h>

@interface XYNotificationService : NSObject

+ (instancetype)shareService;

- (void)registNotification;

- (void)registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;
@end
