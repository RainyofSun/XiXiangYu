//
//  XYFaceAuthViewController.m
//  Xiangyu
//
//  Created by dimon on 23/03/2021.
//

#import "XYFaceAuthViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "BDFaceAdjustParamsTool.h"
#import "BDFaceLivingConfigModel.h"
#import "XYDefaultButton.h"
#import "BDFaceLivenessViewController.h"
#import "WebViewController.h"
#import "XYImageUploadManager.h"
#import "XYAuthAPI.h"

@interface XYFaceAuthViewController ()

@property (nonatomic, weak) UIImageView *iconView;

@property (nonatomic, weak) UIButton *checkbox;

@property (nonatomic, weak) XYDefaultButton *submitBtn;

@property (nonatomic, strong) UIImage *selectedImage;

@end

@implementation XYFaceAuthViewController

  - (void)viewDidLoad {
      [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavBar];
    [self setupSubviews];
    
    [self initSDK];
    [self initLivenesswithList];
    
  }

#pragma - action
- (void)checkAgreeClick:(UIButton *)sender {
  sender.selected = !sender.isSelected;
  [self updateSubmitBtnStatus];
}

- (void)submit {
  XYShowLoading;
  [[XYImageUploadManager uploadManager] uploadObject:self.selectedImage block:^(BOOL success, NSString *url) {
    NSMutableDictionary *dic_M = self.dataDic.mutableCopy;
    [dic_M setValue:url forKey:@"otherDocumentsUrl"];
    XYAuthAPI *api = [[XYAuthAPI alloc] initWithData:dic_M.copy];
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
      XYHiddenLoading;
      if (error) {
        XYToastText(error.msg);
      } else {
        XYToastText(@"实名认证已提交，请耐心等待审核");
        [self.navigationController popToRootViewControllerAnimated:YES];
      }
    };
    [api start];
  }];
}

