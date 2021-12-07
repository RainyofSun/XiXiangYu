//
//  XYBindPhoneView.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/24.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYInputTextField.h"
#import "XYDefaultButton.h"

typedef NS_ENUM(NSInteger, BindPhoneType) {
  BindPhoneType_Wechat = 0,
  BindPhoneType_QQ,
};
@interface XYBindPhoneView : UIView

@property (nonatomic,assign) BindPhoneType bindType;

@property (nonatomic,strong) UILabel *nameLable;

@property (nonatomic,strong) XYInputTextField *accountTextField;

@property (nonatomic,strong) XYDefaultButton *submitButton;

@end
