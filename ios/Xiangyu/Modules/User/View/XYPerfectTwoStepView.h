//
//  XYPerfectTwoStepView.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/17.
//

#import <UIKit/UIKit.h>
#import "XYDefaultButton.h"

@interface XYPerfectTwoStepView : UIView

@property (nonatomic,strong) NSNumber *salaryStart;

@property (nonatomic,strong) NSNumber *salaryEnd;

@property (nonatomic,strong) NSNumber *education;

@property (nonatomic,strong) NSNumber *height;

@property (nonatomic,copy) NSString *birthdate;

@property (nonatomic,copy) NSString *oneIndustry;

@property (nonatomic,copy) NSString *twoIndustry;

@property (nonatomic,weak) UIViewController *targetVc;

@property (nonatomic,strong) XYDefaultButton *submitButton;

@end