- (void)faceLiveness {
  BDFaceLivenessViewController* lvc = [[BDFaceLivenessViewController alloc] init];
  BDFaceLivingConfigModel* model = [BDFaceLivingConfigModel sharedInstance];
  [lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
  @weakify(self);
  lvc.collectBlock = ^(UIImage *image) {
    weak_self.iconView.image = image;
    weak_self.selectedImage = image;
    [weak_self updateSubmitBtnStatus];
  };
  UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
  navi.navigationBarHidden = true;
  navi.modalPresentationStyle = UIModalPresentationFullScreen;
  [self presentViewController:navi animated:YES completion:nil];
}

- (void)updateSubmitBtnStatus {
  self.submitBtn.enabled = self.checkbox.isSelected && self.selectedImage;
}

- (void)setupSubviews {
  
  UIView *bgView = [[UIView alloc] init];
  bgView.backgroundColor = [UIColor whiteColor];
  bgView.frame = CGRectMake(0, NAVBAR_HEIGHT, kScreenWidth, kScreenHeight-NAVBAR_HEIGHT);
  [self.view addSubview:bgView];
  
  UIView *line = [[UIView alloc] init];
  line.backgroundColor = ColorHex(@"#635FF0");
  line.frame = CGRectMake((kScreenWidth-100)/2, 25, 100, 1);
  [bgView addSubview:line];
  
  UILabel *oneStepIconLable = [[UILabel alloc] init];
  oneStepIconLable.textColor = [UIColor whiteColor];
  oneStepIconLable.font = AdaptedMediumFont(12);
  oneStepIconLable.text = @"1";
  oneStepIconLable.backgroundColor = ColorHex(@"#635FF0");
  oneStepIconLable.layer.cornerRadius = 9;
  oneStepIconLable.layer.masksToBounds = YES;
  oneStepIconLable.frame = CGRectMake(CGRectGetMinX(line.frame)-18, 16, 18, 18);
  oneStepIconLable.textAlignment = NSTextAlignmentCenter;
  [bgView addSubview:oneStepIconLable];
  
  UILabel *oneStepTitleLable = [[UILabel alloc] init];
  oneStepTitleLable.textColor = ColorHex(@"#635FF0");
  oneStepTitleLable.font = AdaptedFont(14);
  oneStepTitleLable.text = @"身份识别";
  oneStepTitleLable.frame = CGRectMake(0, CGRectGetMaxY(oneStepIconLable.frame)+8, 60, 18);
  oneStepTitleLable.XY_centerX = oneStepIconLable.XY_centerX;
  oneStepTitleLable.textAlignment = NSTextAlignmentCenter;
  [bgView addSubview:oneStepTitleLable];
  
  UILabel *twoStepIconLable = [[UILabel alloc] init];
  twoStepIconLable.textColor = [UIColor whiteColor];
  twoStepIconLable.font = AdaptedMediumFont(12);
  twoStepIconLable.text = @"2";
  twoStepIconLable.backgroundColor = ColorHex(@"#635FF0");
  twoStepIconLable.layer.cornerRadius = 9;
  twoStepIconLable.layer.masksToBounds = YES;
  twoStepIconLable.frame = CGRectMake(CGRectGetMaxX(line.frame), 16, 18, 18);
  twoStepIconLable.textAlignment = NSTextAlignmentCenter;
  [bgView addSubview:twoStepIconLable];
  
  UILabel *twoStepTitleLable = [[UILabel alloc] init];
  twoStepTitleLable.textColor = ColorHex(@"#635FF0");
  twoStepTitleLable.font = AdaptedFont(14);
  twoStepTitleLable.text = @"人脸识别";
  twoStepTitleLable.frame = CGRectMake(0, CGRectGetMaxY(twoStepIconLable.frame)+8, 60, 18);
  twoStepTitleLable.XY_centerX = twoStepIconLable.XY_centerX;
  twoStepTitleLable.textAlignment = NSTextAlignmentCenter;
  [bgView addSubview:twoStepTitleLable];
  
  UIImageView *iconView = [[UIImageView alloc] init];
  iconView.image = [UIImage imageNamed:@"icon_200_shibie"];
  iconView.frame = CGRectMake((kScreenWidth-200)/2, CGRectGetMaxY(twoStepTitleLable.frame)+48, 200, 200);
  self.iconView = iconView;
  [bgView addSubview:iconView];
  
  UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [startBtn setTitleColor:ColorHex(@"#635FF0") forState:UIControlStateNormal];
  startBtn.titleLabel.font = AdaptedFont(16);
  [startBtn setTitle:@"开始识别" forState:UIControlStateNormal];
  startBtn.layer.borderWidth = 1;
  startBtn.layer.borderColor = ColorHex(@"#D0CFFB").CGColor;
  startBtn.layer.cornerRadius = 16;
  startBtn.layer.masksToBounds = YES;
  startBtn.frame = CGRectMake((kScreenWidth-96)/2, CGRectGetMaxY(iconView.frame)+8, 96, 32);
  [startBtn addTarget:self action:@selector(faceLiveness) forControlEvents:UIControlEventTouchUpInside];
  [bgView addSubview:startBtn];
  
  UILabel *termsLable = [[UILabel alloc] init];
  termsLable.font = AdaptedFont(12);
  termsLable.backgroundColor = ColorHex(@"#FAFAFA");
  termsLable.layer.cornerRadius = 8;
  termsLable.layer.masksToBounds = YES;
  NSString *text = @"声明：人脸识别必须与身份证保持一致，否则会影响APP使用";
  NSMutableAttributedString *attr_M = [[NSMutableAttributedString alloc] initWithString:text];
  [attr_M addAttributes:@{NSForegroundColorAttributeName:ColorHex(@"#FEA619")} range:[text rangeOfString:@"声明："]];
  [attr_M addAttributes:@{NSForegroundColorAttributeName:ColorHex(@"#999999")} range:[text rangeOfString:@"人脸识别必须与身份证保持一致，否则会影响APP使用"]];
  termsLable.attributedText = attr_M;
  termsLable.frame = CGRectMake(16, CGRectGetMaxY(startBtn.frame)+24, kScreenWidth-32, 41);
  termsLable.numberOfLines = 0;
  [bgView addSubview:termsLable];
  
  XYDefaultButton *submitBtn = [XYDefaultButton buttonWithType:UIButtonTypeCustom];
  [submitBtn setTitle:@"提交认证信息" forState:UIControlStateNormal];
  submitBtn.frame = CGRectMake(16, bgView.XY_height-90, kScreenWidth-32, 48);
  self.submitBtn = submitBtn;
  submitBtn.enabled = NO;
  [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
  [bgView addSubview:submitBtn];
  
  
  // 勾选人脸验证协议的button
  UIButton *checkAgreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  checkAgreeBtn.frame = CGRectMake(16, CGRectGetMinY(submitBtn.frame)-46, 22, 22);
  [checkAgreeBtn setImage:[UIImage imageNamed:@"icon_22_option_def"] forState:UIControlStateNormal];
  [checkAgreeBtn setImage:[UIImage imageNamed:@"icon_22_option_sel"] forState:UIControlStateSelected];
  [checkAgreeBtn addTarget:self action:@selector(checkAgreeClick:) forControlEvents:UIControlEventTouchUpInside];
  self.checkbox = checkAgreeBtn;
  [bgView addSubview:checkAgreeBtn];
  
  YYLabel *remindLabel = [[YYLabel alloc] init];
  NSMutableAttributedString * remind_attr = [[NSMutableAttributedString alloc] initWithString:@"已阅读并同意《个人认证服务协议》"];
  remind_attr.yy_font = [UIFont systemFontOfSize:12];
  remind_attr.yy_color = ColorHex(XYTextColor_666666);
  YYTextHighlight * highLight = [YYTextHighlight new];
  NSRange range = [@"已阅读并同意《个人认证服务协议》" rangeOfString:@"《个人认证服务协议》"];
  [remind_attr yy_setColor:ColorHex(XYTextColor_635FF0) range:range];
  highLight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.urlStr = [NSString stringWithFormat:@"%@/share/common.html?id=8",XY_SERVICE_HOST];
    vc.title = @"个人认证服务协议";
    [self cyl_pushViewController:vc animated:YES];
  };
  [remind_attr yy_setTextHighlight:highLight range:range];
  remindLabel.attributedText = remind_attr;
  remindLabel.frame = CGRectMake(CGRectGetMaxX(checkAgreeBtn.frame), 0, kScreenWidth-CGRectGetMaxX(checkAgreeBtn.frame)-16, 22);
  remindLabel.XY_centerY = checkAgreeBtn.XY_centerY;
  [bgView addSubview:remindLabel];
  
}

- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
  self.gk_navTitle = @"个人认证";
}

