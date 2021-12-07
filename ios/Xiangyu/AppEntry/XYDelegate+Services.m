//
//  XYDelegate+Services.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYDelegate+Services.h"
#import "IQKeyboardManager.h"
#import "XYClientExceptionInterceptor.h"
#import "XYUserService.h"
#import "XYAddressService.h"
#import "XYLocationService.h"
#import "XYIMService.h"
#import "XYNotificationService.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"

#import "XYPlatformService.h"
@implementation XYDelegate (Services)
- (void)startServicesWithOptions:(NSDictionary *)launchOptions {
    
  [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
  [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
  [[IQKeyboardManager sharedManager].disabledDistanceHandlingClasses addObject:NSClassFromString(@"XYDynamicsDetailController")];
  
  [[XYUserService service] start];
  
  [[XYAddressService sharedService] start];
  
  [[XYLocationService sharedService] start];
  
  [[XYClientExceptionInterceptor interceptor] activate];
    
  [[XYNotificationService shareService] registNotification];
  
  [[XYIMService shareService] setupIMService];
  
  [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"SoundMode"];
  [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"LiveMode"];
  [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"ByOrder"];
  [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"checkAgreeBtn"];
  NSString* licensePath = [NSString stringWithFormat:@"%@.%@", FACE_LICENSE_NAME, FACE_LICENSE_SUFFIX ];
  [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath andRemoteAuthorize:false];
  NSLog(@"canWork = %d",[[FaceSDKManager sharedInstance] canWork]);
  NSLog(@"version = %@",[[FaceSDKManager sharedInstance] getVersion]);
  
  
  [[XYPlatformService shareService] getSystemJson];
  // 延迟执行初始化，提升启动速度
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
#ifdef DEBUG
    [PLShortVideoKitEnv initEnv];
    [PLShortVideoKitEnv enableFileLogging];
    [PLShortVideoKitEnv setLogLevel:(PLShortVideoLogLevelDebug)];
    
#else
    [PLShortVideoKitEnv setLogLevel:(PLShortVideoLogLevelOff)];
#endif
  });

  
   AVAudioSessionCategoryOptions options = AVAudioSessionCategoryOptionDefaultToSpeaker |  AVAudioSessionCategoryOptionAllowBluetooth;
  [[AVAudioSession sharedInstance] setCategory:(AVAudioSessionCategoryPlayback) withOptions:options error:nil];

}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [[XYNotificationService shareService] registerForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
  [[XYNotificationService shareService] didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}


@end
