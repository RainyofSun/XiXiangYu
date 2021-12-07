//
//  XYSuccessViewController.m
//  Xiangyu
//
//  Created by GQLEE on 2021/4/21.
//

#import "XYSuccessViewController.h"
#import "XYDefaultButton.h"
#import "XYPresentationController.h"

@interface XYSuccessView : UIView

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIImageView *checkbox;

@property (strong, nonatomic) UIView *line;

@property (nonatomic,copy) void(^chooseBlock)(void);

@end

@implementation XYSuccessView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      [self setupSubViews];
    }
    return self;
}
- (void)setupSubViews {
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.checkbox];
    [self addSubview:self.line];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.imageView.frame = CGRectMake(17, 16, 28, 28);
  self.checkbox.frame = CGRectMake(self.XY_width-38, 20, 22, 22);
  CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
  self.titleLabel.frame = CGRectMake(53, ((self.XY_height)-titleSize.height)/2, titleSize.width, titleSize.height);
  self.line.frame = CGRectMake(0, self.XY_height-0.5, self.XY_width, 0.5);
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
      _titleLabel.textColor = ColorHex(XYTextColor_222222);
      _titleLabel.font = AdaptedMediumFont(16);
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
      _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIImageView *)checkbox {
    if (!_checkbox) {
      _checkbox = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-dui-selected"]];
    }
    return _checkbox;
}


- (UIView *)line {
  if (!_line) {
    _line = [[UIView alloc] init];
    _line.backgroundColor = ColorHex(XYThemeColor_E);
  }
  return _line;
}
@end

typedef NS_ENUM(NSInteger, PaymentType) {
    PaymentType_Alipay = 0,
    PaymentType_WechatPay,
  PaymentType_CountryPay,
};

@interface XYSuccessViewController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) YYLabel *priceDetailLable;

@property (strong, nonatomic) UILabel *priceLable;

@property (strong, nonatomic) UIView *line1;

@property (strong, nonatomic) UIImageView *img;

@property (strong, nonatomic) UIButton *closeBtn;

@property (strong, nonatomic) YYLabel *tipsLable;

@property (strong, nonatomic) XYDefaultButton *payBtn;

@property (nonatomic,strong) YYTextLayout *protocolTextLayout;

@property (nonatomic,assign) PaymentType currentPaymentType;

@end

@implementation XYSuccessViewController
- (instancetype)init {
  if (self = [super init]) {
      self.modalPresentationStyle = UIModalPresentationCustom;
      self.transitioningDelegate = self;
  }
  return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = ColorHex(XYThemeColor_B);
  self.view.layer.cornerRadius = 12;
  self.view.layer.masksToBounds = YES;
  [self setupSubviews];
}


- (void)depositCharges {
}

- (void)close {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI
- (void)setupSubviews {
  
  [self.view addSubview:self.img];
  [self.view addSubview:self.priceDetailLable];
  [self.view addSubview:self.priceLable];
//  [self.view addSubview:self.closeBtn];
  [self.view addSubview:self.payBtn];
  
//  [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.right.equalTo(self.view).offset(-8);
//    make.top.equalTo(self.view).offset(8);
//  }];
  
  [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(32);
    make.centerX.equalTo(self.view);
    make.width.height.mas_equalTo(80);
  }];
  [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.img.mas_bottom).offset(8);
    make.centerX.equalTo(self.view);
  }];
  [self.priceDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.priceLable.mas_bottom).offset(8);
    make.centerX.equalTo(self.view);
  }];
  [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.priceDetailLable.mas_bottom).offset(16);
    make.left.equalTo(self.view).offset(60);
    make.right.equalTo(self.view).offset(-60);
    make.height.mas_offset(36);
  }];
}
-(CGSize)preferredContentSize {
  return CGSizeMake(270, 240);
}

#pragma mark - getter
- (UIImageView *)img {
  if (!_img) {
    _img = [[UIImageView alloc] init];
    _img.image = [UIImage imageNamed:@"caozuochenggong"];
  }
  return _img;
}
- (YYLabel *)priceDetailLable {
    if (!_priceDetailLable) {
      _priceDetailLable = [[YYLabel alloc] init];
      _priceDetailLable.textColor = ColorHex(@"#666666");
      _priceDetailLable.font = AdaptedFont(14);
      _priceDetailLable.text =  self.decL ? self.decL : @"系统将对本条内容进行审核";
    }
    return _priceDetailLable;
}

- (UILabel *)priceLable {
    if (!_priceLable) {
      _priceLable = [[UILabel alloc] init];
      _priceLable.textColor = ColorHex(@"#6160F0");
      _priceLable.font = AdaptedMediumFont(18);
      _priceLable.text = self.titleL ? self.titleL : @"举报成功";
    }
    return _priceLable;
}

- (UIView *)line1 {
  if (!_line1) {
    _line1 = [[UIView alloc] init];
    _line1.backgroundColor = ColorHex(XYThemeColor_E);
  }
  return _line1;
}

- (YYLabel *)tipsLable {
    if (!_tipsLable) {
      _tipsLable = [[YYLabel alloc] init];
      _tipsLable.textLayout = self.protocolTextLayout;
    }
    return _tipsLable;
}

- (UIButton *)closeBtn {
  if (!_closeBtn) {
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"icon-pop-Close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
  }
  return _closeBtn;
}

- (XYDefaultButton *)payBtn {
    if (!_payBtn) {
      _payBtn = [XYDefaultButton buttonWithType:UIButtonTypeCustom];
      _payBtn.titleLabel.font = AdaptedFont(16);
      [_payBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
      [_payBtn setTitle:[NSString stringWithFormat:@"确定" ] forState:UIControlStateNormal];
    }
    return _payBtn;
}

- (YYTextLayout *)protocolTextLayout {
  if (!_protocolTextLayout) {
    NSString *string = @"系统将对本条内容进行审核";
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = AdaptedFont(14);
    text.yy_color = ColorHex(@"#666666");
    NSRange protocolRange = [string rangeOfString:@"《平台收费规则》"];
    YYTextHighlight * highLight = [YYTextHighlight new];
    [text yy_setColor:ColorHex(XYTextColor_635FF0) range:protocolRange];
    @weakify(self);
    highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
      [weak_self depositCharges];
    };
    [text yy_setTextHighlight:highLight range:protocolRange];
    
    // 创建文本容器
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(self.preferredContentSize.width - 24, CGFLOAT_MAX);
    container.truncationType = YYTextTruncationTypeEnd;
    // 生成排版结果
    _protocolTextLayout = [YYTextLayout layoutWithContainer:container text:text];
  }
  
  return _protocolTextLayout;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[XYPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

@end
