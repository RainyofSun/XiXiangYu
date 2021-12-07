//
//  FSBaseViewController.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "XYTimelineRemarkController.h"
#import "TXLimitedTextField.h"

@interface XYTimelineRemarkController ()

@property (nonatomic,strong) UILabel *nameTitleLable;

@property (nonatomic,strong) TXLimitedTextField *nameTextField;

@property (nonatomic,strong) UIView *line1;

@property (nonatomic,strong) UILabel *descTitleLable;

@property (nonatomic,strong) TXLimitedTextField *descTextField;

@property (nonatomic,strong) UIView *line2;

@end

@implementation XYTimelineRemarkController

- (void)viewDidLoad {
    [super viewDidLoad];

  self.view.backgroundColor = [UIColor whiteColor];
  
  [self setupNavBar];
  
  [self setupSubviews];

}

#pragma - action
- (void)submit {
//  if (self.dataManager.model.isFriends) {
//    TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
//    data.conversationID = [NSString stringWithFormat:@"c2c_%@",self.dataManager.model.userId];
//    data.userID = self.dataManager.model.userId.stringValue;
//    data.title = self.dataManager.model.nickName;
//    ChatViewController *chat = [[ChatViewController alloc] init];
//    chat.conversationData = data;
//    [self cyl_pushViewController:chat animated:YES];
//  } else {
//    XYShowLoading;
//    [self.dataManager addFriendWithBlock:^(NSString *errorMsg) {
//      XYHiddenLoading;
//      if (errorMsg.isNotBlank) {
//        XYToastText(errorMsg);
//      } else {
//        XYToastText(@"等待对方验证");
//      }
//    }];
//  }
}

#pragma mark UI

- (void)setupSubviews {
  [self.view addSubview:self.nameTitleLable];
  [self.view addSubview:self.nameTextField];
  [self.view addSubview:self.line1];
  [self.view addSubview:self.descTitleLable];
  [self.view addSubview:self.descTextField];
  [self.view addSubview:self.line2];
  
  [self.nameTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(16);
    make.left.mas_equalTo(16);
    make.right.mas_equalTo(-16);
    make.height.mas_equalTo(18);
  }];
  
  [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.nameTitleLable.mas_bottom).offset(15);
    make.left.mas_equalTo(self.nameTitleLable);
    make.right.mas_equalTo(self.nameTitleLable);
    make.height.mas_equalTo(24);
  }];
  
  [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.nameTextField.mas_bottom).offset(12);
    make.left.mas_equalTo(self.nameTitleLable);
    make.right.mas_equalTo(self.view);
    make.height.mas_equalTo(0.5);
  }];
  
  [self.descTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.line1.mas_bottom).offset(16);
    make.left.mas_equalTo(16);
    make.right.mas_equalTo(-16);
    make.height.mas_equalTo(18);
  }];
  
  [self.descTextField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.nameTitleLable.mas_bottom).offset(15);
    make.left.mas_equalTo(self.nameTitleLable);
    make.right.mas_equalTo(self.nameTitleLable);
    make.height.mas_equalTo(24);
  }];
  
  [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.mas_equalTo(self.nameTextField.mas_bottom).offset(12);
    make.left.mas_equalTo(self.nameTitleLable);
    make.right.mas_equalTo(self.view);
    make.height.mas_equalTo(0.5);
  }];
}

- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
  [doneBtn setTitleColor:ColorHex(XYTextColor_FE2D63) forState:UIControlStateNormal];
  [doneBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
  
  self.gk_navTitle = @"备注信息";
}

- (UILabel *)nameTitleLable {
  if (!_nameTitleLable) {
    _nameTitleLable = [[UILabel alloc] init];
    _nameTitleLable.textColor = ColorHex(XYTextColor_666666);
    _nameTitleLable.font = AdaptedFont(12);
    _nameTitleLable.text = @"备注姓名";
  }
  return _nameTitleLable;
}

- (UILabel *)descTitleLable {
  if (!_descTitleLable) {
    _descTitleLable = [[UILabel alloc] init];
    _descTitleLable.textColor = ColorHex(XYTextColor_666666);
    _descTitleLable.font = AdaptedFont(12);
    _descTitleLable.text = @"描述";
  }
  return _descTitleLable;
}

- (UIView *)line1 {
  if (!_line1) {
    _line1 = [[UIView alloc] init];
    _line1.backgroundColor = ColorHex(XYThemeColor_E);
  }
  return _line1;
}

- (UIView *)line2 {
  if (!_line2) {
    _line2 = [[UIView alloc] init];
    _line2.backgroundColor = ColorHex(XYThemeColor_E);
  }
  return _line2;
}

- (TXLimitedTextField *)nameTextField {
    if (!_nameTextField) {
      _nameTextField = [[TXLimitedTextField alloc] init];
      _nameTextField.textColor = ColorHex(XYTextColor_222222);
      _nameTextField.font = AdaptedFont(15);
      _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      _nameTextField.limitedNumber = 20;
      _nameTextField.placeholder = @"请输入备注名";
    }
    return _nameTextField;
}

- (TXLimitedTextField *)descTextField {
    if (!_descTextField) {
      _descTextField = [[TXLimitedTextField alloc] init];
      _descTextField.textColor = ColorHex(XYTextColor_222222);
      _descTextField.font = AdaptedFont(15);
      _descTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      _descTextField.placeholder = @"添加更多备注信息";
    }
    return _descTextField;
}

@end
