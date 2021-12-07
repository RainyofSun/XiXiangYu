//
//  XYLoginCheckCodeViewController.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/6.
//

#import "XYLoginCheckCodeViewController.h"
#import "XYDefaultButton.h"
#import "XYPasswordView.h"
#import "XYPerfectOneStepViewController.h"
#import "YYTimer.h"

@interface XYLoginCheckCodeViewController ()

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *subTitleLable;

@property (nonatomic,strong) XYPasswordView *checkcodeView;

@property (nonatomic,strong) XYDefaultButton *submitButton;

@end

@implementation XYLoginCheckCodeViewController
{
    YYTimer *timer_;
    NSUInteger time_;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = ColorHex(XYThemeColor_B);
  time_ = 60;
  [self setupNavBar];
  [self.view addSubview:self.titleLable];
  [self.view addSubview:self.subTitleLable];
  [self.view addSubview:self.checkcodeView];
  [self.view addSubview:self.submitButton];
  
  [self bind];
  // 自动获取验证码
  dispatch_async(dispatch_get_main_queue(), ^{
    [self obtainCheckcode];
  });
 //
}

- (void)bind {
  @weakify(self);
  
  [self.KVOControllerNonRetaining XY_observe:self.loginViewModel
  keyPath:FBKVOClassKeyPath(XYLoginViewModel, loginExecuting)
    block:^(NSNumber * value) {
        if (!value) return;
        if (value.boolValue) {
            XYShowLoading;
        } else {
            XYHiddenLoading;
        }
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.loginViewModel
  keyPath:FBKVOClassKeyPath(XYLoginViewModel, directAccessFlag)
    block:^(NSNumber * value) {
        if (!value) return;
        @strongify(self);
        if (value.boolValue) {
          
//          XYPerfectOneStepViewController *vc = [[XYPerfectOneStepViewController alloc] init];
//          [self cyl_pushViewController:vc animated:YES];
          
         [[NSNotificationCenter defaultCenter] postNotificationName:XYGotoMainViewNotificationName object:nil];
        } else {
            XYToastText(self.loginViewModel.exceptionMsg);
        }
  }];
  
  [self.KVOControllerNonRetaining XY_observe:self.loginViewModel
  keyPath:FBKVOClassKeyPath(XYLoginViewModel, needPerfectFlag)
    block:^(NSNumber * value) {
        if (!value) return;
        @strongify(self);
        if (value.boolValue) {
          XYPerfectOneStepViewController *vc = [[XYPerfectOneStepViewController alloc] init];
          [self cyl_pushViewController:vc animated:YES];
        } else {
            XYToastText(self.loginViewModel.exceptionMsg);
        }
  }];
  
  [self.KVOControllerNonRetaining XY_observe:self.loginViewModel
                                     keyPath:FBKVOClassKeyPath(XYLoginViewModel, verifyCheckCodeErrorMsg)
                                       block:^(NSString * value) {
                                           if (!value) return;
                                           if (value.isNotBlank) {
                                               XYToastText(value);
                                           }
                                       }];
  
  [self.KVOControllerNonRetaining XY_observe:self.loginViewModel
                                     keyPath:FBKVOClassKeyPath(XYLoginViewModel, successVerify)
                                       block:^(NSNumber * value) {
                                          if (!value) return;
                                          @strongify(self);
                                          if (value.boolValue) {
                                            [self fire];
                                          } else {
                                              XYToastText(self.loginViewModel.exceptionMsg);
                                          }
    }];

}

- (void)obtainCheckcode {
  [[IQKeyboardManager sharedManager] resignFirstResponder];
  [self.loginViewModel checkCodeCommand];
}

#pragma mark - event
- (void)fire {
    [self.checkcodeView becomeInputStatus];
    timer_ = [YYTimer timerWithTimeInterval:1.0 target:self selector:@selector(countdownTime) repeats:YES];
    [timer_ fire];
}
- (void)countdownTime {
    if (time_ == 0) {
        time_ = 60;
        [timer_ invalidate];
        timer_ = nil;
        self.submitButton.enabled = YES;
        [self.submitButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        self.submitButton.enabled = NO;
        [self.submitButton setTitle:[NSString stringWithFormat:@"%zds后重新获取",time_] forState:UIControlStateNormal];
        time_ --;
    }
}

#pragma UI
- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_statusBarStyle = UIStatusBarStyleDefault;
}


- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, 9+NAVBAR_HEIGHT, kScreenWidth-80, 30)];
        _titleLable.font = AdaptedMediumFont(24);
        _titleLable.textColor = ColorHex(XYTextColor_222222);
        _titleLable.text = @"输入验证码";
    }
    return _titleLable;
}

- (UILabel *)subTitleLable {
    if (!_subTitleLable) {
      _subTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(self.titleLable.frame)+16, kScreenWidth-80, 20)];
        _subTitleLable.font = AdaptedFont(14);
        _subTitleLable.textColor = ColorHex(XYTextColor_666666);
        _subTitleLable.text = @"请查看短信验证码";
    }
    return _subTitleLable;
}

- (XYPasswordView *)checkcodeView {
  @weakify(self);
  if (!_checkcodeView) {
    _checkcodeView = [[XYPasswordView alloc] initWithFrame:CGRectMake(40, 116+NAVBAR_HEIGHT, kScreenWidth-80, 40)];
    _checkcodeView.itemDistance = 20;
    _checkcodeView.numberOfChars = 6;
    _checkcodeView.codeBlock = ^(NSString *codeString) {
      @strongify(self);
      self.loginViewModel.loginModel.checkCode = codeString;
      if (codeString.length == 6) {
        [[IQKeyboardManager sharedManager] resignFirstResponder];
      }
    };
  }
  return _checkcodeView;
}

- (XYDefaultButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [XYDefaultButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"获取验证码" forState:UIControlStateNormal];
      _submitButton.frame = CGRectMake(40, 303+NAVBAR_HEIGHT, kScreenWidth-80, 48);
      [_submitButton addTarget:self action:@selector(obtainCheckcode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
@end
