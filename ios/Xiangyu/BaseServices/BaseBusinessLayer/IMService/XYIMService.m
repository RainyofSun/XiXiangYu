//
//  XYIMService.m
//  Xiangyu
//
//  Created by dimon on 27/01/2021.
//

#import "XYIMService.h"
#import "TUIKit.h"
#import "XYUserService.h"

static const int SDKAPPID = 1400463234;

static XYIMService *instance = nil;

@implementation XYIMService

+ (instancetype)shareService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XYIMService alloc] init];
    });
    return instance;
}

- (void)setupIMService {
  [[TUIKit sharedInstance] setupWithAppId:SDKAPPID];

  if ([[XYUserService service] isLogin]) {
    [[TUILocalStorage sharedInstance] login:^(NSString * _Nonnull identifier, NSUInteger appId, NSString * _Nonnull userSig) {
        if(appId == SDKAPPID && identifier.isNotBlank && userSig.isNotBlank){
            [self loginIMWithIdentifier:identifier sign:userSig block:nil];
        }
    }];
  }
  
  TUIKitConfig *config = [TUIKitConfig defaultConfig];
  config.avatarType = TAvatarTypeRounded;
  config.enableGroupLiveEntry = NO;
  
}

- (void)loginIMWithIdentifier:(NSString *)identifier
                         sign:(NSString *)sign
                        block:(void(^)(BOOL ret))block {
  
  V2TIMLoginStatus status = [[V2TIMManager sharedInstance] getLoginStatus];
  
  if (status == V2TIM_STATUS_LOGOUT) {
    [[TUIKit sharedInstance] login:identifier userSig:sign succ:^{
        DLog(@"-----> 登录成功");
        [[TUILocalStorage sharedInstance] saveLogin:identifier withAppId:SDKAPPID withUserSig:sign];
      if (block) block(YES);
    } fail:^(int code, NSString *msg) {
      DLog(@"-----> 登录失败");
      if (block) block(NO);
    }];
  } else {
    NSString * curUser = [[V2TIMManager sharedInstance] getLoginUser];
    if (![identifier isEqualToString:curUser]) {
      @weakify(self);
      [[V2TIMManager sharedInstance] logout:^{
        [weak_self loginIMWithIdentifier:identifier sign:sign block:block];
      } fail:^(int code, NSString *desc) {
        [weak_self loginIMWithIdentifier:identifier sign:sign block:block];
      }];
    }
  }
}


@end
