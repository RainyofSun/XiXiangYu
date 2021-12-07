//
//  XYHomeRecommendPopController.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import "XYGiftPaymentController.h"
#import "XYDefaultButton.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WechatOpenSDK/WXApi.h>//微信支付
#import "XYGeneralAPI.h"
#import "XYUserService.h"
#import "GKBallLoadingView.h"
#import "SVGAPlayer.h"
#import "SVGAParser.h"
#import "XYGiftPaymentCollectionViewCell.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "XYPresentationController.h"
#import "WebViewController.h"

@interface XYGiftPaymentView : UIView

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIImageView *checkbox;

@property (strong, nonatomic) UIView *line;

@property (nonatomic,copy) void(^chooseBlock)(void);

@end

@implementation XYGiftPaymentView

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

@interface XYGiftPaymentController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate> {
  NSArray *_dataArr;
  int _selectNum;
}

@property (strong, nonatomic) SVGAPlayer *player;
@property (strong, nonatomic) UILabel *titleLable;

@property (strong, nonatomic) YYLabel *priceDetailLable;

@property (strong, nonatomic) UILabel *priceLable;

@property (strong, nonatomic) UIView *line1;
@property (strong, nonatomic) XYGiftPaymentView *countrypayView;
@property (strong, nonatomic) XYGiftPaymentView *alipayView;

@property (strong, nonatomic) XYGiftPaymentView *wechatpayView;

@property (strong, nonatomic) UIButton *closeBtn;

@property (strong, nonatomic) YYLabel *tipsLable;

@property (strong, nonatomic) XYDefaultButton *payBtn;

@property (nonatomic,strong) YYTextLayout *protocolTextLayout;

@property (nonatomic,assign) PaymentType currentPaymentType;
@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic, strong) UICollectionView         *collectionView;

@end

@implementation XYGiftPaymentController
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
  _dataArr =@[@"1",@"10",@"88",@"100",@"520"];
  _selectNum = 0;
  self.view.layer.cornerRadius = 12;
  self.view.layer.masksToBounds = YES;
  self.currentPaymentType = PaymentType_CountryPay;
  [self setupSubviews];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter) name:@"AlipayChongzhichenggong" object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechartnotificationCenter) name:@"WechartChongzhichenggong" object:nil];
  

}
-(void)setDicData:(NSDictionary *)dicData {
  _dicData = dicData;
  SVGAParser *parser = [[SVGAParser alloc] init];

  [parser parseWithURL:[NSURL URLWithString:_dicData[@"animation"]] completionBlock:^(SVGAVideoEntity * _Nullable videoItem) {
      if (videoItem != nil) {
          self.player.videoItem = videoItem;
          [self.player startAnimation];
      }
  } failureBlock:nil];
}

- (void)notificationCenter {
  [self dismissViewControllerAnimated:YES completion:nil];
  if (self.payWithSuccess) {
      self.payWithSuccess();
  }
  NSString *name = [NSString stringWithFormat:@"对方收到了你的%@",_dicData[@"name"]];
  
  XYToastText(name);
}
- (void)wechartnotificationCenter {
  [self dismissViewControllerAnimated:YES completion:nil];
  if (self.payWithSuccess) {
      self.payWithSuccess();
  }
  NSString *name = [NSString stringWithFormat:@"对方收到了你的%@",_dicData[@"name"]];
  
  XYToastText(name);
}
#pragma mark - action
- (void)pay:(NSDictionary *)dic {

  if (self.currentPaymentType == PaymentType_Alipay) {
    [[AlipaySDK defaultService] payOrder:dic[@"orderInfo"] fromScheme:@"alisdkXiangyu" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
      
      
      NSString *code=[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]];
      if ([code integerValue]==9000) {
        if (self.payWithSuccess) {
          self.payWithSuccess();
        }
      }
    
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
      if (success ) {
        
       // if (self.payWithSuccess) {
        //  self.payWithSuccess();
       // }
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

- (void)CreateGiftOrder {
  
//  GKBallLoadingView *loadingView = [GKBallLoadingView loadingViewInView:self.view];
//  [loadingView startLoading];
  NSDecimalNumberHandler *hea = [[NSDecimalNumberHandler alloc]initWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];

  NSString *method = @"api/v1/Gift/CreateGiftOrder";
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  int str = 1;// 1.微信 2.支付宝 3.钱包
  if (self.currentPaymentType == PaymentType_CountryPay) {
    str = 3;
    [self subPay:nil];
    return;
  }else if (self.currentPaymentType == PaymentType_Alipay) {
    str = 2;
  }else {
    str = 1;
  }
  int a = [_dataArr[_selectNum] intValue];
  float b = [_dicData[@"amt"] floatValue];
  // 小数点会出现精度问题，所以需要单独处理number
  float num = a * b;
  NSDictionary *params = @{
   @"userId": user.userId,
     @"destUserId": @([_user_id intValue]),
     @"giftNum": @([_dataArr[_selectNum] intValue]),
     @"giftAmt": [[[NSDecimalNumber alloc] initWithFloat:num] decimalNumberByRoundingAccordingToBehavior:hea],
     @"giftId": @([_dicData[@"id"] intValue]),
     @"payType":@(str),
   @"type":self.type?:@(1),
  };

  
  XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
  api.apiRequestMethodType = XYRequestMethodTypePOST;

  api.requestParameters = params ?: @{};
//  @weakify(loadingView);
  XYShowLoading;
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
   //[weak_loadingView stopLoading];
   //[weak_loadingView removeFromSuperview];
   if (!error) {

     [self subPay:data];
   } else {

   }
  };
  [api start];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
   // [loadingView stopLoading];
    //[loadingView removeFromSuperview];
    XYHiddenLoading;
  });
}


