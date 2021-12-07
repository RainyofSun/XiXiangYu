//
//  XYBindPhoneViewController.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/24.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBindPhoneViewController.h"
#import "XYBindPhoneCheckcodeController.h"
#import "XYFetchCheckCodeAPI.h"

@interface XYBindPhoneViewController ()

@property (nonatomic,strong) XYBindPhoneView *contentView;

@end

@implementation XYBindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.contentView];
    [self setupNavBar];
    [self layoutPageSubviews];
}

- (void)submit {
  if (!self.contentView.accountTextField.text.isNotBlank) {
    XYToastText(XYLogin_VerifyMobileNULLError);
      return;
  }
  
  if (![self.contentView.accountTextField.text isMatchingPhoneNumber]) {
    XYToastText(XYLogin_VerifyMobileError);
      return;
  }
  
  XYShowLoading;
  XYFetchCheckCodeAPI *api = [[XYFetchCheckCodeAPI alloc] initWithMobile:self.contentView.accountTextField.text type:XYCheckCodeTypeRegister];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    XYError *subError = error ? ([error.code isEqualToString:@"-1"] ? nil : error) : nil;
    if (subError) {
      XYToastText(error.msg);
    } else {
      XYBindPhoneCheckcodeController *vc = [[XYBindPhoneCheckcodeController alloc] init];
      vc.thirdId = self.thirdId;
      vc.type = self.bindType;
      vc.thirdToken = self.thirdToken;
      vc.mobile = self.contentView.accountTextField.text;
      [self cyl_pushViewController:vc animated:YES];
    }
  };
  [api start];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_statusBarStyle = UIStatusBarStyleDefault;
}

#pragma mark - UI
- (void)layoutPageSubviews {
    
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(NAVBAR_HEIGHT, 0, 0, 0));
    }];
}
- (XYBindPhoneView *)contentView {
    if (!_contentView) {
        _contentView = [[XYBindPhoneView alloc] init];
        _contentView.bindType = self.bindType;
      _contentView.nameLable.text = self.name;
      [_contentView.submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contentView;
}
@end
