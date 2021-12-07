//
//  XYPerfectTwoStepViewController.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/17.
//

#import "XYPerfectTwoStepViewController.h"
#import "XYPerfectTwoStepView.h"

@interface XYPerfectTwoStepViewController ()

@property (nonatomic,strong) XYPerfectTwoStepView *contentView;

@end

@implementation XYPerfectTwoStepViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
  
    [self setupNavBar];
    
    [self layoutPageSubviews];
    
  [self bindView];
  [self bindViewModel];
}

#pragma mark - event
- (void)submit {
    [self.viewModel submitCommand];
}

- (void)backItemClick:(id)sender {
  self.viewModel.perfectProfileModel.salaryStart = nil;
  self.viewModel.perfectProfileModel.salaryEnd = nil;
  self.viewModel.perfectProfileModel.education = nil;
  self.viewModel.perfectProfileModel.height = nil;
  self.viewModel.perfectProfileModel.birthdate = nil;
  self.viewModel.perfectProfileModel.oneIndustry = nil;
  self.viewModel.perfectProfileModel.twoIndustry = nil;
  [self.navigationController popViewControllerAnimated:YES];
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
        self.contentView.submitButton.enabled = value.boolValue;
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

- (void)bindViewModel {
  @weakify(self);
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectTwoStepView, salaryStart)
    block:^(NSNumber * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.salaryStart = value;
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectTwoStepView, salaryEnd)
    block:^(NSNumber * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.salaryEnd = value;
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectTwoStepView, education)
    block:^(NSNumber * value) {
        @strongify(self);
    self.viewModel.perfectProfileModel.education = value.stringValue;
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectTwoStepView, height)
    block:^(NSNumber * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.height = value;
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectTwoStepView, birthdate)
    block:^(NSString * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.birthdate = value;
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectTwoStepView, oneIndustry)
    block:^(NSString * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.oneIndustry = value;
    }];
  
  [self.KVOControllerNonRetaining XY_observe:self.contentView
  keyPath:FBKVOClassKeyPath(XYPerfectTwoStepView, twoIndustry)
    block:^(NSString * value) {
        @strongify(self);
        self.viewModel.perfectProfileModel.twoIndustry = value;
    }];
}

#pragma mark - UI
- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)layoutPageSubviews {
    [self.view addSubview:self.contentView];
  [self.contentView makeConstraints:^(MASConstraintMaker *make) {
      make.edges.insets(UIEdgeInsetsMake(NAVBAR_HEIGHT, 0, 0, 0));
  }];
}
- (XYPerfectTwoStepView *)contentView {
    if (!_contentView) {
        _contentView = [[XYPerfectTwoStepView alloc] init];
      _contentView.targetVc = self;
        [_contentView.submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
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