#pragma mark - UI Action
  - (void) initSDK {
      if (![[FaceSDKManager sharedInstance] canWork]){
          return;
      }
      // 初始化SDK配置参数，可使用默认配置
      // 设置最小检测人脸阈值
      [[FaceSDKManager sharedInstance] setMinFaceSize:200];
      // 设置截取人脸图片高
      [[FaceSDKManager sharedInstance] setCropFaceSizeWidth:480];
      // 设置截取人脸图片宽
      [[FaceSDKManager sharedInstance] setCropFaceSizeHeight:480];
      // 设置人脸遮挡阀值
      [[FaceSDKManager sharedInstance] setOccluThreshold:0.5];
      // 设置亮度阀值
      [[FaceSDKManager sharedInstance] setMinIllumThreshold:40];
      [[FaceSDKManager sharedInstance] setMaxIllumThreshold:240];
      // 设置图像模糊阀值
      [[FaceSDKManager sharedInstance] setBlurThreshold:0.3];
      // 设置头部姿态角度
      [[FaceSDKManager sharedInstance] setEulurAngleThrPitch:10 yaw:10 roll:10];
      // 设置人脸检测精度阀值
      [[FaceSDKManager sharedInstance] setNotFaceThreshold:0.6];
      // 设置抠图的缩放倍数
      [[FaceSDKManager sharedInstance] setCropEnlargeRatio:2.5];
      // 设置照片采集张数
      [[FaceSDKManager sharedInstance] setMaxCropImageNum:1];
      // 设置超时时间
      [[FaceSDKManager sharedInstance] setConditionTimeout:15];
      // 设置开启口罩检测，非动作活体检测可以采集戴口罩图片
      [[FaceSDKManager sharedInstance] setIsCheckMouthMask:true];
      // 设置开启口罩检测情况下，非动作活体检测口罩过滤阈值，默认0.8 不需要修改
      [[FaceSDKManager sharedInstance] setMouthMaskThreshold:0.8f];
      // 设置原始图缩放比例
      [[FaceSDKManager sharedInstance] setImageWithScale:0.8f];
      // 设置图片加密类型，type=0 基于base64 加密；type=1 基于百度安全算法加密
      [[FaceSDKManager sharedInstance] setImageEncrypteType:0];
      // 初始化SDK功能函数
      [[FaceSDKManager sharedInstance] initCollect];
      // 设置人脸过远框比例
      [[FaceSDKManager sharedInstance] setMinRect:0.4];
      
  //    /// 设置用户设置的配置参数
      [BDFaceAdjustParamsTool setDefaultConfig];
  }

  - (void)initLivenesswithList {
      // 默认活体检测打开，顺序执行
      /*
       添加当前默认的动作，是否需要按照顺序，动作活体的数量（设置页面会根据这个numOfLiveness来判断选择了几个动作）
       */
      [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveEye)];
      [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveMouth)];
      BDFaceLivingConfigModel.sharedInstance.isByOrder = NO;
      BDFaceLivingConfigModel.sharedInstance.numOfLiveness = 2;
  }

- (void) destorySDK{
    // 销毁SDK功能函数
    [[FaceSDKManager sharedInstance] uninitCollect];
}

@end