-(void)subPay:(NSDictionary*)data {
  
  if (self.currentPaymentType == PaymentType_CountryPay) {
    
   NSString *method = @"api/v1/Gift/CreateGiftOrder";
   XYUserInfo *user = [[XYUserService service] fetchLoginUser];

    NSDecimalNumberHandler *hea = [[NSDecimalNumberHandler alloc]initWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    int a = [_dataArr[_selectNum] intValue];
    float b = [_dicData[@"amt"] floatValue];
    // 小数点会出现精度问题，所以需要单独处理number
    float num = a * b;
   NSDictionary *params = @{
      @"userId": user.userId,
       @"destUserId": @([_user_id integerValue]),
       @"giftNum": @([_dataArr[_selectNum] intValue]),
       //@"giftAmt": @([_dataArr[_selectNum] intValue] * [_dicData[@"amt"] floatValue]),
      
      @"giftAmt": [[[NSDecimalNumber alloc] initWithFloat:num] decimalNumberByRoundingAccordingToBehavior:hea],
       @"giftId": @([_dicData[@"id"] integerValue]),
       @"payType": @3,
      @"type":self.type?:@(1),
   };
     NSString *name = [NSString stringWithFormat:@"对方收到了你的%@",_dicData[@"name"]];
   XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
     api.apiRequestMethodType = XYRequestMethodTypePOST;
   
   api.requestParameters = params ?: @{};
   api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
     if (!error) {
       XYToastText(name);
       if (self.payWithSuccess) {
         self.payWithSuccess();
       }
       [[NSNotificationCenter defaultCenter] postNotificationName:XYUpdateUserInfoNotificationName object:nil];
     } else {

     }
   };
   [api start];
  }else {
    
    NSDecimalNumberHandler *hea = [[NSDecimalNumberHandler alloc]initWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    
    XYUserInfo *user = [[XYUserService service] fetchLoginUser];

    NSString *method = @"api/v1/Recharge/SubPay";
    NSDictionary *params = @{
      @"userId": user.userId,
        @"amt": [[[NSDecimalNumber alloc] initWithFloat:[_dataArr[_selectNum] intValue] * [_dicData[@"amt"] floatValue]] decimalNumberByRoundingAccordingToBehavior:hea],
        @"buyType": @(1),
        @"merchantOrderNo": data[@"data"],
      @"payType": self.currentPaymentType == PaymentType_Alipay ? @2 : @1
    };

    XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
      api.apiRequestMethodType = XYRequestMethodTypePOST;
    
    api.requestParameters = params ?: @{};
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
      XYHiddenLoading;

      if (!error) {
        
        [self pay:data];
      } else {
      }
    };
    [api start];
  }
}

- (void)priceDetail {
  
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
  
  
  [self.view addSubview:self.player];
  [self.view addSubview:self.collectionView];
  [self.view addSubview:self.countrypayView];
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
  
  
  
  [self.player mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view);
    make.left.right.equalTo(self.view);
    make.height.mas_offset(120);
  }];
  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.player.mas_bottom);
    make.left.right.equalTo(self.view);
    make.height.mas_offset(64);
  }];
  [self.countrypayView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.collectionView.mas_bottom);
    make.left.right.equalTo(self.view);
    make.height.mas_offset(60);
  }];
  [self.alipayView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.countrypayView.mas_bottom);
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
 // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechartnotificationCenter) name:@"WechartChongzhichenggong" object:nil];
  
  
}
-(CGSize)preferredContentSize {
  return CGSizeMake(kScreenWidth-50, 500);
}

#pragma mark - getter

- (UILabel *)titleLable {
    if (!_titleLable) {
      _titleLable = [[UILabel alloc] init];
      _titleLable.textColor = ColorHex(XYTextColor_222222);
      _titleLable.font = AdaptedMediumFont(16);
      _titleLable.text = @"现在支付";
    }
    return _titleLable;
}

