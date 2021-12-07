//
//  XYPrefectProfileDataManager.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/7.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYPrefectProfileDataManager.h"
#import "XYPrefectProfileAPI.h"
#import "XYUserService.h"

@interface XYPrefectProfileDataManager ()

@property (nonatomic,strong,readwrite) XYPerfectProfileModel *perfectProfileModel;

@end

@implementation XYPrefectProfileDataManager

- (void)submitProfileWithBlock:(XYNetworkRespone)block {
//  if (![XYUserService service].isLogin) {
//    if (block) block(nil,ClientExceptionNotLogin());
//    return;
//  }
  
  XYPrefectProfileAPI *api = [[XYPrefectProfileAPI alloc] initWithProfileParams:self.perfectProfileModel userId:[XYUserService service].fetchLoginUser.userId];
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
        if (error) {
            if (block) block(nil,error);
            return;
        }
        if (block) block(data,error);
    };
    [api start];
}

#pragma mark - getter
- (XYPerfectProfileModel *)perfectProfileModel {
    if (!_perfectProfileModel) {
        _perfectProfileModel = [[XYPerfectProfileModel alloc] init];
    }
    return _perfectProfileModel;
}

@end
