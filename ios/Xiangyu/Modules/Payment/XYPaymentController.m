//
//  XYHomeRecommendPopController.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import "XYPaymentController.h"
#import "XYDefaultButton.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WechatOpenSDK/WXApi.h>//微信支付
#import "XYGeneralAPI.h"
#import "XYUserService.h"
#import "WebViewController.h"
#import "XYPresentationController.h"

@interface XYPaymentItemView : UIView

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIImageView *checkbox;

@property (strong, nonatomic) UIView *line;

@property (nonatomic,copy) void(^chooseBlock)(void);

@end

@implementation XYPaymentItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choose)];
      [self addGestureRecognizer:tap];
      [self setupSubViews];
    }
    return self;
}

- (void)choose {
  self.checkbox.hidden = YES;
  if (self.chooseBlock) {
    self.chooseBlock();
  }
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

@interface XYPaymentController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) YYLabel *priceDetailLable;

@property (strong, nonatomic) UILabel *priceLable;

@property (strong, nonatomic) UIView *line1;

@property (strong, nonatomic) XYPaymentItemView *alipayView;

@property (strong, nonatomic) XYPaymentItemView *wechatpayView;

@property (strong, nonatomic) UIButton *closeBtn;

@property (strong, nonatomic) YYLabel *tipsLable;

@property (strong, nonatomic) XYDefaultButton *payBtn;

@property (nonatomic,strong) YYTextLayout *protocolTextLayout;

@property (nonatomic,assign) PaymentType currentPaymentType;

@end

@implementation XYPaymentController
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
  self.currentPaymentType = PaymentType_Alipay;
  [self setupSubviews];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter) name:@"AlipayChongzhichenggong" object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechartnotificationCenter) name:@"WechartChongzhichenggong" object:nil];
}

- (void)notificationCenter {
  if (self.payWithSuccess) {
      self.payWithSuccess();
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)wechartnotificationCenter {
  if (self.payWithSuccess) {
      self.payWithSuccess();
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - action
- (void)pay:(NSDictionary *)dic {

  if (self.currentPaymentType == PaymentType_Alipay) {
    [[AlipaySDK defaultService] payOrder:dic[@"orderInfo"] fromScheme:@"alisdkXiangyu" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
  }else {
      PayReq *req = [[PayReq alloc] init];

      //实际项目中这些参数都是通过网络请求后台得到的，详情见以下注释，测试的时候可以让后台将价格改为1分钱

      req.openID = dic[@"appid"];//微信开放平台审核通过的AppID

      req.partnerId = dic[@"partnerid"];//微信支付分配的商户ID

      req.prepayId = dic[@"prepayid"];// 预支付交易会话ID

    req.nonceStr =dic[@"noncestr"];//随机字符串
    // 这个是时间戳，也是在后台生成的，为了验证支付的
//        NSString * stamp = timestamp;
//
    req.timeStamp =  [dic[@"timestamp"] intValue];//当前时间
      req.package = dic[@"package"];//固定值
  
  req.sign =dic[@"sign"];//签名，除了sign，剩下6个组合的再次签名字符串
  if ([WXApi isWXAppInstalled] == YES) {
   //此处会调用微信支付界面
    [WXApi sendReq:req completion:^(BOOL success) {
      if (!success ) {
        // [MBManager showMessage:@"微信sdk错误" inView:weakself.view afterDelayTime:2];
      }
    }];
//    [WXApi sendAuthReq:req viewController:self delegate:self completion:^(BOOL success) {
//
//    }];
  }else { //微信未安装
        
        // [MBManager showMessage:@"您没有安装微信" inView:weakself.view afterDelayTime:2];

     }
    }

}

-(float)roundFloat:(float)price{
  NSString *temp = [NSString stringWithFormat:@"%.2f",price];
  NSDecimalNumber *numResult = [NSDecimalNumber decimalNumberWithString:temp];
  NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
  decimalNumberHandlerWithRoundingMode:NSRoundBankers
  scale:2
  raiseOnExactness:NO
  raiseOnOverflow:NO
  raiseOnUnderflow:NO
  raiseOnDivideByZero:YES];
  return [[numResult decimalNumberByRoundingAccordingToBehavior:roundUp] floatValue];
}


-(void)subPay {
    XYUserInfo *user = [[XYUserService service] fetchLoginUser];

    NSString *method = @"api/v1/Recharge/SubPay";
  NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:_money];

    NSDictionary *params = @{
      @"userId": user.userId,
        @"amt": decNumber,
        @"buyType": @([_buyType integerValue]),
        @"merchantOrderNo": _merchantOrderNo,
      @"payType": self.currentPaymentType == PaymentType_Alipay ? @2 : @1
    };

    XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
      api.apiRequestMethodType = XYRequestMethodTypePOST;
    
    api.requestParameters = params ?: @{};
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
      if (!error) {
        [self pay:data];
      } else {
      }
    };
    [api start];
}

- (void)depositCharges {
  WebViewController *vc = [[WebViewController alloc] init];
  vc.title = @"平台收费规则";
  vc.urlStr = [NSString stringWithFormat:@"%@/share/common.html?id=4",XY_SERVICE_HOST];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  nav.modalPresentationStyle = UIModalPresentationFullScreen;
  [self presentViewController:nav animated:YES completion:nil];
}

- (void)close {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI
- (void)setupSubviews {
  [self.view addSubview:self.priceDetailLable];
  [self.view addSubview:self.priceLable];
  [self.view addSubview:self.line1];
  [self.view addSubview:self.alipayView];
  [self.view addSubview:self.wechatpayView];
  [self.view addSubview:self.tipsLable];
  [self.view addSubview:self.closeBtn];
  [self.view addSubview:self.payBtn];
  
  [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.view).offset(-8);
    make.top.equalTo(self.view).offset(8);
  }];
  
  [self.priceLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.top.equalTo(self.view).offset(24);
  }];
  
  [self.priceDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.priceLable.mas_bottom).offset(6);
    make.centerX.equalTo(self.view);
  }];
  
  [self.alipayView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.priceDetailLable.mas_bottom).offset(6);
    make.left.right.equalTo(self.view);
    make.height.mas_offset(60);
  }];
  
  [self.wechatpayView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.alipayView.mas_bottom);
    make.left.right.equalTo(self.view);
    make.height.mas_offset(60);
  }];
  
  [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.alipayView.mas_top);
    make.left.right.equalTo(self.view);
    make.height.mas_offset(0.5);
  }];
  
  [self.tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.wechatpayView.mas_bottom).offset(16);
    make.left.equalTo(self.view).offset(12);
    make.right.equalTo(self.view).offset(-12);
    make.height.mas_offset(self.protocolTextLayout.textBoundingSize.height);
  }];
  
  [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.tipsLable.mas_bottom).offset(16);
    make.left.equalTo(self.view).offset(60);
    make.right.equalTo(self.view).offset(-60);
    make.height.mas_offset(36);
  }];
}
-(CGSize)preferredContentSize {
  return CGSizeMake(kScreenWidth-50, 340);
}

