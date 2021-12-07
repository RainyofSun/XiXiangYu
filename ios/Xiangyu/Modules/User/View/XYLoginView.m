//
//  XYLoginView.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/13.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYLoginView.h"
#import "XYPlatformService.h"
#import "WebViewController.h"
@interface XYLoginView ()

//@property (nonatomic,strong) UILabel *titleLable;
//
//@property (nonatomic,strong) UILabel *subTitleLable;

@property(nonatomic,strong)UIImageView *topImage;

@property (nonatomic,strong) UIView *leftTitleViewLine;

@property (nonatomic,strong) UILabel *thirdTipsLable;

@property (nonatomic,strong) UIView *rightTitleViewLine;

@end

@implementation XYLoginView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      self.backgroundColor = [UIColor clearColor];
      [self addSubviews];
      [self layoutSubview];
    }
    return self;
}

- (void)setOnlineSwitch:(BOOL)OnlineSwitch {
  _OnlineSwitch = OnlineSwitch;
//  self.subTitleLable.hidden = OnlineSwitch;
  
  self.textView.hidden = !OnlineSwitch;
}

- (void)addSubviews {
    //[self addSubview:self.titleLable];
    //[self addSubview:self.subTitleLable];
  
  [self addSubview:self.topImage];
  
    [self addSubview:self.accountTextField];
    [self addSubview:self.submitButton];
//  [self addSubview:self.fastLoginButton];
    
//    [self addSubview:self.leftTitleViewLine];
//    [self addSubview:self.thirdTipsLable];
//    [self addSubview:self.rightTitleViewLine];
//
//    [self addSubview:self.wechatButton];
//    [self addSubview:self.qqButton];
//    [self addSubview:self.weiboButton];
}
- (void)layoutSubview {

//    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.left.right.equalTo(self);
//      make.top.equalTo(self.mas_top).with.offset(22);
//      make.height.mas_equalTo(40);
//    }];
//
//  [self.subTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.left.right.equalTo(self);
//    make.top.equalTo(self.titleLable.mas_bottom).with.offset(12);
//    make.height.mas_equalTo(18);
//  }];
  
  [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self).offset(AutoSize(33));
    make.size.mas_equalTo(CGSizeMake(AutoSize(180), AutoSize(100)));
  }];
  
  

    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(AutoSize(38));
        make.right.equalTo(self.mas_right).with.offset(-AutoSize(38));
        make.top.equalTo(self.topImage.mas_bottom).with.offset(40);
        make.height.mas_equalTo(AutoSize(44));
    }];

    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(AutoSize(40));
        make.right.equalTo(self.mas_right).with.offset(-AutoSize(40));
        make.top.equalTo(self.accountTextField.mas_bottom).with.offset(56);
        make.height.mas_equalTo(AutoSize(48));
    }];
  
  
  [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.mas_left).with.offset(30);
      make.right.equalTo(self.mas_right).with.offset(-30);
      make.top.equalTo(self.submitButton.mas_bottom).with.offset(20);
      make.height.mas_equalTo(AdaptedHeight(48));
  }];
  
  
//  [self.fastLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.left.equalTo(self.mas_left).with.offset(40);
//      make.right.equalTo(self.mas_right).with.offset(-40);
//      make.top.equalTo(self.submitButton.mas_bottom).with.offset(20);
//      make.height.mas_equalTo(AdaptedHeight(48));
//  }];
    
//    [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom).with.offset(-(20 + SafeAreaTop()));
//        make.centerX.equalTo(self);
//      make.width.height.mas_equalTo(40);
//    }];
//
//    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.qqButton);
//        make.right.equalTo(self.qqButton.mas_left).with.offset(-40);
//      make.width.height.mas_equalTo(40);
//    }];
//
//    [self.weiboButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.qqButton);
//        make.left.equalTo(self.qqButton.mas_right).with.offset(40);
//      make.width.height.mas_equalTo(40);
//    }];
//
//    [self.thirdTipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.bottom.equalTo(self.qqButton.mas_top).with.offset(-20);
//    }];
//
//    [self.leftTitleViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.thirdTipsLable);
//        make.right.equalTo(self.thirdTipsLable.mas_left).with.offset(-13);
//        make.width.mas_equalTo(AdaptedWidth(50));
//        make.height.mas_equalTo(AdaptedHeight(2));
//    }];
//
//    [self.rightTitleViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.thirdTipsLable);
//        make.left.equalTo(self.thirdTipsLable.mas_right).with.offset(13);
//        make.width.mas_equalTo(AdaptedWidth(50));
//        make.height.mas_equalTo(AdaptedHeight(2));
//    }];
    
}
#pragma mark - getter


-(UIImageView *)topImage{
  if (!_topImage) {
    _topImage = [LSHControl createImageViewWithImageName:@"pic _100_yindao"];
  }
  return _topImage;
}

//- (UILabel *)titleLable {
//    if (!_titleLable) {
//        _titleLable = [[UILabel alloc] init];
//        _titleLable.font = AdaptedFont(32);
//        _titleLable.textColor = ColorHex(XYTextColor_222222);
//        _titleLable.text = @"欢迎来到喜乡遇";
//      _titleLable.textAlignment = NSTextAlignmentCenter;
//    }
//    return _titleLable;
//}
//
//- (UILabel *)subTitleLable {
//    if (!_subTitleLable) {
//        _subTitleLable = [[UILabel alloc] init];
//        _subTitleLable.font = AdaptedFont(14);
//        _subTitleLable.textColor = ColorHex(XYTextColor_666666);
//        _subTitleLable.text = @"如果手机号码未注册，将自动为您注册";
//      _subTitleLable.textAlignment = NSTextAlignmentCenter;
//      _subTitleLable.hidden = YES;
//    }
   // return _subTitleLable;
