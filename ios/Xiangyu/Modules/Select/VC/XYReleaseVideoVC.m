//
//  XYReleaseVideoVC.m
//  Xiangyu
//
//  Created by GQLEE on 2021/3/2.
//

#import "XYReleaseVideoVC.h"
#import "YYTextView.h"
#import "XYGeneralAPI.h"
#import "XYUserService.h"
#import "XYImageUploadManager.h"
#import "XYSuccessViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "PlayViewController.h"
#import "XYGeneralAPI.h"
#import "PlayViewController.h"
#import "TZImagePickerController.h"
#import "UIButton+Extension.h"

#import "XYRemindPopView.h"
#import "XYLocationVideo.h"

#ifndef ARRAY_SIZE
#define ARRAY_SIZE(c_array) (sizeof((c_array))/sizeof((c_array)[0]))
#endif

// 颜色
#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define PLS_RGBCOLOR_ALPHA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

// 提示框
#define AlertViewShow(msg) [[[UIAlertView alloc] initWithTitle:@"warning" message:[NSString stringWithFormat:@"%@", msg] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show]

// 屏幕宽高
#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

#define PLS_BaseToolboxView_HEIGHT 64
#define PLS_EditToolboxView_HEIGHT 50
static NSString *const kURLPrefix = @"http://panm32w98.bkt.clouddn.com";

@interface XYReleaseVideoVC () <
PLShortVideoUploaderDelegate,
UIGestureRecognizerDelegate
>{
  NSString *_token;
  id _timeObserver;
  NSString *_type;
}

@property(nonatomic,strong)UIScrollView *scrollView;
// 工具视图
@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) UIView *processerToolboxView;

@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UISlider *playSlider;
@property (strong, nonatomic) UILabel * currentTime;
@property (strong, nonatomic) UILabel * duration;

// 上传视频到云端
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) PLShortVideoUploader *shortVideoUploader;

// 定时器监听
@property (strong, nonatomic) NSTimer * timer;


@property (nonatomic, strong) YYTextView *tv;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIImageView *img2;
@property (nonatomic, strong) UIButton *lab;
@property (nonatomic, strong) UILabel *lab2;
@property (strong, nonatomic) UIButton *releaseButton;



@end

@implementation XYReleaseVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  self.gk_navTitle = @"发布";
  self.gk_navLineHidden = YES;
  self.gk_statusBarStyle = UIStatusBarStyleDefault;
  self.gk_navItemRightSpace = 16;
  self.gk_navItemLeftSpace = 16;
