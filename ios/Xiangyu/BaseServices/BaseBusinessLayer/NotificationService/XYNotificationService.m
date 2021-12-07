//
//  XYNotificationService.m
//  Xiangyu
//
//  Created by dimon on 27/01/2021.
//

#import "XYNotificationService.h"
#import "TUIKit.h"
#import "ConversationController.h"
#import "WebViewController.h"
#import "XYMyReleaseVC.h"
#import "XYRNBaseViewController.h"
#import "XYRecireHeartBeatPopView.h"
#import "XYReceiveGiftPopView.h"
@interface XYNotificationService ()

@property (nonatomic, strong) NSData *deviceToken;

@property (nonatomic, copy) NSString *userID;

@property (nonatomic, copy) NSString *groupID;

@property (nonatomic, strong) V2TIMSignalingInfo *signalingInfo;

@end

static XYNotificationService *instance = nil;
@implementation XYNotificationService

+ (instancetype)shareService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      instance = [[XYNotificationService alloc] init];
    });
    return instance;
}

- (void)registNotification {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}

- (void)registerForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  self.deviceToken = deviceToken;
  V2TIMAPNSConfig *confg = [[V2TIMAPNSConfig alloc] init];
  confg.businessID = 123;
  confg.token = deviceToken;
  [[V2TIMManager sharedInstance] setAPNS:confg succ:^{
    DLog(@"-----> 设置 APNS 成功");
  } fail:^(int code, NSString *msg) {
    DLog(@"-----> 设置 APNS 失败");
  }];
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (![[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[CYLTabBarController class]]) {
      return;
    }
    NSNumber *type = userInfo[@"type"];
    if (type) {
        if (type.integerValue == 1) {
            WebViewController *vc = [[WebViewController alloc] init];
            vc.urlStr = userInfo[@"data"];
            [[XYNotificationService cyl_topmostViewController] cyl_pushViewController:vc animated:YES];
            return;
        }
        if (type.integerValue == 2) {
          XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"MyOrderDec",@"dataId" : userInfo[@"data"] ?: @""}];
              [[XYNotificationService cyl_topmostViewController] cyl_pushViewController:vc animated:YES];
          return;
        }
        if (type.integerValue == 3) {
          XYMyReleaseVC *releaseVc = [[XYMyReleaseVC alloc] init];
          [[XYNotificationService cyl_topmostViewController] cyl_pushViewController:releaseVc animated:YES];
          return;
        }
        if (type.integerValue == 4) {
          self.cyl_tabBarController.selectedIndex = 2;
          return;
        }
        if (type.integerValue == 5) {
          self.cyl_tabBarController.selectedIndex = 1;
          return;
        }
        if (type.integerValue == 6) {
          XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"Auth"}];
          [[XYNotificationService cyl_topmostViewController] cyl_pushViewController:vc animated:YES];
          return;
        }
      // 礼物
      if (type.integerValue == 7) {
       // self.cyl_tabBarController.selectedIndex = 1;
        //
        XYReceiveGiftPopView *view = [[XYReceiveGiftPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        view.orderId  = userInfo[@"data"];
     
        return;
      }
      // 超级心动
      if (type.integerValue == 8) {
       // self.cyl_tabBarController.selectedIndex = 1;
        XYRecireHeartBeatPopView *view = [[XYRecireHeartBeatPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        view.orderId  = userInfo[@"data"];
        
        return;
      }
    } else {
      [self handleIMNotificationWithInfo:userInfo];
    }
  });
  
}

- (void)handleIMNotificationWithInfo:(NSDictionary *)userInfo {
  NSDictionary *extParam = [userInfo[@"ext"] yy_modelToJSONObject];
  NSDictionary *entity = extParam[@"entity"];
  if (!entity) {
      return;
  }
  // 业务，action : 1 普通文本推送；2 音视频通话推送
  NSString *action = entity[@"action"];
  if (!action) {
      return;
  }
  // 聊天类型，chatType : 1 单聊；2 群聊
  NSString *chatType = entity[@"chatType"];
  if (!chatType) {
      return;
  }
  // action : 1 普通消息推送
  if ([action intValue] == APNs_Business_NormalMsg) {
      if ([chatType intValue] == 1) {   //C2C
          self.userID = entity[@"sender"];
      } else if ([chatType intValue] == 2) { //Group
          self.groupID = entity[@"sender"];
      }
      if ([[V2TIMManager sharedInstance] getLoginStatus] == V2TIM_STATUS_LOGINED) {
          [self xyns_onReceiveNomalMsgAPNs];
      }
  }
  // action : 2 音视频通话推送
  else if ([action intValue] == APNs_Business_Call) {
      // 单聊中的音视频邀请推送不需处理，APP 启动后，TUIkit 会自动处理
      if ([chatType intValue] == 1) {   //C2C
          return;
      }
      // 内容
      NSDictionary *content = [entity[@"content"] yy_modelToJSONObject];
      if (!content) {
          return;
      }
      UInt64 sendTime = [entity[@"sendTime"] integerValue];
      uint32_t timeout = [content[@"timeout"] intValue];
      UInt64 curTime = (UInt64)[[NSDate date] timeIntervalSince1970];
      if (curTime - sendTime > timeout) {//通话接收超时
          return;
      }
      self.signalingInfo = [[V2TIMSignalingInfo alloc] init];
      self.signalingInfo.actionType = (SignalingActionType)[content[@"action"] intValue];
      self.signalingInfo.inviteID = content[@"call_id"];
      self.signalingInfo.inviter = entity[@"sender"];
      self.signalingInfo.inviteeList = content[@"invited_list"];
      self.signalingInfo.groupID = content[@"group_id"];
      self.signalingInfo.timeout = timeout;
    self.signalingInfo.data = [@{SIGNALING_EXTRA_KEY_ROOM_ID : content[@"room_id"], SIGNALING_EXTRA_KEY_VERSION : content[@"version"], SIGNALING_EXTRA_KEY_CALL_TYPE : content[@"call_type"]} yy_modelToJSONString];
      if ([[V2TIMManager sharedInstance] getLoginStatus] == V2TIM_STATUS_LOGINED) {
          [self xyns_onReceiveGroupCallAPNs];
      }
  }
}
  
- (void)xyns_onReceiveNomalMsgAPNs {
    if (self.groupID.length > 0 || self.userID.length > 0) {
      if (![[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[CYLTabBarController class]]) {
        return;
      }
        UITabBarController *tab = [self cyl_tabBarController];
        if (tab.selectedIndex != 3) {
            [tab setSelectedIndex:3];
        }
        UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
        ConversationController *vc = (ConversationController *)nav.viewControllers.firstObject;
        [vc pushToChatViewController:self.groupID userID:self.userID];
        self.groupID = nil;
        self.userID = nil;
    }
}

- (void)xyns_onReceiveGroupCallAPNs {
    if (self.signalingInfo) {
        [[TUIKit sharedInstance] onReceiveGroupCallAPNs:self.signalingInfo];
        self.signalingInfo = nil;
    }
}

@end
