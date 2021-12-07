//
//  XYHeartBeatNumberBuyView.m
//  Xiangyu
//
//  Created by Kang on 2021/7/5.
//
//------made in china-------
/**   The code comes frome breakfly
 *
 *       ┏┓　　 ┏┓
 *     ┏━┛┻━━━━┛┻┓
 * 　　┃　  　━　 ┃
 * 　　┃ 　 ^    ^ ┃
 * 　　┃　　　 ┻　 ┃
 * 　　┗━━━━━━━━━┛
 *
 * --------萌萌哒-------
 */
#import "XYHeartBeatNumberBuyView.h"
#import <SVGAPlayer/SVGAPlayer.h>
#import "SVGAParser.h"
#import "XYHeartMoneyView.h"
#import "XYHeartBuyTypeView.h"
#import "XYGeneralAPI.h"
#import <AlipaySDK/AlipaySDK.h>
#import <WechatOpenSDK/WXApi.h>//微信支付


@interface XYHeartBeatNumberBuyView ()

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *topImage;
//@property(nonatomic,strong)SVGAPlayer *player;
@property(nonatomic,strong)YYLabel *heartLabel;
@property(nonatomic,strong)XYHeartMoneyView *moneyView;

@property(nonatomic,strong)UIButton *closeBtn;

@property(nonatomic,strong)UIButton *buyButton;

@property(nonatomic,strong)XYHeartBuyTypeView *walletView;
@property(nonatomic,strong)XYHeartBuyTypeView *wxView;
@property(nonatomic,strong)XYHeartBuyTypeView *aliView;

@property(nonatomic,strong)NSString *payType;
@end
@implementation XYHeartBeatNumberBuyView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
      self.backgroundColor = [UIColor clearColor];
    [self configProperty];
  }
  return self;
}
- (void)configProperty
{
  FWPopupBaseViewProperty *property = [FWPopupBaseViewProperty manager];
  property.popupAlignment = FWPopupAlignmentCenter;
  property.popupAnimationStyle = FWPopupAnimationStyleScale;
  property.touchWildToHide = @"0";
  property.maskViewColor = [UIColor colorWithWhite:0 alpha:0.8];
    // property.maskViewColor = [UIColor colorWithWhite:0 alpha:0.3];
  //    property.popupEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
  //    property.animationDuration = 0.2;
  self.vProperty = property;
}
-(void)show{
  [super show];
  // 默认选中第一个
  if (self.conf.count) {
    self.moneyView.currentObj = self.conf.firstObject;
  }
  self.moneyView.dataSource = self.conf;
 // [self layoutChange];
}
-(void)newView{
  self.bgView = [LSHControl viewWithBackgroundColor:ColorHex(XYTextColor_FFFFFF)];
  [self.bgView roundSize:12];
self
  .bgView.frame = CGRectMake(0, 0, AutoSize(271), AutoSize(390));
  [self addSubview:self.bgView];
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.left.equalTo(self).offset(AutoSize(52));
    make.height.mas_equalTo(AutoSize(370));
    make.centerY.equalTo(self).offset(-AutoSize(20));

  }];
  
  
  self.closeBtn = [LSHControl createButtonWithFrame:CGRectZero buttonImage:@"icon_24_close"];
  [self addSubview:self.closeBtn];
  [self.closeBtn handleControlEventWithBlock:^(id sender) {
    [self hide];
  }];
  [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self.bgView.mas_bottom).offset(AutoSize(10));
    make.size.mas_equalTo(CGSizeMake(AutoSize(24), AutoSize(24)));
  }];
  
  
  [self.bgView addSubview:self.topImage];
  [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.centerX.equalTo(self.bgView);
    make.top.equalTo(self.bgView);
    make.height.mas_equalTo(AutoSize(110));
  }];
  
  
  self.heartLabel = [[YYLabel alloc] init];;
  [self.bgView addSubview:self.heartLabel];
  [self.heartLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.bgView).offset(AutoSize(8));
    make.centerX.equalTo(self.bgView);
    make.top.equalTo(self.topImage.mas_bottom).offset(AutoSize(8));
    make.height.mas_equalTo(AutoSize(22));
  }];
  
  NSMutableAttributedString *all_attr = [NSMutableAttributedString new];
  UIImage *image = [UIImage imageNamed: @"icon_20_heart"];
  NSMutableAttributedString *image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:AdaptedFont(12) alignment:YYTextVerticalAlignmentCenter];
  [all_attr appendAttributedString:image_attr];
