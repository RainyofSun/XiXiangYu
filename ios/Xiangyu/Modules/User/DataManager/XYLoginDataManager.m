//
//  XYLoginDataManager.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYLoginDataManager.h"
#import "XYLoginAPI.h"
#import "XYFetchCheckCodeAPI.h"
#import "XYUserService.h"
#import "XYFastLoginAPI.h"
#import "XYWechatLoginAPI.h"
#import "XYQQLoginAPI.h"

@interface XYLoginDataManager ()

@property (nonatomic,strong,readwrite) XYLoginModel *loginModel;

@end

@implementation XYLoginDataManager

- (void)fetchDefaultUserWithBlock:(void(^)(XYLoginModel *loginModel))block {
    XYUserInfo *userInfo = [[XYUserService service] fetchHandleUser];
    self.loginModel.mobile = userInfo.mobile ?: @"";
    if (block) block(self.loginModel);
}
- (void)fetchCheckcodeWithBlock:(void(^)(XYError * _Nullable error))block {
  XYFetchCheckCodeAPI *api = [[XYFetchCheckCodeAPI alloc] initWithMobile:self.loginModel.mobile type:XYCheckCodeTypeRegister];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYError *subError = error ? ([error.code isEqualToString:@"-1"] ? nil : error) : nil;
    if (block) block(subError);
  };
  [api start];
}

- (void)loginWithBlock:(void(^)(BOOL isNeedPerfect, XYError * _Nullable error))block {
    XYLoginAPI *api = [[XYLoginAPI alloc] initWithLoginParams:self.loginModel];
    @weakify(self);
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
        if (error || !data) {
            if (block) block(NO,error);
            return;
        }
        @strongify(self);
      
      XYUserInfo *user = [[XYUserInfo alloc] init];
      user.mobile = self.loginModel.mobile;
      user.isFirst = data[@"isFirst"];
      user.userId = data[@"userId"];
      user.mobile = data[@"mobile"];
      user.realName = data[@"realName"];
      user.nickName = data[@"nickName"];
      user.headPortrait = data[@"headPortrait"];
      user.sex = data[@"sex"];
      user.goldBalance = data[@"goldBalance"];
      user.balance = data[@"balance"];
      user.province = data[@"province"];
      user.city = data[@"city"];
      user.area = data[@"area"];
      user.address = data[@"address"];
      user.birthdate = data[@"birthdate"];
      user.token = data[@"token"];
      user.invitationCode = data[@"invitationCode"];
      user.status = data[@"status"];
      user.imLoginSign = data[@"imLoginSign"];
        
      NSInteger status = ((NSNumber *)data[@"status"]).integerValue;
      [[XYUserService service] loginUser:user isNeedPerfect:status == -2 withBlock:^(BOOL success) {
          if (success) {
            if (block) block(status == -2,error);
          } else {
              if (block) block(NO,ClientExceptionSave());
          }
      }];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationLogin" object:nil];
    };
    [api start];
}

- (void)fastLoginWithToken:(NSString *)token block:(void(^)(BOOL isNeedPerfect, XYError * error))block {
  XYFastLoginAPI *api = [[XYFastLoginAPI alloc] initWithToken:token];
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
        if (error || !data) {
            if (block) block(NO,error);
            return;
        }
      XYUserInfo *user = [[XYUserInfo alloc] init];
      user.isFirst = data[@"isFirst"];
      user.mobile = data[@"mobile"];
      user.userId = data[@"userId"];
      user.realName = data[@"realName"];
      user.nickName = data[@"nickName"];
      user.headPortrait = data[@"headPortrait"];
      user.sex = data[@"sex"];
      user.goldBalance = data[@"goldBalance"];
      user.province = data[@"province"];
      user.city = data[@"city"];
      user.area = data[@"area"];
      user.address = data[@"address"];
      user.birthdate = data[@"birthdate"];
      user.token = data[@"token"];
      user.invitationCode = data[@"invitationCode"];
      user.status = data[@"status"];
      user.imLoginSign = data[@"imLoginSign"];
        
      NSInteger status = ((NSNumber *)data[@"status"]).integerValue;
      [[XYUserService service] loginUser:user isNeedPerfect:status == -2 withBlock:^(BOOL success) {
          if (success) {
            if (block) block(status == -2,error);
          } else {
              if (block) block(NO,ClientExceptionSave());
          }
      }];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationLogin" object:nil];
    };
    [api start];
}

