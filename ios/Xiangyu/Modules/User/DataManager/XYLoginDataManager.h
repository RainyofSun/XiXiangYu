//
//  XYLoginDataManager.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYLoginModel.h"
@class XYUserInfo;

@interface XYLoginDataManager : NSObject

@property (nonatomic,strong,readonly) XYLoginModel *loginModel;

- (void)fetchDefaultUserWithBlock:(void(^)(XYLoginModel *loginModel))block;

- (void)fetchCheckcodeWithBlock:(void(^)(XYError * error))block;

- (void)loginWithBlock:(void(^)(BOOL isNeedPerfect, XYError * error))block;

- (void)fastLoginWithToken:(NSString *)token block:(void(^)(BOOL isNeedPerfect, XYError * error))block;

- (void)wechatLoginWithToken:(NSString *)token block:(void(^)(BOOL isFirst, BOOL isNeedPerfect, NSString *thirdId, XYError * error))block;

- (void)QQLoginWithToken:(NSString *)token block:(void(^)(BOOL isFirst, BOOL isNeedPerfect, NSString *thirdId, XYError * error))block;

@end