//  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(setupFileUpload)];
  _type = @"1";
  self.gk_navLeftBarButtonItem =
  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qn_icon_close"] style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
  self.gk_navTintColor = ColorHex(XYThemeColor_A);
  
  [self.view addSubview:self.scrollView];
  
  [self.scrollView addSubview:self.tv];
  [self.scrollView addSubview:self.img];
  [self.scrollView addSubview:self.img2];
  [self.scrollView addSubview:self.lab];
  
  self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(self.lab.frame) + ADAPTATIONRATIO * 30);
  //[self.view addSubview:self.lab2];
  [self.view addSubview:self.releaseButton];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChangeNotification:) name:YYTextViewTextDidChangeNotification object:nil];
  
  if (self.contentText) {
    self.tv.text = self.contentText;
  }
  if (self.onePreImage) {
    self.img2.image = self.onePreImage;
  }
  
  
}
#pragma mark -- 视频上传准备
- (void)setupFileUpload {
  [self.view endEditing:YES];
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.progress = 0.0;
    self.progressView.hidden = YES;
    self.progressView.trackTintColor = [UIColor blackColor];
    self.progressView.progressTintColor = [UIColor whiteColor];
    self.progressView.center = self.view.center;
    [self.view addSubview:self.progressView];
    
  
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];

  NSString *method = @"api/v1/Platform/GetQiNiuToken";
  NSDictionary *params = @{
  };

  XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
    api.apiRequestMethodType = XYRequestMethodTypePOST;
  XYShowLoading;
  api.requestParameters = params ?: @{};
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    if (!error) {
      
      [self prepareUpload:data[@"data"]];
    } else {
    }
  };
  [api start];
}
- (void)prepareUpload:(NSString *)kUploadToken {
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *key = [NSString stringWithFormat:@"short_video_%@.mp4", [formatter stringFromDate:[NSDate date]]];
    
    PLSUploaderConfiguration * uploadConfig = [[PLSUploaderConfiguration alloc] initWithToken:kUploadToken videoKey:key https:YES recorder:nil];
    self.shortVideoUploader = [[PLShortVideoUploader alloc] initWithConfiguration:uploadConfig];
    self.shortVideoUploader.delegate = self;
    NSString *filePath = _url.path;
  XYShowLoading;
    [self.shortVideoUploader uploadVideoFile:filePath];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)backButtonClick {
  [self.view endEditing:YES];
  
  
 BOOL result = [[XYLocationVideo sharedService] queryLocationVideoItemWithVideo:self.url.path];
  if (result) {
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
  }
  
  
  UIAlertController *actionVC=[UIAlertController alertControllerWithTitle:@"确定放弃发布吗" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
  
  UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
  
  UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"返回编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }];
  
  UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"保存草稿箱" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
     
    [XYLocationVideoItem saveLocationVideoWithUrl:self.url image:self.img2.image text:self.tv.text block:^(XYLocationVideoItem * _Nonnull item) {
      [[XYLocationVideo sharedService] insetVideoDataWithItem:item block:^(BOOL ret) {
        if (ret) {
          UIViewController *vc =  self;
          while (vc.presentingViewController) {
              vc = vc.presentingViewController;
          }
          [vc dismissViewControllerAnimated:YES completion:^{
            XYToastText(@"保存成功");
          }];
         
        }
      }];
    }];
    
    
  }];

  
  [actionVC addAction:maleAction];
  [actionVC addAction:femaleAction];
  [actionVC addAction:cancelAction];
  
  [self presentViewController:actionVC animated:YES completion:nil];
  
 
}
- (void)sure {
  
  
  NSString *method = @"api/v1/ShortVideo/ReleaseVideo";
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  if (_token.length < 1) {
    XYToastText(@"展示图片获取失败");
    return;
  }
  if (_tv.text.length < 1) {
    XYToastText(@"请输入作品简介");
    return;
  }


  NSDictionary *params = @{
     @"userId": user.userId,
     @"coverUrl": _token,
     @"content": _tv.text,
     @"videoType": @1,
     @"videoUrl": _urlString
  };

  XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
    api.apiRequestMethodType = XYRequestMethodTypePOST;
  
  api.requestParameters = params ?: @{};
  XYShowLoading;
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    if (!error) {
      BOOL result = [[XYLocationVideo sharedService] queryLocationVideoItemWithVideo:self.url.path];
      if (result) {
        [[XYLocationVideo sharedService] cleanVideoDataWithVideo:self.url.path block:^(BOOL ret) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"KreleaseVideoSuccess" object:nil];
        }];
      }
     
      UIViewController *vc =  self;
      while (vc.presentingViewController) {
          vc = vc.presentingViewController;
      }
      [vc dismissViewControllerAnimated:YES completion:^{
        XYSuccessViewController *toVC = [[XYSuccessViewController alloc] init];
        toVC.titleL = @"发布成功";
        toVC.decL = @"您发布的视频将在系统审核后显示";
          [[self getCurrentVC] presentViewController:toVC animated:YES completion:nil];
      }];
     
    

    } else {

    }
  };
  [api start];
  
}
-(UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

-(UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
      
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {

        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
     
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
       
     
        currentVC = rootVC;
    }
    
    return currentVC;
}

#pragma mark -- 提示框
- (void)showAlertWithMessage:(NSString *)message {
    NSLog(@"alert message: %@", message);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - PLShortVideoUploaderDelegate 视频上传
- (void)shortVideoUploader:(PLShortVideoUploader *)uploader completeInfo:(PLSUploaderResponseInfo *)info uploadKey:(NSString *)uploadKey resp:(NSDictionary *)resp {
  XYHiddenLoading;
    self.progressView.hidden = YES;
    if(info.error){
        [self showAlertWithMessage:[NSString stringWithFormat:@"上传失败，error: %@", info.error]];
        return ;
    }
    NSString *urlString = [NSString stringWithFormat:@"http://img.xixiangyuapp.com/%@", resp[@"key"]];
//  vc.urlString = urlString;
  
  _urlString =urlString;
  NSData *imageData = UIImagePNGRepresentation([self getLocationVideoPreViewImage:_url]);
  if ([_type isEqualToString:@"1"]) {
    XYShowLoading;
    [[XYImageUploadManager uploadManager] uploadObject:imageData block:^(BOOL success, NSString *token) {
      XYHiddenLoading;
      _token =token;
      [self sure];
    }];
  }else {
    [self sure];
  }
  
}
// 获取本地视频第一帧
- (UIImage*) getLocationVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

- (void)shortVideoUploader:(PLShortVideoUploader *)uploader uploadKey:(NSString *)uploadKey uploadPercent:(float)uploadPercent {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView.progress = uploadPercent;
    });
    NSLog(@"uploadKey: %@",uploadKey);
    NSLog(@"uploadPercent: %.2f",uploadPercent);
}

