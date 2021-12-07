//
//  XYFastLoginComponent.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/3/13.
//

#import "XYFastLoginComponent.h"
#import "JVERIFICATIONService.h"
#import "JSHAREService.h"
#import "UIButton+Helper.h"

#import "XYBgPlayView.h"
@interface XYFastLoginComponent ()

@property (nonatomic,strong) UIView *customAreaView;

//@property (nonatomic,strong) XYBgPlayView *bgPlayView;

@property(nonatomic,strong)UIImageView *topImage;

//@property (nonatomic,strong) UILabel *titleLable;

//@property (nonatomic,strong) UILabel *descLable;

@property (nonatomic,strong) UIView *btnsView;

@end

@implementation XYFastLoginComponent
- (void)fastLoginFromVc:(UIViewController *)fromVc block:(void(^)(NSString *token))block {
  if(![JVERIFICATIONService checkVerifyEnable]) {
          return;
  }
  
  [self customUI];
  [JVERIFICATIONService getAuthorizationWithController:fromVc hide:NO animated:NO timeout:4000 completion:^(NSDictionary *result) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *token = result[@"loginToken"];
        NSInteger code = [result[@"code"] integerValue];
        if (token) {
            dispatch_async(dispatch_get_main_queue(), ^{
              if (block) block(token);
            });
        }else if(code != 6002){
          [JVERIFICATIONService dismissLoginControllerAnimated:YES completion:nil];
        }
    });
  } actionBlock:nil];
}

- (void)back {
  [self dismissLoginControllerAnimated:YES completion:nil];
}

- (void)dismissLoginControllerAnimated:(BOOL)flag completion: (void (^)(void))completion {
  [JVERIFICATIONService dismissLoginControllerAnimated:flag completion:completion];
}

- (void)thirdPatyLogin:(UIButton *)sender {
    [JSHAREService cancelAuthWithPlatform:JSHAREPlatformWechatSession];
    [JSHAREService cancelAuthWithPlatform:JSHAREPlatformQQ];
    switch (sender.tag) {
      case 10: //短信登录
          {
            [self back];
          }
          break;
        case 11: //微信
            {
              [self getUserInfoWithPlatform:JSHAREPlatformWechatSession];
            }
            break;
        case 12: //qq
            {
              [self getUserInfoWithPlatform:JSHAREPlatformQQ];
            }
                break;
        default:
            break;
    }
    
}

- (void)getUserInfoWithPlatform:(JSHAREPlatform)platfrom {
  [JSHAREService getSocialUserInfo:platfrom handler:^(JSHARESocialUserInfo *userInfo, NSError *error) {
    if (platfrom == JSHAREPlatformWechatSession) {
      if (self.wechatBlock) self.wechatBlock(userInfo.name, userInfo.openid, error.description);
    } else if (platfrom == JSHAREPlatformQQ) {
      if (self.qqBlock) self.qqBlock(userInfo.name, userInfo.openid, error.description);
    }
  }];
}

