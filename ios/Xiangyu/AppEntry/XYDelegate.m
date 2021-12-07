//
//  XYDelegate.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/9.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD
//

#import "XYDelegate.h"
#import "XYDelegate+WindowInitialization.h"
#import "XYDelegate+Services.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
// 引入 JSHARE 功能所需头文件
#import "JSHAREService.h"
#import "JVERIFICATIONService.h"

#import <AlipaySDK/AlipaySDK.h>
#import <WechatOpenSDK/WXApi.h>//微信支付



@interface XYDelegate ()<JPUSHRegisterDelegate,WXApiDelegate>

@end

@implementation XYDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self startServicesWithOptions:launchOptions];
    
    [self initializeWindowWithOptions:launchOptions];
  [WXApi registerApp:@"wxc4e300441407d3d4" universalLink:@"https://www.xixiangyuapp.com/"];

  
  //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
      // 可以添加自定义 categories
      // NSSet<UNNotificationCategory *> *categories for iOS10 or later
      // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
  
#ifdef DEBUG
    BOOL isProduction = NO;
#else
  BOOL isProduction = YES;
#endif
  
  JVAuthConfig *authConfig = [[JVAuthConfig alloc] init];
  authConfig.appKey = @"464ed418525b7f267d930202";
  [JVERIFICATIONService setupWithConfig:authConfig];
  [JVERIFICATIONService setDebug:isProduction];
  
  [JPUSHService setupWithOption:launchOptions appKey:@"464ed418525b7f267d930202"
                          channel:@"App Store"
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
  
  JSHARELaunchConfig *shareConfig = [[JSHARELaunchConfig alloc] init];
  shareConfig.appKey = @"464ed418525b7f267d930202";

  shareConfig.QQAppId = @"1111446358";
  shareConfig.QQAppKey = @"GXAcAydZptqryq9q";
  
  shareConfig.WeChatAppId = @"wxc4e300441407d3d4";
  shareConfig.WeChatAppSecret = @"d9156e091fe0ef908a4ee6fb9e9b5c02";
  shareConfig.universalLink = @"https://www.xixiangyuapp.com/";
  
  [JSHAREService setupWithConfig:shareConfig];
  [JSHAREService setDebug:YES];
  
 

  
  
  
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  [application setApplicationIconBadgeNumber:0];
  [application cancelAllLocalNotifications];
  [JPUSHService resetBadge];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    [JSHAREService handleOpenUrl:url];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
  if ([url.host isEqualToString:@"safepay"]) {
      // 支付跳转支付宝钱包进行支付，处理支付结果
      [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
          DLog(@"result = %@",resultDic);
        XYToastText(resultDic[@"memo"]);
          if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipayChongzhichenggong" object:nil];
          }
      }];
      
      // 授权跳转支付宝钱包进行支付，处理支付结果
      [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
          DLog(@"result = %@",resultDic);
          // 解析 auth code
          NSString *result = resultDic[@"result"];
          NSString *authCode = nil;
          if (result.length>0) {
              NSArray *resultArr = [result componentsSeparatedByString:@"&"];
              for (NSString *subResult in resultArr) {
                  if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                      authCode = [subResult substringFromIndex:10];
                      break;
                  }
              }
          }
          DLog(@"授权结果 authCode = %@", authCode?:@"");
      }];
  }if ([url.host isEqualToString:@"pay"]){
    [WXApi handleOpenURL:url delegate:self];
  }  else {
    [JSHAREService handleOpenUrl:url];

  }
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler API_AVAILABLE(ios(8.0)) {
    [JSHAREService handleOpenUrl:userActivity.webpageURL];
  
  [WXApi handleOpenUniversalLink:userActivity delegate:self];
    return YES;
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  //Optional
  DLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [self didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
  [self didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
  [JPUSHService handleRemoteNotification:userInfo];
  completionHandler(UIBackgroundFetchResultNewData);
}
#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center  willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
  NSDictionary * userInfo = notification.request.content.userInfo;
  if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler(UNNotificationPresentationOptionAlert);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler: (void (^)())completionHandler {
  NSDictionary * userInfo = response.notification.request.content.userInfo;
  if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
    [self didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    [JPUSHService handleRemoteNotification:userInfo];
  }
  completionHandler();
}
#pragma mark --你的程序要实现和微信终端交互的具体请求与回应，因此需要实现WXApiDelegate协议的两个方法：--

-(void) onReq:(BaseReq*)req{
 //onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。

}
-(void) onResp:(BaseResp*)resp{
  //如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
  if([resp isKindOfClass:[PayResp class]]){
    PayResp*response=(PayResp*)resp;
    NSString *strMsg = @"支付失败";
    switch(response.errCode){
      case WXSuccess:
      {
        //服务器端查询支付通知或查询API返回的结果再提示成功
        DLog(@"支付成功");
        strMsg = @"支付成功";
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WechartChongzhichenggong" object:nil];

        break;
      }
      case WXErrCodeUserCancel:
      {
        DLog(@"用户点击取消");
        strMsg = @"用户点击取消";
        XYToastText(strMsg);
      }
        break;
      default:
        DLog(@"支付失败，retcode=%d",resp.errCode);
        XYToastText(@"支付失败");
        break;
    }
  }

}
@end
