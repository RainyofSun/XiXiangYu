//
//  XYLoginMobileViewController.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYLoginMobileViewController.h"
#import "XYLoginCheckCodeViewController.h"
#import "XYLoginView.h"
#import "XYLoginViewModel.h"
#import "XYFastLoginComponent.h"
#import "XYPerfectOneStepViewController.h"
#import "XYBindPhoneViewController.h"
#import "XYLoginProtocolController.h"
#import "XYPlatformService.h"

#import "XYBgPlayView.h"


@interface XYLoginMobileViewController ()

@property(nonatomic,strong)XYBgPlayView *bgPlayView;

@property (nonatomic,strong) XYFastLoginComponent *loginComponent;

@property (nonatomic,strong) XYLoginView *loginView;

@property (nonatomic,strong) XYLoginViewModel *loginViewModel;

@property (weak, nonatomic) UIView *customView;

@property (strong, nonatomic) UIView *bgBtsView;

@end

@implementation XYLoginMobileViewController
-(void)dealloc{
  [self.bgPlayView outPage];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
  [self.view addSubview:self.bgPlayView];
    [self.view addSubview:self.loginView];
  //self.loginView.hidden = YES;
    [self layoutPageSubviews];

    [self binding];
  
    [self fastLogin];
  
  [[XYPlatformService shareService] fetchOnlineSwitchWithBlock:^(BOOL status) {
    self.loginComponent.needthirdLogin = !status;
    self.loginView.OnlineSwitch = status;
  }];
}

- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_statusBarStyle = UIStatusBarStyleLightContent;
  self.gk_navBarAlpha = 0;
}

#pragma mark - binding
- (void)binding {
    @weakify(self);
    self.loginView.accountTextField.text = self.loginViewModel.loginModel.mobile;
  
  [self.KVOControllerNonRetaining XY_observe:self.loginViewModel
  keyPath:FBKVOClassKeyPath(XYLoginViewModel, fetchCheckcodeExecuting)
    block:^(NSNumber * value) {
        if (!value) return;
        if (value.boolValue) {
            XYShowLoading;
        } else {
            XYHiddenLoading;
        }
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.loginViewModel
                                       keyPath:FBKVOClassKeyPath(XYLoginViewModel, checkcodeButtonEnable)
                                         block:^(NSNumber * value) {
                                             @strongify(self);
                                             self.loginView.submitButton.enabled = value.boolValue;
    }];
    
    [self.KVOControllerNonRetaining XY_observe:self.loginViewModel
                                       keyPath:FBKVOClassKeyPath(XYLoginViewModel, verifyMobileErrorMsg)
                                         block:^(NSString * value) {
                                             if (!value) return;
                                             if (value.isNotBlank) {
                                                 XYToastText(value);
                                             }
                                         }];

  [self.KVOControllerNonRetaining XY_observe:self.loginView
  keyPath:FBKVOClassKeyPath(XYLoginView, accountTextField.text)
    block:^(NSString * value) {
        @strongify(self);
        self.loginViewModel.loginModel.mobile = value;
    }];
}

#pragma mark - event
- (void)dismiss {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)obtainCheckCode {
  [[IQKeyboardManager sharedManager] resignFirstResponder];
  XYLoginCheckCodeViewController *vc = [[XYLoginCheckCodeViewController alloc] init];
  vc.loginViewModel = self.loginViewModel;
  [self cyl_pushViewController:vc animated:YES];
}

- (void)fastLogin {
  @weakify(self);
  [self.loginComponent fastLoginFromVc:self block:^(NSString * _Nonnull token) {
    [weak_self verifyLoginToken:token];
  }];
}

#pragma mark - UI
- (void)layoutPageSubviews {

    [self.loginView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(NAVBAR_HEIGHT, 0, 0, 0));
    }];
}
- (XYLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[XYLoginView alloc] init];
        [_loginView.submitButton addTarget:self action:@selector(obtainCheckCode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginView;
}
- (XYLoginViewModel *)loginViewModel {
    if (!_loginViewModel) {
        _loginViewModel = [[XYLoginViewModel alloc] init];
    }
    return _loginViewModel;
}
-(XYBgPlayView *)bgPlayView{
  if (!_bgPlayView) {
    _bgPlayView = [[XYBgPlayView alloc]initWithFrame:[UIScreen mainScreen].bounds];;
  }
  return _bgPlayView;
}
- (void)verifyLoginToken:(NSString *)loginToken {
  XYShowLoading;
  [self.loginViewModel fastLoginWithToken:loginToken block:^(BOOL isNeedPerfect, XYError *error) {
    XYHiddenLoading;
    if (error) {
      XYToastText(error.msg);
    } else {
      if (isNeedPerfect) {
        [self.loginComponent dismissLoginControllerAnimated:YES completion:^{
          XYPerfectOneStepViewController *vc = [[XYPerfectOneStepViewController alloc] init];
          [self cyl_pushViewController:vc animated:YES];
        }];
      } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:XYGotoMainViewNotificationName object:nil];
      }
    }
  }];
}

