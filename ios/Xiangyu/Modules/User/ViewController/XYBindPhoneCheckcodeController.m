//
//  XYBindPhoneCheckcodeController.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/6.
//

#import "XYBindPhoneCheckcodeController.h"
#import "XYDefaultButton.h"
#import "XYPasswordView.h"
#import "XYPerfectOneStepViewController.h"
#import "XYBindAccountAPI.h"
#import "XYUserConst.h"

@interface XYBindPhoneCheckcodeController ()

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *subTitleLable;

@property (nonatomic,strong) XYPasswordView *checkcodeView;

@property (nonatomic,strong) XYDefaultButton *submitButton;

@property (nonatomic,copy) NSString *checkcode;

@end

@implementation XYBindPhoneCheckcodeController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = ColorHex(XYThemeColor_B);
  [self setupNavBar];
  [self.view addSubview:self.titleLable];
  [self.view addSubview:self.subTitleLable];
  [self.view addSubview:self.checkcodeView];
  [self.view addSubview:self.submitButton];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.checkcodeView becomeInputStatus];
}

- (void)bindAccount {
  if (!self.checkcode.isNotBlank) {
    XYToastText(XYLogin_VerifyCodeNULLError);
      return;
  }
  
  if (![self.checkcode isMatchingCheckCode]) {
    XYToastText(XYLogin_VerifyCodeError);
      return;
  }
  
  XYShowLoading;
  XYBindAccountAPI *api = [[XYBindAccountAPI alloc] initWithType:self.type relateId:self.thirdId thirdToken:self.thirdToken mobile:self.mobile code:self.checkcode];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
      if (error || !data) {
        XYToastText(error.msg);
          return;
      }
    XYUserInfo *user = [[XYUserInfo alloc] init];
    user.isFirst = @(1);
    user.mobile = data[@"mobile"];
    user.userId = data[@"userId"];
    user.realName = data[@"realName"];
    user.nickName = data[@"nickName"];
    user.headPortrait = data[@"headPortrait"];
    user.sex = data[@"sex"];
    user.goldBalance = data[@"goldBalance"];
    user.province = data[@"province"];
    user.city = data[@"city"];
    user.area = data[@"area"];
    user.address = data[@"address"];
    user.birthdate = data[@"birthdate"];
    user.token = data[@"token"];
    user.invitationCode = data[@"invitationCode"];
    user.status = data[@"status"];
    user.imLoginSign = data[@"imLoginSign"];
      
    NSInteger status = ((NSNumber *)data[@"status"]).integerValue;
    [[XYUserService service] loginUser:user isNeedPerfect:status == -2 withBlock:^(BOOL success) {
        if (success) {
          if (status == -2) {
            XYPerfectOneStepViewController *vc = [[XYPerfectOneStepViewController alloc] init];
            [self cyl_pushViewController:vc animated:YES];
          } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:XYGotoMainViewNotificationName object:nil];
          }
        } else {
          XYToastText(@"绑定账户错误~");
        }
    }];
  };
  [api start];
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
      self.checkcode = codeString;
    };
  }
  return _checkcodeView;
}

- (XYDefaultButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [XYDefaultButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"绑定" forState:UIControlStateNormal];
      _submitButton.frame = CGRectMake(40, 303+NAVBAR_HEIGHT, kScreenWidth-80, 48);
      [_submitButton addTarget:self action:@selector(bindAccount) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
@end