- (void)dealloc {

    self.shortVideoUploader = nil;
    
    self.baseToolboxView = nil;
    
    NSLog(@"dealloc: %@", [[self class] description]);
}
-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:YES];
  
    self.gk_navItemLeftSpace = 16;
}
-(void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:YES];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

-(void)textViewDidChangeNotification:(NSNotification *)obj{
    NSString *string = _tv.text;
    NSInteger maxLength = 100;
    //获取高亮部分
    YYTextRange *selectedRange = [_tv valueForKey:@"_markedTextRange"];
    NSRange range = [selectedRange asRange];
    NSString *realString = [string substringWithRange:NSMakeRange(0, string.length - range.length)];
    if (realString.length >= maxLength){
      _tv.text = [realString substringWithRange:NSMakeRange(0, maxLength)];
    }
}
-(UIScrollView *)scrollView{
  if (!_scrollView) {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT-SafeAreaBottom()-ADAPTATIONRATIO * 140)];
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (@available(iOS 11.0, *)) {
      _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      _scrollView.scrollIndicatorInsets = _scrollView.contentInset;
    }
  }
  return _scrollView;
}
-(YYTextView *)tv {
  if (!_tv) {
    _tv = [[YYTextView alloc] initWithFrame:CGRectMake(ADAPTATIONRATIO * 30,ADAPTATIONRATIO * 48 , SCREEN_WIDTH - ADAPTATIONRATIO * 60, ADAPTATIONRATIO *280)];
    _tv.placeholderText = @"请输入作品简介";
    _tv.placeholderFont =[UIFont systemFontOfSize:28 *ADAPTATIONRATIO];
    _tv.layer.borderWidth =ADAPTATIONRATIO *1;
    _tv.layer.borderColor = ColorHex(@"#E6E6E6").CGColor;
    _tv.font = [UIFont systemFontOfSize:28 *ADAPTATIONRATIO];
    _tv.layer.masksToBounds = YES;
    _tv.layer.cornerRadius = 8;
  }
  return  _tv;
}