NSMutableAttributedString *textl_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"超级心动表白次数不足，立刻补充"]];
textl_attr.yy_font = AdaptedFont(14);
textl_attr.yy_color = ColorHex(XYTextColor_222222);
[all_attr appendAttributedString:textl_attr];
self.heartLabel.attributedText = all_attr;
  
  self.moneyView = [[XYHeartMoneyView alloc]initWithFrame:CGRectMake(0, 0, AutoSize(270), AutoSize(36))];
  [self.bgView addSubview:self.moneyView];
  [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.bgView);
    make.top.equalTo(self.heartLabel.mas_bottom);
    make.height.mas_equalTo(AutoSize(36));
  }];
  self.walletView= [XYHeartBuyTypeView initWithImageName:@"iocn_20_qianbao" title:[self getWalletStr]];
  [self.walletView handleTapGestureRecognizerEventWithBlock:^(id sender) {
    self.payType = @"3";
  }];
  [self.bgView addSubview:self.walletView];
  [self.walletView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.bgView);
    make.top.equalTo(self.moneyView.mas_bottom);
    make.height.mas_equalTo(AutoSize(40));
  }];
  
  self.wxView = [XYHeartBuyTypeView initWithImageName:@"iocn_32_weixin" title:[self getAttributedStrWithTitle:@"微信支付"]];
  [self.bgView addSubview:self.wxView];
  [self.wxView handleTapGestureRecognizerEventWithBlock:^(id sender) {
    self.payType = @"1";
  }];
  [self.wxView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.bgView);
    make.top.equalTo(self.walletView.mas_bottom);
    make.height.mas_equalTo(AutoSize(40));
  }];
  
  self.aliView = [XYHeartBuyTypeView initWithImageName:@"icon_32_zhifub" title:[self getAttributedStrWithTitle:@"支付宝"]];
  [self.bgView addSubview:self.aliView];
  [self.aliView handleTapGestureRecognizerEventWithBlock:^(id sender) {
    self.payType = @"2";
  }];
  [self.aliView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.bgView);
    make.top.equalTo(self.wxView.mas_bottom);
    make.height.mas_equalTo(AutoSize(40));
  }];
  
  [self.bgView addSubview:self.buyButton];
  [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
   
    //make.top.equalTo(aliView.mas_bottom);
    make.centerX.equalTo(self.bgView);
    make.size.mas_equalTo(CGSizeMake(AutoSize(140), AutoSize(36)));
    make.bottom.equalTo(self.bgView).offset(-AutoSize(15)).priority(800);
  }];
 // [self layoutChange];
  
  
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCenter) name:@"AlipayChongzhichenggong" object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechartnotificationCenter) name:@"WechartChongzhichenggong" object:nil];
}

-(NSMutableAttributedString *)getAttributedStrWithTitle:(NSString *)title{
  NSMutableAttributedString *all_attr = [NSMutableAttributedString new];
  NSMutableAttributedString *textl_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",title]];
  textl_attr.yy_font = AdaptedFont(14);
  textl_attr.yy_color = ColorHex(XYTextColor_222222);
  [all_attr appendAttributedString:textl_attr];
  

  
  return all_attr;
}

