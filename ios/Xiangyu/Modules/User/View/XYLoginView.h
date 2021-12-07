//
//  XYLoginView.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/13.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYInputTextField.h"
#import "XYDefaultButton.h"

@interface XYLoginView : UIView

@property (nonatomic,strong) XYInputTextField *accountTextField;

@property (nonatomic,strong) XYDefaultButton *submitButton;

//@property (nonatomic,strong) UIButton *fastLoginButton;

@property (nonatomic,strong) UIButton *wechatButton;

@property (nonatomic,strong) UIButton *qqButton;

@property (nonatomic,strong) UIButton *weiboButton;

@property (nonatomic,assign) BOOL OnlineSwitch;


@property (strong, nonatomic) YYTextView *textView;

@end
