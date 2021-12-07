//
//  XYSelectGenderView.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/23.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYSelectGenderView.h"
#import "UIButton+Extension.h"

@interface XYSelectGenderView ()

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UIButton *maleButton;

@property (nonatomic,strong) UIButton *femaleButton;

@end

@implementation XYSelectGenderView
{
    UIButton *selectedBtn_;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      [self addSubview:self.titleLable];
         [self addSubview:self.maleButton];
         [self addSubview:self.femaleButton];
        [self addConstraints];
    }
    return self;
}
#pragma mark - event
- (void)selectGender:(UIButton *)sender {
  [[IQKeyboardManager sharedManager] resignFirstResponder];
  selectedBtn_.selected = NO;
  sender.selected = YES;
  selectedBtn_ = sender;
  self.sex = @(selectedBtn_.tag);
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.maleButton horizontalCenterImageAndTitle:11];
    [self.femaleButton horizontalCenterImageAndTitle:11];
}
- (void)addConstraints {
    
    [self.titleLable remakeConstraints:^(MASConstraintMaker *make) {
      make.left.top.bottom.equalTo(self);
      make.width.mas_equalTo(42);
    }];
    
    [self.maleButton remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.titleLable.mas_right).offset(46);
        make.centerY.equalTo(self);
    }];

    [self.femaleButton remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maleButton.mas_right).offset(40);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - getter

- (UILabel *)titleLable {
    if (!_titleLable) {
      _titleLable = [[UILabel alloc] init];
      _titleLable.font = AdaptedFont(14);
      _titleLable.numberOfLines = 0;
      NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@"性别"];
    //  [attr addAttributes:@{NSForegroundColorAttributeName:ColorHex(@"#FF4144")} range:NSMakeRange(0, 1)];
      [attr addAttributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_222222)} range:NSMakeRange(0, 2)];
      _titleLable.attributedText = attr;
    }
    return _titleLable;
}

- (UIButton *)maleButton {
    if (!_maleButton) {
      _maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
      [_maleButton setTitle:@"男" forState:UIControlStateNormal];
      [_maleButton setTitleColor:ColorHex(XYTextColor_666666) forState:UIControlStateNormal];
      [_maleButton setImage:[UIImage imageNamed:@"icon_30_boy_def"] forState:UIControlStateNormal];
      [_maleButton setImage:[UIImage imageNamed:@"icon_30_boy_sel"] forState:UIControlStateSelected];
      _maleButton.titleLabel.font = AdaptedFont(16);
      [_maleButton addTarget:self action:@selector(selectGender:) forControlEvents:UIControlEventTouchUpInside];
      _maleButton.tag = 1;
    }
    return _maleButton;
}

- (UIButton *)femaleButton {
    if (!_femaleButton) {
        _femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_femaleButton setTitle:@"女" forState:UIControlStateNormal];
        [_femaleButton setTitleColor:ColorHex(XYTextColor_666666) forState:UIControlStateNormal];
        [_femaleButton setImage:[UIImage imageNamed:@"icon_30_girl_def"] forState:UIControlStateNormal];
      [_femaleButton setImage:[UIImage imageNamed:@"icon_30_girl_sel"] forState:UIControlStateSelected];
        _femaleButton.titleLabel.font = AdaptedFont(16);
        [_femaleButton addTarget:self action:@selector(selectGender:) forControlEvents:UIControlEventTouchUpInside];
        _femaleButton.tag = 2;
    }
    return _femaleButton;
}
@end