- (void)customUI {
    JVUIConfig *config = [[JVUIConfig alloc] init];
    config.navReturnHidden = YES;
    config.agreementNavReturnImage = [UIImage imageNamed:@"icon-pop-Close"];
    config.autoLayout = YES;
    config.navDividingLineHidden = YES;
    config.prefersStatusBarHidden = NO;
  config.appPrivacyOne = @[@"《用户协议》", [NSString stringWithFormat:@"%@/share/common.html?id=1",XY_SERVICE_HOST]];
    config.appPrivacyTwo = @[@"《隐私协议》", [NSString stringWithFormat:@"%@/share/common.html?id=2",XY_SERVICE_HOST]];
    config.privacyComponents = @[@"登录即同意《",@"》",@"",@""];
   // config.navColor = [UIColor whiteColor];
  config.sloganTextColor = ColorHex(XYTextColor_FFFFFF);
  // [UIColor colorWithRed:187/255.0 green:188/255.0 blue:197/255.0 alpha:1/1.0];
  config.numberColor = ColorHex(XYTextColor_FFFFFF);
    config.logoHidden = YES;
    
  //logo
//     config.logoImg = [UIImage imageNamed:@"logo120"];
//     CGFloat logoWidth = 100;
//     CGFloat logoHeight = logoWidth;
//     JVLayoutConstraint *logoConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
//     JVLayoutConstraint *logoConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:90];
//     JVLayoutConstraint *logoConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:logoWidth];
//     JVLayoutConstraint *logoConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:logoHeight];
//     config.logoConstraints = @[logoConstraintX,logoConstraintY,logoConstraintW,logoConstraintH];
//     config.logoHorizontalConstraints = config.logoConstraints;
  
    //号码栏
    JVLayoutConstraint *numberConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *numberConstraintY = [JVLayoutConstraint constraintWithAttribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeTop multiplier:1 constant:NAVBAR_HEIGHT+AutoSize(190)];
    JVLayoutConstraint *numberConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
    JVLayoutConstraint *numberConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:25];

    config.numberConstraints = @[numberConstraintX,numberConstraintY,numberConstraintW,numberConstraintH];
    
    //slogan展示
    JVLayoutConstraint *sloganConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *sloganConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNumber attribute:NSLayoutAttributeBottom   multiplier:1 constant:8];
    JVLayoutConstraint *sloganConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:130];
    JVLayoutConstraint *sloganConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:20];
    
    config.sloganConstraints = @[sloganConstraintX,sloganConstraintY,sloganConstraintW,sloganConstraintH];
    
    
    //登录按钮
  UIImage *login_nor_image = [[UIImage imageWithColor:ColorHex(XYThemeColor_A) size:CGSizeMake(260, 42)] imageByRoundCornerRadius:21];
  UIImage *login_dis_image = [[UIImage imageWithColor:ColorHex(XYThemeColor_E) size:CGSizeMake(260, 42)] imageByRoundCornerRadius:21];
  UIImage *login_hig_image = [[UIImage imageWithColor:ColorHex(XYThemeColor_A) size:CGSizeMake(260, 42)] imageByRoundCornerRadius:21];
  if (login_nor_image && login_dis_image && login_hig_image) {
      config.logBtnImgs = @[login_nor_image, login_dis_image, login_hig_image];
  }
    config.logBtnText = @"本机号码一键登录";
  config.logBtnFont  = AdaptedFont(17);
    CGFloat loginButtonWidth = AutoSize(295);
    CGFloat loginButtonHeight = AutoSize(44);
    JVLayoutConstraint *loginConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loginConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSlogan attribute:NSLayoutAttributeBottom multiplier:1 constant:22];
    JVLayoutConstraint *loginConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:loginButtonWidth];
    JVLayoutConstraint *loginConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:loginButtonHeight];
    config.logBtnConstraints = @[loginConstraintX,loginConstraintY,loginConstraintW,loginConstraintH];
    
    //勾选框
    
    UIImage * uncheckedImg = [UIImage imageNamed:@"icon_22_option_def"];
    UIImage * checkedImg = [UIImage imageNamed:@"icon_22_option_sel"];
    CGFloat checkViewWidth = 22;
    CGFloat checkViewHeight = 22;
    config.uncheckedImg = uncheckedImg;
    config.checkedImg = checkedImg;
    JVLayoutConstraint *checkViewConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeLeft multiplier:1 constant:35];
    JVLayoutConstraint *checkViewConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemPrivacy attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    JVLayoutConstraint *checkViewConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:checkViewWidth];
    JVLayoutConstraint *checkViewConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:checkViewHeight];
    config.checkViewConstraints = @[checkViewConstraintX,checkViewConstraintY,checkViewConstraintW,checkViewConstraintH];
  
    //隐私
    config.privacyState = YES;
    config.privacyTextFontSize = 12;
    config.privacyTextAlignment = NSTextAlignmentCenter;
    config.appPrivacyColor = @[ColorHex(XYTextColor_999999), ColorHex(XYTextColor_FFFFFF)];
    
    JVLayoutConstraint *privacyConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *privacyConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:(kScreenWidth-100)];

    JVLayoutConstraint *privacyConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-60];
    JVLayoutConstraint *privacyConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
    
    
    config.privacyConstraints = @[privacyConstraintX,privacyConstraintW,privacyConstraintY,privacyConstraintH];
    
    JVLayoutConstraint *privacyConstraintY1 = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeBottom multiplier:1 constant:-16];

    config.privacyHorizontalConstraints = @[privacyConstraintX,privacyConstraintW,privacyConstraintH,privacyConstraintY1];
    
    //loading
    JVLayoutConstraint *loadingConstraintX = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintY = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemSuper attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    JVLayoutConstraint *loadingConstraintW = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeWidth multiplier:1 constant:30];
    JVLayoutConstraint *loadingConstraintH = [JVLayoutConstraint constraintWithAttribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:JVLayoutItemNone attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
  config.navColor = [UIColor clearColor];
    config.loadingConstraints = @[loadingConstraintX,loadingConstraintY,loadingConstraintW,loadingConstraintH];
  // 视频背景
  NSString *path = [NSBundle pathForResourceName:@"login_bg" ofType:@"mp4"];
  [config setVideoBackgroudResource:path placeHolder:nil];
  //setVideoBackgroudResource
  config.navCustom = YES;
  
  // 隐私政策背景
  config.agreementNavBackgroundColor = ColorHex(XYTextColor_FFFFFF);
  config.agreementNavTextColor = ColorHex(XYTextColor_222222);
  config.agreementNavReturnImage = [UIImage imageNamed:@"icon_arrow_back_22"];
  
    [JVERIFICATIONService customUIWithConfig:config customViews:^(UIView *customAreaView) {
      self.customAreaView = customAreaView;
      [self caculateCustomUIFrame];
     // [customAreaView addSubview:self.titleLable];
      //[customAreaView addSubview:self.descLable];
    //  [customAreaView addSubview:self.phoneBtn];
      
     // [customAreaView addSubview:self.bgPlayView];
      
      [customAreaView addSubview:self.topImage];
      
      [customAreaView addSubview:self.btnsView];
    }];
}