- (UIImageView *)img {
  if (!_img) {
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(ADAPTATIONRATIO * 30,ADAPTATIONRATIO * 360 ,  (SCREEN_WIDTH-ADAPTATIONRATIO *90)/2.0, ADAPTATIONRATIO *580 )];
    _img.image = [self getLocationVideoPreViewImage:_url];
    _img.contentMode = UIViewContentModeScaleAspectFill;
    _img.layer.cornerRadius = 10;
    _img.layer.masksToBounds = YES;
    [_img setUserInteractionEnabled:YES];
    UIView *bg = [[UIView alloc] initWithFrame:_img.bounds];
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(bg.mj_w/2.0-ADAPTATIONRATIO * 32,bg.mj_h/2.0-ADAPTATIONRATIO * 32,  ADAPTATIONRATIO * 64, ADAPTATIONRATIO *64 )];
    img.image = [UIImage imageNamed:@"bofang"];
    
    [bg addSubview:img];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:bg.bounds];
    [btn addTarget:self action:@selector(clickBtn1) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];
    [_img addSubview:bg];
  }
  return  _img;
}
- (void)clickBtn1 {
  [self.view endEditing:YES];
    PlayViewController *uploadController = [[PlayViewController alloc] init];
         uploadController.actionType = PLSActionTypePlayer;
      uploadController.url = _url;
       uploadController.modalPresentationStyle = UIModalPresentationFullScreen;
       [self presentViewController:uploadController animated:YES completion:nil];

}
- (UIImageView *)img2 {
  if (!_img2) {
    _img2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0+ADAPTATIONRATIO * 15, ADAPTATIONRATIO * 360 ,  (SCREEN_WIDTH-ADAPTATIONRATIO *90)/2.0, ADAPTATIONRATIO *580 )];
    _img2.image = [self getLocationVideoPreViewImage:_url];
    _img2.contentMode = UIViewContentModeScaleAspectFill;
    _img2.layer.cornerRadius = 10;
    _img2.layer.masksToBounds = YES;
    [_img2 setUserInteractionEnabled:YES];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, _img2.mj_h-ADAPTATIONRATIO *60, _img2.mj_w, ADAPTATIONRATIO *60)];
    bg.backgroundColor = [UIColor blackColor];
    bg.alpha = 0.3;
    UILabel *lab = [[UILabel alloc] initWithFrame:bg.bounds];
    lab.text = @"选封面";
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:ADAPTATIONRATIO *28];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.alpha = 1;
    [bg addSubview:lab];
    [_img2 addSubview:bg];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:_img2.bounds];
    [btn addTarget:self action:@selector(clickBtn2) forControlEvents:UIControlEventTouchUpInside];
    [_img2 addSubview:btn];
  }
  return  _img2;
}
- (void)clickBtn2 {
  [self.view endEditing:YES];
  MJWeakSelf

  TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
     imagePickerVc.isSelectOriginalPhoto = NO;
     imagePickerVc.allowTakePicture = YES;
     imagePickerVc.allowTakeVideo = NO;
     imagePickerVc.videoMaximumDuration = 180;
     [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
         imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
     }];
     imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
     imagePickerVc.showPhotoCannotSelectLayer = YES;
     imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
     imagePickerVc.allowPickingVideo = NO;
     imagePickerVc.allowPickingImage = YES;
     imagePickerVc.allowPickingOriginalPhoto = NO;
     imagePickerVc.allowPickingGif = NO;
     imagePickerVc.allowPickingMultipleVideo = NO;
     imagePickerVc.sortAscendingByModificationDate = YES;
     imagePickerVc.showSelectBtn = NO;
     imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
     imagePickerVc.showSelectedIndex = YES;
     imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
     imagePickerVc.didFinishPickingPhotosHandle = ^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
       XYShowLoading;
       [[XYImageUploadManager uploadManager] uploadObject:photos[0] block:^(BOOL success, NSString *token) {
         XYHiddenLoading;
         _token =token;
         _type = @"2";
         NSURL *imageUrl = [NSURL URLWithString:token];
             UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
         weakSelf.img2.image = image;
       }];
     };
     [self presentViewController:imagePickerVc animated:YES completion:nil];

  
}
- (UIButton *)lab {
  if (!_lab) {
    _lab = [[UIButton alloc] initWithFrame:CGRectMake(ADAPTATIONRATIO * 30, CGRectGetMaxY(_img.frame) + ADAPTATIONRATIO * 30, ADAPTATIONRATIO * 280, ADAPTATIONRATIO * 30)];
//    _lab.text = @"视频发布规范须知";
    [_lab setTitle:@"视频发布规范须知" forState:UIControlStateNormal];
    _lab.titleLabel.font = [UIFont systemFontOfSize:ADAPTATIONRATIO *28];
    [_lab setTitleColor:ColorHex(@"#6160F0") forState:UIControlStateNormal];
    [_lab setImage:[UIImage imageNamed:@"remind"] forState:UIControlStateNormal];
    _lab.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_lab horizontalCenterTitleAndImage];
    [_lab addTarget:self action:@selector(remindClickAction:) forControlEvents:UIControlEventTouchUpInside];
    //_lab.textColor = ColorHex(@"#6160F0");
  }
  return _lab;
}
-(void)remindClickAction:(id)sender{
  [self.view endEditing:YES];
  XYRemindPopView *popView=[[XYRemindPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/0.85)];
  [popView show];
}
- (UILabel *)lab2 {
  if (!_lab2) {
    _lab2 = [[UILabel alloc] initWithFrame:CGRectMake(ADAPTATIONRATIO * 30, CGRectGetMaxY(_lab.frame), SCREEN_WIDTH - ADAPTATIONRATIO * 60, ADAPTATIONRATIO * 200)];
    _lab2.text = @"1.含有违法、不文明、过度性感的短视频将被删除。\n2.用户自行承担侵权短视频责任。\n3.非认证用户禁止发广告短视频。\n4.如需增加曝光量，请在个人中心->广告发布提交申请。";
    _lab2.textColor = ColorHex(@"#666666");
    _lab2.font = [UIFont systemFontOfSize:ADAPTATIONRATIO *24];
    _lab2.numberOfLines = 8;
  }
  return _lab2;
}
- (UIButton *)releaseButton {
  if (!_releaseButton) {
    _releaseButton = [[UIButton alloc] initWithFrame:CGRectMake(ADAPTATIONRATIO * 30, SCREEN_HEIGHT-ADAPTATIONRATIO * 140-SafeAreaBottom(), SCREEN_WIDTH - ADAPTATIONRATIO * 60, ADAPTATIONRATIO * 88)];
    [_releaseButton setBackgroundColor:ColorHex(@"#F92B5E")];
    [_releaseButton setTitle:@"发布视频" forState:UIControlStateNormal];
    [_releaseButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    _releaseButton.layer.cornerRadius = ADAPTATIONRATIO * 44;
    _releaseButton.layer.masksToBounds = YES;
    [_releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_releaseButton addTarget:self action:@selector(setupFileUpload) forControlEvents:UIControlEventTouchUpInside];
  }
  return _releaseButton;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