- (void)wechatLoginWithToken:(NSString *)token name:(NSString *)name {
  [self.loginViewModel wechatLoginWithToken:token block:^(BOOL isFirst, BOOL isNeedPerfect, NSString *thirdId, XYError *error) {
    dispatch_async_on_main_queue(^{
      if (error) {
        XYToastText(error.msg);
        return;
      }
      [self.loginComponent dismissLoginControllerAnimated:YES completion:^{
        if (isFirst) {
          XYBindPhoneViewController *vc = [[XYBindPhoneViewController alloc] init];
          vc.name = name;
          vc.bindType = BindPhoneType_Wechat;
          vc.thirdId = thirdId;
          vc.thirdToken = token;
          [self cyl_pushViewController:vc animated:YES];
        } else {
          if (isNeedPerfect) {
            XYPerfectOneStepViewController *vc = [[XYPerfectOneStepViewController alloc] init];
            [self cyl_pushViewController:vc animated:YES];
          } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:XYGotoMainViewNotificationName object:nil];
          }
        }
      }];
    });
  }];
}

- (void)qqLoginWithToken:(NSString *)token name:(NSString *)name {
  [self.loginViewModel qqLoginWithToken:token block:^(BOOL isFirst, BOOL isNeedPerfect, NSString *thirdId, XYError *error) {
    dispatch_async_on_main_queue(^{
      if (error) {
        XYToastText(error.msg);
        return;
      }
      [self.loginComponent dismissLoginControllerAnimated:YES completion:^{
        if (isFirst) {
          XYBindPhoneViewController *vc = [[XYBindPhoneViewController alloc] init];
          vc.name = name;
          vc.thirdToken = token;
          vc.bindType = BindPhoneType_QQ;
          vc.thirdId = thirdId;
          [self cyl_pushViewController:vc animated:YES];
        } else {
          if (isNeedPerfect) {
            XYPerfectOneStepViewController *vc = [[XYPerfectOneStepViewController alloc] init];
            [self cyl_pushViewController:vc animated:YES];
          } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:XYGotoMainViewNotificationName object:nil];
          }
        }
      }];
    });
  }];
}

- (XYFastLoginComponent *)loginComponent {
  if (!_loginComponent) {
    _loginComponent = [[XYFastLoginComponent alloc] init];
    @weakify(self);
    _loginComponent.needthirdLogin = NO;
    _loginComponent.wechatBlock = ^(NSString *name, NSString *token, NSString *errorMsg) {
      if (errorMsg.isNotBlank) {
        XYToastText(errorMsg);
      } else {
        [weak_self wechatLoginWithToken:token name:name];
      }
    };
    _loginComponent.qqBlock = ^(NSString *name, NSString *token, NSString *errorMsg) {
      if (errorMsg.isNotBlank) {
        XYToastText(errorMsg);
      } else {
        [weak_self qqLoginWithToken:token name:name];
      }
    };
  }
  return _loginComponent;
}
@end
