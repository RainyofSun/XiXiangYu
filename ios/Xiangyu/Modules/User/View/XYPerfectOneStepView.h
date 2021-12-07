//
//  XYPerfectOneStepView.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/23.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDefaultButton.h"
#import "XYInputNicknameView.h"
#import "XYSelectGenderView.h"
#import "XYChooseItemView.h"
#import "XYInputAddressView.h"

@interface XYPerfectOneStepView : UIView

@property (nonatomic, copy) NSString *provinceCode;

@property (nonatomic, copy) NSString *cityCode;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *townCode;

@property (nonatomic, copy) NSString *dwellProvinceCode;

@property (nonatomic, copy) NSString *dwellCityCode;

@property (nonatomic, copy) NSString *dwellCode;

@property (nonatomic,copy) NSString *birthdate;

@property (nonatomic,copy) NSString *oneIndustry;

@property (nonatomic,copy) NSString *twoIndustry;

@property (nonatomic,weak) UIViewController *targetVc;

@property (nonatomic,strong) XYDefaultButton *submitButton;

@property (nonatomic,strong) XYInputNicknameView *nicknameView;

@property (nonatomic,strong) XYSelectGenderView *selectGenderView;

//@property (nonatomic,strong) XYInputAddressView *addressView;


@end