//}

- (XYInputTextField *)accountTextField {
    if (!_accountTextField) {
        _accountTextField = [[XYInputTextField alloc] init];
        _accountTextField.placeholder = @"请输入手机号";
        _accountTextField.shouldClear = YES;
      _accountTextField.shoundBoard = NO;
        _accountTextField.maxInputNum = 11;
        _accountTextField.keyboardType = UIKeyboardTypeNumberPad;
      
      _accountTextField.backgroundColor = [UIColor clearColor];
      [_accountTextField roundSize:AutoSize(6) color:ColorHex(XYTextColor_FFFFFF)];
      _accountTextField.placeholderColor = ColorHex(XYTextColor_FFFFFF);
      _accountTextField.textColor = ColorHex(XYTextColor_FFFFFF);
      _accountTextField.paddingHorizontal = AutoSize(10);
    }
    return _accountTextField;
}

- (XYDefaultButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [XYDefaultButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"手机验证码" forState:UIControlStateNormal];
    }
    return _submitButton;
}

//- (UIButton *)fastLoginButton {
//    if (!_fastLoginButton) {
//      _fastLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//      [_fastLoginButton setTitle:@"一键登录" forState:UIControlStateNormal];
//      [_fastLoginButton setTitleColor:ColorHex(XYTextColor_666666) forState:UIControlStateNormal];
//      _fastLoginButton.titleLabel.font = AdaptedFont(16);
//    }
//    return _fastLoginButton;
//}

- (UIButton *)wechatButton {
    if (!_wechatButton) {
        _wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_wechatButton setImage:[UIImage imageNamed:@"login_icon_weixin"] forState:UIControlStateNormal];
      [_wechatButton setBackgroundColor:[UIColor redColor]];
    }
    return _wechatButton;
}
- (UIButton *)qqButton {
    if (!_qqButton) {
        _qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_qqButton setImage:[UIImage imageNamed:@"login_icon_qq"] forState:UIControlStateNormal];
      [_qqButton setBackgroundColor:[UIColor redColor]];
    }
    return _qqButton;
}
- (UIButton *)weiboButton {
    if (!_weiboButton) {
        _weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_weiboButton setImage:[UIImage imageNamed:@"login_icon_weibo"] forState:UIControlStateNormal];
      [_weiboButton setBackgroundColor:[UIColor redColor]];
    }
    return _weiboButton;
}
- (UIView *)leftTitleViewLine {
    if (!_leftTitleViewLine) {
        _leftTitleViewLine = [[UIView alloc] init];
        _leftTitleViewLine.backgroundColor = UIColorAlpha(XYTextColor_333333,XYColorAlpha_20);
    }
    return _leftTitleViewLine;
}
- (UILabel *)thirdTipsLable {
    if (!_thirdTipsLable) {
        _thirdTipsLable = [[UILabel alloc] init];
        _thirdTipsLable.font = AdaptedFont(XYFont_C);
        _thirdTipsLable.textColor = UIColorAlpha(XYTextColor_333333,XYColorAlpha_20);
        _thirdTipsLable.text = @"社交账号登录";
    }
    return _thirdTipsLable;
}
- (UIView *)rightTitleViewLine {
    if (!_rightTitleViewLine) {
        _rightTitleViewLine = [[UIView alloc] init];
        _rightTitleViewLine.backgroundColor = UIColorAlpha(XYTextColor_333333,XYColorAlpha_20);
    }
    return _rightTitleViewLine;
}
- (YYTextView *)textView {
    if (!_textView) {
      _textView = [[YYTextView alloc] init];
      NSString * text = @"登录即同意《服务条款》和《隐私政策》";
      NSMutableAttributedString * atttext = [[NSMutableAttributedString alloc] initWithString:text];
      atttext.yy_font = AdaptedFont(13);
      atttext.yy_color = ColorHex(XYTextColor_222222);
      atttext.yy_lineSpacing = 8;
      
      YYTextHighlight * termsHighLight = [YYTextHighlight new];
      NSRange termsRange = [text rangeOfString:@"《服务条款》"];
      [atttext yy_setColor:ColorHex(XYTextColor_635FF0) range:termsRange];
      termsHighLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        WebViewController *vc = [[WebViewController alloc] init];
        vc.title = @"用户服务协议";
        vc.urlStr = [NSString stringWithFormat:@"%@/share/common.html?id=1",XY_SERVICE_HOST];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [[self getCurrentVC] presentViewController:nav animated:YES completion:nil];
      };
      [atttext yy_setTextHighlight:termsHighLight range:termsRange];
      
      YYTextHighlight * privacyHighLight = [YYTextHighlight new];
      NSRange privacyRange = [text rangeOfString:@"《隐私政策》"];
      [atttext yy_setColor:ColorHex(XYTextColor_635FF0) range:privacyRange];
      privacyHighLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        WebViewController *vc = [[WebViewController alloc] init];
        vc.urlStr = [NSString stringWithFormat:@"%@/share/common.html?id=2",XY_SERVICE_HOST];
        vc.title = @"用户隐私政策";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [[self getCurrentVC] presentViewController:nav animated:YES completion:nil];
      };
      [atttext yy_setTextHighlight:privacyHighLight range:privacyRange];
      
      _textView.attributedText = atttext;
      _textView.editable = NO;
      [self addSubview:_textView];
    }
    return _textView;
}

-(UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

-(UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
      
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {

        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
     
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
       
     
        currentVC = rootVC;
    }
    
    return currentVC;
}
@end
