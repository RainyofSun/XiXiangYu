//
//  XYPerfectProfileViewModel.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/7.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseViewModel.h"
#import "XYPerfectProfileModel.h"

@interface XYPerfectProfileViewModel : XYBaseViewModel

@property (nonatomic,strong,readonly) XYPerfectProfileModel *perfectProfileModel;

///第一步
@property (nonatomic,strong) NSNumber * nextStepEnable;

@property (nonatomic,copy) NSString *oneStepVerifyErrorMsg;

@property (nonatomic,strong) NSNumber * successNextStep;

- (void)nextStepCommand;



///第二步
@property (nonatomic,strong) NSNumber * submitEnable;

@property (nonatomic,copy) NSString *twoStepVerifyErrorMsg;

@property (nonatomic,strong) NSNumber * successSubmit;

- (void)submitCommand;

@end