- (YYLabel *)priceDetailLable {
    if (!_priceDetailLable) {
      _priceDetailLable = [[YYLabel alloc] init];
      _priceDetailLable.textColor = ColorHex(XYTextColor_635FF0);
      _priceDetailLable.font = AdaptedFont(12);
      _priceDetailLable.text = @"价格详情";
      @weakify(self);
      _priceDetailLable.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [weak_self priceDetail];
      };
    }
    return _priceDetailLable;
}

- (UILabel *)priceLable {
    if (!_priceLable) {
      _priceLable = [[UILabel alloc] init];
      _priceLable.textColor = ColorHex(XYTextColor_222222);
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

- (XYGiftPaymentView *)countrypayView {
  if (!_countrypayView) {
    _countrypayView = [[XYGiftPaymentView alloc] init];
    XYUserInfo *user = [[XYUserService service] fetchLoginUser];
    

    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"乡币（余额：%@乡币）",user.goldBalance]];

    [attributedString addAttribute:NSForegroundColorAttributeName
                       value:ColorHex(@"#666666")
                             range:[[NSString stringWithFormat:@"乡币（余额：%@乡币）",user.goldBalance] rangeOfString:[NSString stringWithFormat:@"（余额：%@乡币）",user.goldBalance]]];
    
    if ([self.type integerValue] == 2) {
      attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我的钱包（余额：%@）",user.balance?:@"0"]];
      [attributedString addAttribute:NSForegroundColorAttributeName
                         value:ColorHex(@"#666666")
                               range:[[NSString stringWithFormat:@"我的钱包（余额：%@）",user.balance?:@"0"] rangeOfString:[NSString stringWithFormat:@"（余额：%@）",user.balance?:@"0"]]];
    }
    
    
    _countrypayView.titleLabel.attributedText = attributedString;
    _countrypayView.imageView.image = [UIImage imageNamed:@"xianbi_20"];

    if ([self.type integerValue]== 2) {
      _countrypayView.imageView.image = [UIImage imageNamed:@"iocn_20_qianbao"];
    }
    
   
    _countrypayView.checkbox.hidden = NO;
    @weakify(self);
    _countrypayView.chooseBlock = ^{
      weak_self.currentPaymentType = PaymentType_CountryPay;
      weak_self.wechatpayView.checkbox.hidden = YES;
      weak_self.alipayView.checkbox.hidden = YES;
      weak_self.countrypayView.checkbox.hidden = NO;
     
      if ([self.type integerValue] == 2) {
        CGFloat a =  [self->_dataArr[self->_selectNum] intValue] * [weak_self.dicData[@"amt"] floatValue];
        [self->_payBtn setTitle:[NSString stringWithFormat:@"确认订单%.2f元",a] forState:UIControlStateNormal];
      }else{
        int a =  [self->_dataArr[self->_selectNum] intValue] * [weak_self.dicData[@"amt"] intValue];
        [self->_payBtn setTitle:[NSString stringWithFormat:@"确认订单%d乡币",a] forState:UIControlStateNormal];
      }
     

    };
  }
  return _countrypayView;
}
- (XYGiftPaymentView *)alipayView {
  if (!_alipayView) {
    _alipayView = [[XYGiftPaymentView alloc] init];
    _alipayView.titleLabel.text = @"支付宝";
    _alipayView.imageView.image = [UIImage imageNamed:@"xianbi_28"];
    _alipayView.checkbox.hidden = YES;
    @weakify(self);
    _alipayView.chooseBlock = ^{
      weak_self.currentPaymentType = PaymentType_Alipay;
      weak_self.wechatpayView.checkbox.hidden = YES;
      weak_self.alipayView.checkbox.hidden = NO;
      weak_self.countrypayView.checkbox.hidden = YES;
      
      
      
      if ([self.type integerValue] == 2) {
        CGFloat a =  [self->_dataArr[self->_selectNum] intValue] * [weak_self.dicData[@"amt"] floatValue];
        [weak_self.payBtn setTitle:[NSString stringWithFormat:@"确认订单¥%.2f",a] forState:UIControlStateNormal];
      }else{
        int a =  [self->_dataArr[self->_selectNum] intValue] * [weak_self.dicData[@"amt"] intValue];
        [weak_self.payBtn setTitle:[NSString stringWithFormat:@"确认订单¥%d",a] forState:UIControlStateNormal];
      }
      
    //  int a =  [self->_dataArr[self->_selectNum] intValue] * [weak_self.dicData[@"amt"] floatValue];
    //  [weak_self.payBtn setTitle:[NSString stringWithFormat:@"确认订单￥%d",a] forState:UIControlStateNormal];

    };
  }
  return _alipayView;
}

