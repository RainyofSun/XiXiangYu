//
//  XYLoginProtocolController.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import "XYLoginProtocolController.h"
#import "WebViewController.h"
#import "XYPresentationController.h"

@interface XYLoginProtocolController ()<UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UILabel *titleLable;

@property (strong, nonatomic) YYTextView *textView;

@property (strong, nonatomic) UIButton *agreeBtn;

@property (strong, nonatomic) UIButton *noAgreeBtn;

@end

@implementation XYLoginProtocolController

- (instancetype)init {
  if (self = [super init]) {
      self.modalPresentationStyle = UIModalPresentationCustom;
      self.transitioningDelegate = self;
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self setupSubviews];
}

#pragma mark - action
- (void)noagree {
  if (self.handler) {
    self.handler(NO);
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)agree {
  if (self.handler) {
    self.handler(YES);
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI
- (void)setupSubviews {
  self.view.layer.cornerRadius = 12;
  self.view.layer.masksToBounds = YES;
  [self.view addSubview:self.titleLable];
  [self.view addSubview:self.textView];
  [self.view addSubview:self.noAgreeBtn];
  [self.view addSubview:self.agreeBtn];
  
  
  [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.top.equalTo(self.view).offset(20);
  }];
  
  [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.titleLable.mas_bottom).offset(11);
    make.left.equalTo(self.view).offset(16);
    make.right.equalTo(self.view).offset(-16);
    make.height.mas_equalTo(315);
  }];
  
  [self.noAgreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(36);
    make.right.mas_equalTo(self.view.mas_centerX).offset(-17);
    make.left.mas_equalTo(self.view).offset(16);
    make.top.equalTo(self.textView.mas_bottom).offset(16);
  }];
  
  [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(36);
    make.left.mas_equalTo(self.view.mas_centerX).offset(17);
    make.right.mas_equalTo(self.view).offset(-16);
    make.top.equalTo(self.textView.mas_bottom).offset(16);
  }];
}

-(CGSize)preferredContentSize {
  return CGSizeMake(kScreenWidth-96, 440);
}

- (UILabel *)titleLable {
    if (!_titleLable) {
      _titleLable = [[UILabel alloc] init];
      _titleLable.textColor = ColorHex(XYTextColor_333333);
      _titleLable.font = AdaptedMediumFont(18);
      _titleLable.text = @"温馨提示";
      _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}

- (YYTextView *)textView {
    if (!_textView) {
      _textView = [[YYTextView alloc] init];
      NSString * text = @"感谢您使用喜乡遇！ 在您使用乡遇APP前，请您认真阅读并充分理解《喜乡遇会员服务条款》和《喜乡遇隐私保护政策》，点击“同意“，即表示您已阅读并同意全部条款；如您点击”不同意“，将可能导致无法继续使用我们的产品和服务。我们非常重视您的个人信息保护。特向您说明如下：1.为了保障平台网络安全和运营安全，乡遇需获取必要权限权限为存储权限和设备权限（收集设备信息）。2.地理位置、摄像头、麦克风、相册权限均不会默认开启，只有经过您的明示授权才会在为实现特定功能或服务时使用，您也可以改变或撤回授权。";
      NSMutableAttributedString * atttext = [[NSMutableAttributedString alloc] initWithString:text];
      atttext.yy_font = AdaptedFont(13);
      atttext.yy_color = ColorHex(XYTextColor_222222);
      atttext.yy_lineSpacing = 8;
      
      YYTextHighlight * termsHighLight = [YYTextHighlight new];
      NSRange termsRange = [text rangeOfString:@"《喜乡遇会员服务条款》"];
      [atttext yy_setColor:ColorHex(XYTextColor_635FF0) range:termsRange];
      termsHighLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        WebViewController *vc = [[WebViewController alloc] init];
        vc.title = @"用户服务协议";
        vc.urlStr = [NSString stringWithFormat:@"%@/share/common.html?id=1",XY_SERVICE_HOST];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
      };
      [atttext yy_setTextHighlight:termsHighLight range:termsRange];
      
      YYTextHighlight * privacyHighLight = [YYTextHighlight new];
      NSRange privacyRange = [text rangeOfString:@"《喜乡遇隐私保护政策》"];
      [atttext yy_setColor:ColorHex(XYTextColor_635FF0) range:privacyRange];
      privacyHighLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        WebViewController *vc = [[WebViewController alloc] init];
        vc.urlStr = [NSString stringWithFormat:@"%@/share/common.html?id=2",XY_SERVICE_HOST];
        vc.title = @"用户隐私政策";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:nav animated:YES completion:nil];
      };
      [atttext yy_setTextHighlight:privacyHighLight range:privacyRange];
      
      _textView.attributedText = atttext;
      _textView.editable = NO;
      [self.view addSubview:_textView];
    }
    return _textView;
}

- (UIButton *)noAgreeBtn {
  if (!_noAgreeBtn) {
    _noAgreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_noAgreeBtn setTitle:@"不同意" forState:UIControlStateNormal];
    [_noAgreeBtn setTitleColor:ColorHex(XYTextColor_999999) forState:UIControlStateNormal];
    _noAgreeBtn.titleLabel.font = AdaptedFont(15);
    _noAgreeBtn.layer.cornerRadius = 18;
    _noAgreeBtn.layer.masksToBounds = YES;
    _noAgreeBtn.layer.borderWidth = 1;
    _noAgreeBtn.layer.borderColor = ColorHex(XYThemeColor_I).CGColor;
    [_noAgreeBtn addTarget:self action:@selector(noagree) forControlEvents:UIControlEventTouchUpInside];
  }
  return _noAgreeBtn;
}

- (UIButton *)agreeBtn {
  if (!_agreeBtn) {
    _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [_agreeBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    _agreeBtn.titleLabel.font = AdaptedFont(15);
    [_agreeBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
    _agreeBtn.layer.cornerRadius = 18;
    _agreeBtn.layer.masksToBounds = YES;
    [_agreeBtn addTarget:self action:@selector(agree) forControlEvents:UIControlEventTouchUpInside];
  }
  return _agreeBtn;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[XYPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}
@end
