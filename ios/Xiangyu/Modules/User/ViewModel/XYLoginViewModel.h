//
//  XYLoginViewModel.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseViewModel.h"
#import "XYLoginModel.h"

@interface XYLoginViewModel : XYBaseViewModel

@property (nonatomic,strong,readonly) XYLoginModel *loginModel;

@property (nonatomic,strong) NSNumber * checkcodeButtonEnable;

@property (nonatomic,copy) NSString *verifyMobileErrorMsg;

@property (nonatomic,strong) NSNumber *successVerify;

@property (nonatomic,strong) NSNumber *fetchCheckcodeExecuting;



@property (nonatomic,strong) NSNumber * loginButtonEnable;

@property (nonatomic,copy) NSString *verifyCheckCodeErrorMsg;

@property (nonatomic,strong) NSNumber * directAccessFlag;

@property (nonatomic,strong) NSNumber *loginExecuting;


@property (nonatomic,strong) NSNumber * needPerfectFlag;

- (void)checkCodeCommand;

- (void)loginCommand;

- (void)fastLoginWithToken:(NSString *)token block:(void(^)(BOOL isNeedPerfect, XYError * error))block;

- (void)wechatLoginWithToken:(NSString *)token block:(void(^)(BOOL isFirst, BOOL isNeedPerfect, NSString *thirdId, XYError * error))block;

- (void)qqLoginWithToken:(NSString *)token block:(void(^)(BOOL isFirst, BOOL isNeedPerfect, NSString *thirdId, XYError * error))block;

@end