- (void)wechatLoginWithToken:(NSString *)token block:(void(^)(BOOL isFirst, BOOL isNeedPerfect, NSString *thirdId, XYError * error))block {
  XYWechatLoginAPI *api = [[XYWechatLoginAPI alloc] initWithToken:token];
    api.filterCompletionHandler = ^(id  _Nullable oriData, XYError * _Nullable error) {
        if (error || !oriData) {
            if (block) block(NO, NO,nil, error);
            return;
        }
      NSNumber *isFirst = oriData[@"isFirst"];
      NSString *thirdId = oriData[@"thirdId"];
      NSDictionary *data = oriData[@"loginResp"];
      if (!data || [data isKindOfClass:[NSNull class]]) {
        if (block) block(isFirst.integerValue == 1, YES, thirdId,  nil);
        return;
      }
      XYUserInfo *user = [[XYUserInfo alloc] init];
      user.isFirst = isFirst;
      user.mobile = data[@"mobile"];
      user.userId = data[@"userId"];
      user.realName = data[@"realName"];
      user.nickName = data[@"nickName"];
      user.headPortrait = data[@"headPortrait"];
      user.sex = data[@"sex"];
      user.goldBalance = data[@"goldBalance"];
      user.province = data[@"province"];
      user.city = data[@"city"];
      user.area = data[@"area"];
      user.address = data[@"address"];
      user.birthdate = data[@"birthdate"];
      user.token = data[@"token"];
      user.invitationCode = data[@"invitationCode"];
      user.status = data[@"status"];
      user.imLoginSign = data[@"imLoginSign"];
        
      NSInteger status = ((NSNumber *)data[@"status"]).integerValue;
      [[XYUserService service] loginUser:user isNeedPerfect:status == -2 withBlock:^(BOOL success) {
          if (success) {
            if (block) block(isFirst.integerValue == 1 ,status == -2,thirdId,error);
          } else {
              if (block) block(NO, NO,thirdId,ClientExceptionSave());
          }
      }];
      
      [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationLogin" object:nil];
      
    };
    [api start];
}

- (void)QQLoginWithToken:(NSString *)token block:(void(^)(BOOL isFirst, BOOL isNeedPerfect, NSString *thirdId, XYError * error))block {
  XYQQLoginAPI *api = [[XYQQLoginAPI alloc] initWithToken:token];
    api.filterCompletionHandler = ^(id  _Nullable oriData, XYError * _Nullable error) {
        if (error || !oriData) {
            if (block) block(NO, NO, nil,error);
            return;
        }
      NSNumber *isFirst = oriData[@"isFirst"];
      NSString *thirdId = oriData[@"thirdId"];
      NSDictionary *data = oriData[@"loginResp"];
      if (!data || [data isKindOfClass:[NSNull class]]) {
        if (block) block(isFirst.integerValue == 1, YES,thirdId, nil);
        return;
      }
      
      XYUserInfo *user = [[XYUserInfo alloc] init];
      user.isFirst = isFirst;
      user.mobile = data[@"mobile"];
      user.userId = data[@"userId"];
      user.realName = data[@"realName"];
      user.nickName = data[@"nickName"];
      user.headPortrait = data[@"headPortrait"];
      user.sex = data[@"sex"];
      user.goldBalance = data[@"goldBalance"];
      user.province = data[@"province"];
      user.city = data[@"city"];
      user.area = data[@"area"];
      user.address = data[@"address"];
      user.birthdate = data[@"birthdate"];
      user.token = data[@"token"];
      user.invitationCode = data[@"invitationCode"];
      user.status = data[@"status"];
      user.imLoginSign = data[@"imLoginSign"];
        
      NSInteger status = ((NSNumber *)data[@"status"]).integerValue;
      [[XYUserService service] loginUser:user isNeedPerfect:status == -2 withBlock:^(BOOL success) {
          if (success) {
            if (block) block(isFirst.integerValue == 1 ,status == -2,thirdId,error);
          } else {
              if (block) block(NO, NO,thirdId,ClientExceptionSave());
          }
      }];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotificationLogin" object:nil];
    };
    [api start];
}

#pragma mark - getter
- (XYLoginModel *)loginModel {
    if (!_loginModel) {
        _loginModel = [[XYLoginModel alloc] init];
    }
    return _loginModel;
}
@end
