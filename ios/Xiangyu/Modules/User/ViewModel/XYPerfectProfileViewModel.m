//
//  XYPerfectProfileViewModel.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/7.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYPerfectProfileViewModel.h"
#import "NSString+Checker.h"
#import "XYUserConst.h"
#import "XYPrefectProfileDataManager.h"

@interface XYPerfectProfileViewModel ()

@property (nonatomic,strong,readwrite) XYPerfectProfileModel *perfectProfileModel;

@property (nonatomic,strong) XYPrefectProfileDataManager *dataManager;

@end
@implementation XYPerfectProfileViewModel
- (instancetype)init {
    if (self = [super init]) {
        self.perfectProfileModel = self.dataManager.perfectProfileModel;
        
        [self binding];
    }
    return self;
}
- (void)binding {
    @weakify(self);
  [self.KVOControllerNonRetaining XY_observe:self.perfectProfileModel keyPaths:@[FBKVOClassKeyPath(XYPerfectProfileModel, sex) , FBKVOClassKeyPath(XYPerfectProfileModel, nickName),FBKVOClassKeyPath(XYPerfectProfileModel, area)
  ] block:^(NSString *keyPath, NSString * value) {
      @strongify(self);
      self.nextStepEnable = [NSNumber numberWithBool:
                                 self.perfectProfileModel.sex &&
                                 self.perfectProfileModel.nickName.isNotBlank &&
                                self.perfectProfileModel.area.isNotBlank
                             ];
  }];
  
  [self.KVOControllerNonRetaining XY_observe:self.perfectProfileModel keyPaths:@[FBKVOClassKeyPath(XYPerfectProfileModel, birthdate) , FBKVOClassKeyPath(XYPerfectProfileModel, oneIndustry),FBKVOClassKeyPath(XYPerfectProfileModel, twoIndustry)
  ] block:^(NSString *keyPath, NSString * value) {
      @strongify(self);
      self.submitEnable = [NSNumber numberWithBool:
                             self.perfectProfileModel.birthdate.isNotBlank &&
                                 self.perfectProfileModel.oneIndustry &&
                                self.perfectProfileModel.twoIndustry
                             ];
  }];
}

- (void)nextStepCommand {
    
    if (!self.perfectProfileModel.sex) {
        self.oneStepVerifyErrorMsg = XYLogin_VerifySexNULLError;
        return;
    }
    
    if (!self.perfectProfileModel.nickName.isNotBlank) {
        self.oneStepVerifyErrorMsg = XYLogin_VerifyNickNameNULLError;
        return;
    }
    
    if (![self.perfectProfileModel.nickName isMatchingNickname]) {
        self.oneStepVerifyErrorMsg = XYLogin_VerifyNickNameError;
        return;
    }
    
    self.oneStepVerifyErrorMsg = @"";
    self.successNextStep = @(YES);
}

- (void)submitCommand {
  
  if (!self.perfectProfileModel.sex) {
      self.oneStepVerifyErrorMsg = XYLogin_VerifySexNULLError;
      return;
  }
  
  if (!self.perfectProfileModel.nickName.isNotBlank) {
      self.oneStepVerifyErrorMsg = XYLogin_VerifyNickNameNULLError;
      return;
  }
  
  if (![self.perfectProfileModel.nickName isMatchingNickname]) {
      self.oneStepVerifyErrorMsg = XYLogin_VerifyNickNameError;
      return;
  }
  
  if (!self.perfectProfileModel.birthdate.isNotBlank) {
      self.twoStepVerifyErrorMsg = @"请选择生日";
      return;
  }
  
  if (!self.perfectProfileModel.oneIndustry || !self.perfectProfileModel.twoIndustry) {
      self.twoStepVerifyErrorMsg = @"请选择行业";
      return;
  }
  
  self.twoStepVerifyErrorMsg = @"";
  self.executing = [NSNumber numberWithBool:YES];
  @weakify(self);
  [self.dataManager submitProfileWithBlock:^(id  _Nullable data, XYError * _Nullable error) {
      @strongify(self);
      self.executing = [NSNumber numberWithBool:NO];
      if (error) {
          self.exceptionMsg = error.msg;
          self.exceptionCode = error.code;
          self.successSubmit = [NSNumber numberWithBool:NO];
      }
      if (data) {
          self.successSubmit = [NSNumber numberWithBool:YES];
      }
  }];
}

#pragma mark - getter
- (XYPrefectProfileDataManager *)dataManager {
    if (!_dataManager) {
        _dataManager = [[XYPrefectProfileDataManager alloc] init];
    }
    return _dataManager;
}
@end