- (void)setNeedthirdLogin:(BOOL)needthirdLogin {
  _needthirdLogin = needthirdLogin;
  self.btnsView.hidden = !needthirdLogin;
}

- (void)caculateCustomUIFrame {
    if (!self.customAreaView) {
        return;
    }
  self.topImage.frame = CGRectMake((kScreenWidth-AutoSize(180))/2.0,NAVBAR_HEIGHT+ AutoSize(53), AutoSize(180), AutoSize(100));
 // self.titleLable.frame = CGRectMake(0, 40, kScreenWidth, 40);
  //self.descLable.frame = CGRectMake(0, 92, kScreenWidth, 20);
//  self.phoneBtn.frame = CGRectMake((kScreenWidth-260)/2, 320, 260, 42);
  self.btnsView.frame = CGRectMake((kScreenWidth-220)/2, self.customAreaView.XY_height-165, 220, 60);
}

//- (UIButton *)phoneBtn {
//  if (!_phoneBtn) {
//    _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_phoneBtn setTitle:@"更换号码登录" forState:UIControlStateNormal];
//    [_phoneBtn setTitleColor:ColorHex(@"#666666") forState:UIControlStateNormal];
//    _phoneBtn.titleLabel.font = AdaptedFont(16);
//    [_phoneBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//  }
//  return _phoneBtn;
//}

//- (UILabel *)titleLable {
//  if (!_titleLable) {
//    _titleLable = [[UILabel alloc] init];
//    _titleLable.text = @"欢迎来到喜乡遇";
//    _titleLable.font = AdaptedFont(32);
//    _titleLable.textColor = ColorHex(XYTextColor_222222);
//    _titleLable.textAlignment = NSTextAlignmentCenter;
//  }
//  return _titleLable;
//}

//- (UILabel *)descLable {
//  if (!_descLable) {
//    _descLable = [[UILabel alloc] init];
//    _descLable.text = @"如果手机号码未注册，将自动为您注册";
//    _descLable.font = AdaptedFont(14);
//    _descLable.textColor = ColorHex(XYTextColor_666666);
//    _descLable.textAlignment = NSTextAlignmentCenter;
//  }
//  return _descLable;
//}
-(UIImageView *)topImage{
  if (!_topImage) {
    _topImage = [LSHControl createImageViewWithImageName:@"pic _100_yindao"];
  }
  return _topImage;
}
//-(XYBgPlayView *)bgPlayView{
//  if (!_bgPlayView) {
//    _bgPlayView = [[XYBgPlayView alloc]initWithFrame:[UIScreen mainScreen].bounds];;
//  }
//  return _bgPlayView;
//}
- (UIView *)btnsView {
  if (!_btnsView) {
    _btnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220, 60)];
    NSArray *imgs = @[@"icon_40_shouji",@"icon_40_weixing",@"icon_40_qq"];
    
    NSArray *titles = @[@"验证码登录",@"微信登录",@"QQ登录"];
    CGFloat width = 60 , height = 60;
    CGFloat padding = 20;
    for (int i = 0; i < imgs.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 10;
        [btn setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
      [btn setTitle:titles[i] forState:UIControlStateNormal];
      btn.titleLabel.font = [UIFont systemFontOfSize:10];
        btn.frame = CGRectMake((width+padding)*i, 0, width, height);
        [btn addTarget:self action:@selector(thirdPatyLogin:) forControlEvents:UIControlEventTouchUpInside];
      [btn TiaoZhengButtonWithOffsit:4 TextImageSite:UIButtonTextBottom];
        [_btnsView addSubview:btn];
    }
  }
  return _btnsView;
}
@end
