//
//  XYBindPhoneView.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/24.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBindPhoneView.h"

@interface XYBindPhoneView ()

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,strong) UILabel *subTitleLable;

@end

@implementation XYBindPhoneView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorHex(XYThemeColor_B);
        [self addSubviews];
    }
    return self;
}
- (void)addSubviews {
    [self addSubview:self.iconImageView];
    [self addSubview:self.nameLable];
    [self addSubview:self.subTitleLable];
    [self addSubview:self.accountTextField];
    [self addSubview:self.submitButton];
}

- (void)setBindType:(BindPhoneType)bindType {
  _bindType = bindType;
  _iconImageView.image = [UIImage imageNamed:bindType == BindPhoneType_Wechat ? @"icon_40_weixing" : @"icon_40_qq"];
  _subTitleLable.text = bindType == BindPhoneType_Wechat ? @"微信登录成功，请绑定您的手机号码" : @"QQ登录成功，请绑定您的手机号码";
}

- (void)updateConstraints {
    [self.iconImageView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(22);
      make.left.equalTo(self).with.offset(88);
      make.width.height.mas_equalTo(40);
    }];
    
    [self.nameLable remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right);
        make.centerY.equalTo(self.iconImageView);
    }];
    
    [self.subTitleLable remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(12);
        make.centerX.equalTo(self);
    }];
    
    [self.accountTextField remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLable.mas_bottom).with.offset(65);
        make.left.equalTo(self.mas_left).with.offset(40);
        make.right.equalTo(self.mas_right).with.offset(-40);
        make.height.mas_equalTo(AdaptedHeight(52));
    }];
    
    [self.submitButton remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTextField.mas_bottom).with.offset(57);
        make.left.right.equalTo(self.accountTextField);
        make.height.mas_equalTo(AdaptedHeight(48));
    }];
    [super updateConstraints];
}
#pragma mark - getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}
- (UILabel *)nameLable {
    if (!_nameLable) {
      _nameLable = [[UILabel alloc] init];
      _nameLable.font = AdaptedFont(32);
      _nameLable.textColor = ColorHex(XYTextColor_222222);
    }
    return _nameLable;
}
- (UILabel *)subTitleLable {
    if (!_subTitleLable) {
        _subTitleLable = [[UILabel alloc] init];
        _subTitleLable.font = AdaptedFont(14);
        _subTitleLable.textColor = ColorHex(XYTextColor_666666);
    }
    return _subTitleLable;
}

- (XYDefaultButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [XYDefaultButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"手机验证码" forState:UIControlStateNormal];
    }
    return _submitButton;
}
- (XYInputTextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[XYInputTextField alloc] init];
        _accountTextField.placeholder = @"请输入手机号";
        _accountTextField.shouldClear = YES;
      _accountTextField.shoundBoard = NO;
        _accountTextField.maxInputNum = 11;
        _accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _accountTextField;
}
@end
