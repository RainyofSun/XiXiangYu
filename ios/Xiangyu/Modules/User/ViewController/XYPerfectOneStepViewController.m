//
//  XYPerfectOneStepViewController.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/23.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYPerfectOneStepViewController.h"
#import "XYPerfectOneStepView.h"
#import "XYPerfectProfileViewModel.h"
#import "XYPerfectTwoStepViewController.h"
#import "XYRandomNickNameAPI.h"

@interface XYPerfectOneStepViewController ()

@property (nonatomic,strong) XYPerfectOneStepView *contentView;

@property (nonatomic,strong) XYPerfectProfileViewModel *viewModel;

@end

@implementation XYPerfectOneStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
  
    [self setupNavBar];
    
    [self layoutPageSubviews];
    
    [self bindingViewModel];
    [self bindingView];
    [self bindView];
}

- (void)randomNickName {
  @weakify(self);
  XYShowLoading;
  XYRandomNickNameAPI *api = [[XYRandomNickNameAPI alloc] init];
  api.sex = self.contentView.selectGenderView.sex;
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    XYHiddenLoading;
    if (!error) {
      weak_self.contentView.nicknameView.textField.text = data[@"data"];
    }
  };
  [api start];
}

#pragma mark - event
- (void)submit {
  [[IQKeyboardManager sharedManager] resignFirstResponder];
//  [self.viewModel nextStepCommand];
  [self.viewModel submitCommand];
}
#pragma mark - binding
- (void)bindView {
    @weakify(self);
  [self.KVOControllerNonRetaining XY_observe:self.viewModel
  keyPath:FBKVOClassKeyPath(XYPerfectProfileViewModel, executing)
    block:^(NSNumber * value) {
        if (!value) return;
        if (value.boolValue) {
            XYShowLoading;
        } else {
            XYHiddenLoading;
        }
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.viewModel
  keyPath:FBKVOClassKeyPath(XYPerfectProfileViewModel, submitEnable)
    block:^(NSNumber * value) {
        if (!value)  return;
        @strongify(self);
        self.contentView.submitButton.enabled = value.boolValue && self.viewModel.nextStepEnable.boolValue;
    }];
    
  [self.KVOControllerNonRetaining XY_observe:self.viewModel
  keyPath:FBKVOClassKeyPath(XYPerfectProfileViewModel, twoStepVerifyErrorMsg)
    block:^(NSString * value) {
        if (value.isNotBlank) {
            XYToastText(value);
        }
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.viewModel
  keyPath:FBKVOClassKeyPath(XYPerfectProfileViewModel, successSubmit)
    block:^(NSNumber * value) {
        if (!value)  return;
        @strongify(self);
        if (value.boolValue) {
          [[XYUserService service] updateNoNeedPerfectBlock:^(BOOL success, NSDictionary *info) {
            if (success) {
              [[NSNotificationCenter defaultCenter] postNotificationName:XYGotoMainViewNotificationName object:nil];
            }
          }];
        } else {
         XYToastText(self.viewModel.exceptionMsg);
        }
    }];

}
- (void)bindingViewModel {
    @weakify(self);
  [self.KVOControllerNonRetaining XY_observe:self.viewModel
  keyPath:FBKVOClassKeyPath(XYPerfectProfileViewModel, nextStepEnable)
    block:^(NSNumber * value) {
        if (!value)  return;
        @strongify(self);
        self.contentView.submitButton.enabled = value.boolValue && self.viewModel.submitEnable.boolValue;
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.viewModel
  keyPath:FBKVOClassKeyPath(XYPerfectProfileViewModel, oneStepVerifyErrorMsg)
    block:^(NSString * value) {
        if (value.isNotBlank) {
            XYToastText(value);
        }
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.viewModel
  keyPath:FBKVOClassKeyPath(XYPerfectProfileViewModel, successNextStep)
    block:^(NSNumber * value) {
        if (!value)  return;
    @strongify(self);
    if (value.boolValue) {
      [[XYUserService service] updateNoNeedPerfectBlock:^(BOOL success, NSDictionary *info) {
        if (success) {
          [[NSNotificationCenter defaultCenter] postNotificationName:XYGotoMainViewNotificationName object:nil];
        }
      }];
    } else {
     XYToastText(self.viewModel.exceptionMsg);
    }
    
//        if (value.boolValue) {
//          XYPerfectTwoStepViewController *vc = [[XYPerfectTwoStepViewController alloc] init];
//          vc.viewModel = self.viewModel;
//          [self cyl_pushViewController:vc animated:YES];
//        }
    }];
    
}
- (void)bindingView {
  @weakify(self);
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectOneStepView, nicknameView.textField.text)
    block:^(NSString * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.nickName = value;
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectOneStepView, selectGenderView.sex)
    block:^(NSNumber * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.sex = value;
    }];
  
//  [self.KVOControllerNonRetaining XY_observe:self.contentView
//  keyPath:FBKVOClassKeyPath(XYPerfectOneStepView, addressView.content)
//    block:^(NSString * value) {
//        @strongify(self);
//        self.viewModel.perfectProfileModel.address = value;
//    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectOneStepView, provinceCode)
    block:^(NSString * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.province = value;
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectOneStepView, cityCode)
    block:^(NSString * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.city = value;
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectOneStepView, code)
    block:^(NSString * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.area = value;
    }];
  
//  [self.KVOControllerNonRetaining XY_observe:self.contentView
//  keyPath:FBKVOClassKeyPath(XYPerfectOneStepView, townCode)
//    block:^(NSString * value) {
//        @strongify(self);
       self.viewModel.perfectProfileModel.town = @"";
//    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectOneStepView, dwellProvinceCode)
    block:^(NSString * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.dwellProvince = value;
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectOneStepView, dwellCityCode)
    block:^(NSString * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.dwellCity = value;
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectOneStepView, dwellCode)
    block:^(NSString * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.dwellArea = value;
    }];
  
  //[self.KVOControllerNonRetaining XY_observe:self.contentView
 // keyPath:FBKVOClassKeyPath(XYPerfectOneStepView, birthdate)
   // block:^(NSString * value) {
       // @strongify(self);
        self.viewModel.perfectProfileModel.birthdate = @"1900-01-01";
   // }];
  
//  [self.KVOControllerNonRetaining XY_observe:self.contentView
//  keyPath:FBKVOClassKeyPath(XYPerfectOneStepView, oneIndustry)
//    block:^(NSString * value) {
//        @strongify(self);
        self.viewModel.perfectProfileModel.oneIndustry = @"0";
   // }];
  
//  [self.KVOControllerNonRetaining XY_observe:self.contentView
//  keyPath:FBKVOClassKeyPath(XYPerfectOneStepView, twoIndustry)
//    block:^(NSString * value) {
//        @strongify(self);
        self.viewModel.perfectProfileModel.twoIndustry = @"0";
   // }];
  
}
#pragma mark - UI
- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)layoutPageSubviews {
    [self.view addSubview:self.contentView];
  [self.contentView makeConstraints:^(MASConstraintMaker *make) {
     // make.edges.insets(UIEdgeInsetsMake(NAVBAR_HEIGHT, 0, 0, 0));
    make.left.trailing.bottom.equalTo(self.view);
    make.top.equalTo(self.view).offset(NAVBAR_HEIGHT);
    
  }];
}
- (XYPerfectOneStepView *)contentView {
    if (!_contentView) {
      _contentView = [[XYPerfectOneStepView alloc] init];
      _contentView.targetVc = self;
      [_contentView.submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
  
      @weakify(self);
      _contentView.nicknameView.randomNickNameBlock = ^{
        [weak_self randomNickName];
      };
    }
    return _contentView;
}

- (XYPerfectProfileViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[XYPerfectProfileViewModel alloc] init];
    }
    return _viewModel;
}

@end