- (XYGiftPaymentView *)wechatpayView {
  if (!_wechatpayView) {
    _wechatpayView = [[XYGiftPaymentView alloc] init];
    _wechatpayView.titleLabel.text = @"微信支付";
    _wechatpayView.imageView.image = [UIImage imageNamed:@"xianbi_28 weixin"];
    _wechatpayView.checkbox.hidden = YES;
    @weakify(self);
    _wechatpayView.chooseBlock = ^{
      weak_self.currentPaymentType = PaymentType_WechatPay;
      weak_self.alipayView.checkbox.hidden = YES;
      weak_self.wechatpayView.checkbox.hidden = NO;
      weak_self.countrypayView.checkbox.hidden = YES;
//      int a =  [self->_dataArr[self->_selectNum] intValue] * [self->_dicData[@"amt"] floatValue];
//      [self->_payBtn setTitle:[NSString stringWithFormat:@"确认订单%d元",a] forState:UIControlStateNormal];
      if ([self.type integerValue] == 2) {
        CGFloat a =  [self->_dataArr[self->_selectNum] intValue] * [weak_self.dicData[@"amt"] floatValue];
        [weak_self.payBtn setTitle:[NSString stringWithFormat:@"确认订单¥%.2f",a] forState:UIControlStateNormal];
      }else{
        int a =  [self->_dataArr[self->_selectNum] intValue] * [weak_self.dicData[@"amt"] intValue];
        [weak_self.payBtn setTitle:[NSString stringWithFormat:@"确认订单¥%d",a] forState:UIControlStateNormal];
      }

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
      [_payBtn addTarget:self action:@selector(CreateGiftOrder) forControlEvents:UIControlEventTouchUpInside];
      
//      int a =  [self->_dataArr[self->_selectNum] intValue] * [_dicData[@"amt"] floatValue];
//      [self->_payBtn setTitle:[NSString stringWithFormat:@"确认订单%d元",a] forState:UIControlStateNormal];
      if ([self.type integerValue] == 2) {
        CGFloat a =  [self->_dataArr[self->_selectNum] intValue] * [_dicData[@"amt"] floatValue];
        [self->_payBtn setTitle:[NSString stringWithFormat:@"确认订单¥%.2f",a] forState:UIControlStateNormal];
      }else{
        int a =  [self->_dataArr[self->_selectNum] intValue] * [_dicData[@"amt"] intValue];
        [self->_payBtn setTitle:[NSString stringWithFormat:@"确认订单%d乡币",a] forState:UIControlStateNormal];
      }
      
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
-(WKWebView *)webView {
  if (!_webView) {
    _webView = [[WKWebView alloc] init];
  }
  return _webView;
}

#pragma mark -- UICollectionViewDataSource ---定义展示的UICollectionViewCell的个数---
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArr.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"XYGiftPaymentCollectionViewCell";
  XYGiftPaymentCollectionViewCell *cell = (XYGiftPaymentCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.titleLab.text =[NSString stringWithFormat:@"送%@个",_dataArr[indexPath.row]];
  if (_selectNum == indexPath.row) {
    cell.titleLab.backgroundColor = ColorHex(@"#FE2D63");
    cell.titleLab.textColor = [UIColor whiteColor];
  }else {
    cell.titleLab.backgroundColor = [UIColor whiteColor];
    cell.titleLab.textColor = ColorHex(@"#FE2D63");
  }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( 64, 56);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  _selectNum = (int)indexPath.row;
  
  
  if ([self.type intValue] == 2) {
    float a =  [_dataArr[_selectNum] intValue] * [self.dicData[@"amt"] floatValue];
    if (self.currentPaymentType == PaymentType_CountryPay) {
      [_payBtn setTitle:[NSString stringWithFormat:@"确认订单%.2f元",a] forState:UIControlStateNormal];
    }else {
      [_payBtn setTitle:[NSString stringWithFormat:@"确认订单%.2f元",a] forState:UIControlStateNormal];
    }
  }else{
    int a =  [_dataArr[_selectNum] intValue] * [self.dicData[@"amt"] intValue];
    if (self.currentPaymentType == PaymentType_CountryPay) {
      [_payBtn setTitle:[NSString stringWithFormat:@"确认订单%d乡币",a] forState:UIControlStateNormal];
    }else {
      [_payBtn setTitle:[NSString stringWithFormat:@"确认订单%d元",a] forState:UIControlStateNormal];
    }
  }
  
  


  [self.collectionView reloadData];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //确定是水平滚动，还是垂直滚动
          UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
          layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      layout.minimumLineSpacing = 0;
      layout.minimumInteritemSpacing = 0;

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[XYGiftPaymentCollectionViewCell class] forCellWithReuseIdentifier:@"XYGiftPaymentCollectionViewCell"];
        
    }
    return _collectionView;
}

- (SVGAPlayer *)player {
  if (!_player) {
    _player = [[SVGAPlayer alloc] init];
  }
  return _player;
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[XYPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}

@end
