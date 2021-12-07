//
//  XYHomeAwardController.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import "XYHomeAwardController.h"
#import "XYPresentationController.h"

@interface XYHomeAwardController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UILabel *titleLable;

@property (strong, nonatomic) UILabel *goldLable;

@property (strong, nonatomic) UIButton *closeBtn;

@property (strong, nonatomic) UIButton *exchangeGoldBtn;

@property (strong, nonatomic) UIImageView *bgImageView;

@end

@implementation XYHomeAwardController
- (instancetype)init {
  if (self = [super init]) {
      self.modalPresentationStyle = UIModalPresentationCustom;
      self.transitioningDelegate = self;
  }
  return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = [UIColor clearColor];
  [self setupSubviews];
}

#pragma mark - action
- (void)exchange {
  if (self.exchangeBlock) self.exchangeBlock();
  [self close];
}

- (void)close {
  [[XYUserService service] updateCurrentUserWithIsFirst:@(0) block:nil];
  if (self.dismissBlock) self.dismissBlock();
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI
- (void)setupSubviews {
  
  [self.view addSubview:self.bgImageView];
  [self.view addSubview:self.closeBtn];
  [self.bgImageView addSubview:self.titleLable];
  [self.bgImageView addSubview:self.goldLable];
  [self.bgImageView addSubview:self.exchangeGoldBtn];
  
  double ratio = 320.00/327.00;
  
  [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.right.equalTo(self.view);
    make.height.mas_equalTo((kScreenWidth-48)*ratio);
  }];
  
  [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.top.equalTo(self.bgImageView).offset(65*ratio);
  }];
  
  [self.goldLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.titleLable.mas_bottom).offset(17*ratio);
    make.centerX.equalTo(self.view);
  }];
  
  [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.width.mas_equalTo(22);
    make.centerX.mas_equalTo(self.view);
    make.top.equalTo(self.bgImageView.mas_bottom).offset(16);
  }];
  
  [self.exchangeGoldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.bgImageView).offset(58);
    make.right.mas_equalTo(self.bgImageView).offset(-58);
    make.height.mas_equalTo(43*ratio);
    make.bottom.equalTo(self.bgImageView).offset(-27*ratio);
  }];
}

-(CGSize)preferredContentSize {
  return CGSizeMake(kScreenWidth-48, (kScreenWidth-48)*320/327+38);
}

- (UILabel *)titleLable {
    if (!_titleLable) {
      _titleLable = [[UILabel alloc] init];
      _titleLable.textColor = ColorHex(@"#FF9900");
      _titleLable.font = AdaptedFont(14);
      _titleLable.text = @"恭喜您完成注册，获得一个奖励";
      _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}

- (UILabel *)goldLable {
    if (!_goldLable) {
      _goldLable = [[UILabel alloc] init];
      _goldLable.textColor = ColorHex(@"#FF9900");
      _goldLable.font = AdaptedBlodFont(40);
      _goldLable.text = [NSString stringWithFormat:@"%@金币", self.gold];
      _goldLable.textAlignment = NSTextAlignmentCenter;
    }
    return _goldLable;
}

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
      _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg1"]];
    }
    return _bgImageView;
}

- (UIButton *)exchangeGoldBtn {
  if (!_exchangeGoldBtn) {
    _exchangeGoldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_exchangeGoldBtn setBackgroundImage:[UIImage imageNamed:@"exchangeGold"] forState:UIControlStateNormal];
    [_exchangeGoldBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];
  }
  return _exchangeGoldBtn;
}

- (UIButton *)closeBtn {
  if (!_closeBtn) {
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"icon_close_white"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
  }
  return _closeBtn;
}
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[XYPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}
@end