#pragma mark - getter

- (YYLabel *)priceDetailLable {
    if (!_priceDetailLable) {
      _priceDetailLable = [[YYLabel alloc] init];
      _priceDetailLable.textColor = ColorHex(@"#6160F0");
      _priceDetailLable.font = AdaptedFont(14);
      _priceDetailLable.text = self.desc;
    }
    return _priceDetailLable;
}

- (UILabel *)priceLable {
    if (!_priceLable) {
      _priceLable = [[UILabel alloc] init];
      _priceLable.textColor = ColorHex(XYTextColor_FE2D63);
      _priceLable.font = AdaptedMediumFont(30);
      _priceLable.text = [NSString stringWithFormat:@"￥%@",_money ];
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
- (XYPaymentItemView *)alipayView {
  if (!_alipayView) {
    _alipayView = [[XYPaymentItemView alloc] init];
    _alipayView.titleLabel.text = @"支付宝";
    _alipayView.imageView.image = [UIImage imageNamed:@"xianbi_28"];
    _alipayView.checkbox.hidden = NO;
    @weakify(self);
    _alipayView.chooseBlock = ^{
      weak_self.currentPaymentType = PaymentType_Alipay;
      weak_self.wechatpayView.checkbox.hidden = YES;
      weak_self.alipayView.checkbox.hidden = NO;
    };
  }
  return _alipayView;
}

- (XYPaymentItemView *)wechatpayView {
  if (!_wechatpayView) {
    _wechatpayView = [[XYPaymentItemView alloc] init];
    _wechatpayView.titleLabel.text = @"微信支付";
    _wechatpayView.imageView.image = [UIImage imageNamed:@"xianbi_28 weixin"];
    _wechatpayView.checkbox.hidden = YES;
    @weakify(self);
    _wechatpayView.chooseBlock = ^{
      weak_self.currentPaymentType = PaymentType_WechatPay;
      weak_self.alipayView.checkbox.hidden = YES;
      weak_self.wechatpayView.checkbox.hidden = NO;
    };
  }
  return _wechatpayView;
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
      [_payBtn addTarget:self action:@selector(subPay) forControlEvents:UIControlEventTouchUpInside];
      [_payBtn setTitle:[NSString stringWithFormat:@"确认订单￥%@",_money ] forState:UIControlStateNormal];
    }
    return _payBtn;
}

- (YYTextLayout *)protocolTextLayout {
  if (!_protocolTextLayout) {
    NSString *string = @"我同意《平台收费规则》，我也同意支付以下所示的总金额。";
    NSMutableAttributedString * text = [[NSMutableAttributedString alloc] initWithString:string];
    text.yy_font = AdaptedFont(12);
    text.yy_color = ColorHex(XYTextColor_222222);
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