-(NSMutableAttributedString *)getWalletStr{
  NSMutableAttributedString *all_attr = [NSMutableAttributedString new];
  NSMutableAttributedString *textl_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我的钱包  "]];
  textl_attr.yy_font = AdaptedFont(14);
  textl_attr.yy_color = ColorHex(XYTextColor_222222);
  [all_attr appendAttributedString:textl_attr];
  
  NSMutableAttributedString *text_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"余额%@",[[XYUserService service] fetchLoginUser].balance?:@"0"]];
  text_attr.yy_font = AdaptedFont(12);
  text_attr.yy_color = ColorHex(XYTextColor_999999);
  [all_attr appendAttributedString:text_attr];
  
  return all_attr;
}
-(UIImageView *)topImage{
  if (!_topImage) {
    _topImage = [LSHControl createImageViewWithImageName:@"pic_xdbg"];
  }
  return _topImage;
}
//- (SVGAPlayer *)player {
//  if (!_player) {
//    _player = [[SVGAPlayer alloc] init];
//    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
//    NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//    SVGAParser *parser = [[SVGAParser alloc] init];
//    @weakify(self);
//    [parser parseWithNamed:@"biaobai" inBundle:resourceBundle completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
//      @strongify(self);
//      self.player.videoItem = videoItem;
//      [self.player startAnimation];
////      [self.player setClearsAfterStop:(BOOL)];
//    } failureBlock:nil];
//  }
//  return _player;
//}
- (UIButton *)buyButton {
  if (!_buyButton) {
    _buyButton = [[UIButton alloc] initWithFrame:CGRectMake(ADAPTATIONRATIO * 30, SCREEN_HEIGHT-ADAPTATIONRATIO * 140-SafeAreaBottom(), SCREEN_WIDTH - ADAPTATIONRATIO * 60, ADAPTATIONRATIO * 88)];
    [_buyButton setBackgroundColor:ColorHex(@"#F92B5E")];
    [_buyButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [_buyButton.titleLabel setFont:AdaptedFont(14)];
    _buyButton.layer.cornerRadius = AutoSize(18);
    _buyButton.layer.masksToBounds = YES;
    [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_buyButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
  }
  return _buyButton;
}

-(void)layoutChange{
  
  CGFloat height = [self.bgView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  CGRect frame = self.bgView.frame;
  frame.size.height = height;
  self.bgView.frame = frame;
  
  
  [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.left.equalTo(self).offset(AutoSize(52));
   make.height.mas_equalTo(height);
    make.centerY.equalTo(self).offset(-AutoSize(20));

  }];
  
}

-(void)setPayType:(NSString *)payType{
  _payType = payType;
  if ([payType isEqualToString:@"1"]) {
    self.wxView.selectBtn.selected = YES;
    self.walletView.selectBtn.selected = self.aliView.selectBtn.selected = NO;
  }
  if ([payType isEqualToString:@"2"]) {
    self.aliView.selectBtn.selected = YES;
    self.walletView.selectBtn.selected = self.wxView.selectBtn.selected = NO;
  }
  if ([payType isEqualToString:@"3"]) {
    self.walletView.selectBtn.selected = YES;
    self.wxView.selectBtn.selected = self.aliView.selectBtn.selected = NO;
  }
}
-(void)submit{
  
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  NSString *method = @"api/v1/BlindDate/SubmitPay";
  
  if (!self.moneyView.currentObj) {
    XYToastText(@"选择购买类型");
    return;
  }
  if (!self.payType) {
    XYToastText(@"选择支付方式");
    return;
  }
  
NSNumber *professConfId    = [self.moneyView.currentObj objectForKey:@"id"];

  NSDictionary *params = @{
    @"userId": user.userId,
      @"professConfId": professConfId,
   @"payType": self.payType.numberValue
  };
  XYShowLoading;
  XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
    api.apiRequestMethodType = XYRequestMethodTypePOST;
  XYShowLoading;
  api.requestParameters = params ?: @{};
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    if (!error) {
        [self creatBuy:data];
    } else {
      if (self.successBlock) {
        self.successBlock(@(1));
      }
    }
  };
  [api start];
}

-(void)creatBuy:(NSDictionary *)dic{
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  NSString *method = @"api/v1/Recharge/SubPay";
NSDecimalNumber *decNumber    = [self.moneyView.currentObj objectForKey:@"price"];

  NSDictionary *params = @{
    @"userId": user.userId,
      @"amt": decNumber,
      @"buyType": @(5),
    @"merchantOrderNo": [dic objectForKey:@"data"],
    @"payType": self.payType.numberValue
  };

  XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
    api.apiRequestMethodType = XYRequestMethodTypePOST;
  
  api.requestParameters = params ?: @{};
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    if (!error) {
      [self pay:data];
    } else {
      XYToastText(error.msg);
    
    }
  };
  [api start];
}
- (void)pay:(NSDictionary *)dic {

  if ([self.payType isEqual:@"2"]) {
    [[AlipaySDK defaultService] payOrder:dic[@"orderInfo"] fromScheme:@"alisdkXiangyu" callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
      NSString *code=[NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]];
      if (self.successBlock && [code integerValue]==9000) {
        self.successBlock(@(1));
      }
    }];
  }else if ([self.payType isEqual:@"1"]){
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
      }else{
//        if (self.successBlock) {
//          self.successBlock(@(1));
//        }
       
      }
    }];
//    [WXApi sendAuthReq:req viewController:self delegate:self completion:^(BOOL success) {
//
//    }];
  }else { //微信未安装
        
        // [MBManager showMessage:@"您没有安装微信" inView:weakself.view afterDelayTime:2];

     }
  }else{
    if (self.successBlock) {
      self.successBlock(@(1));
    }
  }

}
- (void)notificationCenter {
  if (self.successBlock) {
    self.successBlock(@(1));
  }

}
- (void)wechartnotificationCenter {
  if (self.successBlock) {
    self.successBlock(@(1));
  }
 
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
