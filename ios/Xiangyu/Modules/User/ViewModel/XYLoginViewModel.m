//
//  XYLoginViewModel.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYLoginViewModel.h"
#import "NSString+Checker.h"
#import "XYUserConst.h"
#import "XYLoginDataManager.h"

@interface XYLoginViewModel ()

@property (nonatomic,strong,readwrite) XYLoginModel *loginModel;

@property (nonatomic,strong) XYLoginDataManager *dataManager;
@end
@implementation XYLoginViewModel
- (instancetype)init {
    if (self = [super init]) {
        @weakify(self);
        [self.dataManager fetchDefaultUserWithBlock:^(XYLoginModel *loginModel) {
            @strongify(self);
            self.loginModel = loginModel;
            [self binding];
        }];
    }
    return self;
}
- (void)binding {
    @weakify(self);
    [self.KVOControllerNonRetaining XY_observe:self.loginModel keyPaths:@[FBKVOClassKeyPath(XYLoginModel, mobile),FBKVOClassKeyPath(XYLoginModel, checkCode)] block:^(NSString *keyPath, NSString * value) {
        @strongify(self);
      if ([keyPath isEqualToString:@"mobile"]) {
        self.checkcodeButtonEnable = [NSNumber numberWithBool:self.loginModel.mobile.isNotBlank];
      } else {
        if (value.length == 6) {
          [self loginCommand];
        }
      }
    }];
}

- (void)checkCodeCommand {
 
  if (!self.loginModel.mobile.isNotBlank) {
      self.verifyMobileErrorMsg = XYLogin_VerifyMobileNULLError;
      return;
  }
  
  if (![self.loginModel.mobile isMatchingPhoneNumber]) {
      self.verifyMobileErrorMsg = XYLogin_VerifyMobileError;
      return;
  }
    
  self.verifyMobileErrorMsg = @"";
  self.fetchCheckcodeExecuting = [NSNumber numberWithBool:YES];
    @weakify(self);
  [self.dataManager fetchCheckcodeWithBlock:^(XYError * _Nullable error) {
    @strongify(self);
    self.fetchCheckcodeExecuting = [NSNumber numberWithBool:NO];
    if (error) {
      self.exceptionMsg = error.msg;
      self.exceptionCode = error.code;
    } else {
      self.successVerify = [NSNumber numberWithBool:YES];
    }
  }];
}

- (void)loginCommand {
 
  if (!self.loginModel.mobile.isNotBlank) {
      self.verifyMobileErrorMsg = XYLogin_VerifyMobileNULLError;
      return;
  }
  
  if (![self.loginModel.mobile isMatchingPhoneNumber]) {
      self.verifyMobileErrorMsg = XYLogin_VerifyMobileError;
      return;
  }
  
  if (!self.loginModel.checkCode.isNotBlank) {
      self.verifyCheckCodeErrorMsg = XYLogin_VerifyCodeNULLError;
      return;
  }
  
  if (![self.loginModel.checkCode isMatchingCheckCode]) {
      self.verifyCheckCodeErrorMsg = XYLogin_VerifyCodeError;
      return;
  }
  
  self.verifyCheckCodeErrorMsg = @"";
  
  self.loginExecuting = [NSNumber numberWithBool:YES];
    @weakify(self);
  [self.dataManager loginWithBlock:^(BOOL isNeedPerfect, XYError * _Nullable error) {
    @strongify(self);
    self.loginExecuting = [NSNumber numberWithBool:NO];
    if (error) {
      self.exceptionMsg = error.msg;
      self.exceptionCode = error.code;
      return;
    }
    
    if (isNeedPerfect) {
      self.needPerfectFlag = [NSNumber numberWithBool:YES];
    } else {
      self.directAccessFlag = [NSNumber numberWithBool:YES];
    }
  }];
}

- (void)fastLoginWithToken:(NSString *)token block:(void(^)(BOOL isNeedPerfect, XYError * error))block {
  [self.dataManager fastLoginWithToken:token block:block];
}

- (void)wechatLoginWithToken:(NSString *)token block:(void(^)(BOOL isFirst, BOOL isNeedPerfect, NSString *thirdId, XYError * error))block {
  [self.dataManager wechatLoginWithToken:token block:block];
}

- (void)qqLoginWithToken:(NSString *)token block:(void(^)(BOOL isFirst, BOOL isNeedPerfect, NSString *thirdId, XYError * error))block {
  [self.dataManager QQLoginWithToken:token block:block];
}

#pragma mark - getter
- (XYLoginDataManager *)dataManager {
    if (!_dataManager) {
        _dataManager = [[XYLoginDataManager alloc] init];
    }
    return _dataManager;
}
@end
