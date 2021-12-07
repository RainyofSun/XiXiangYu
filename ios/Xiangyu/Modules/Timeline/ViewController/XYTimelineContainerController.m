//
//  XYTimelineContainerController.m
//  Xiangyu
//
//  Created by dimon on 01/02/2021.
//

#import "XYTimelineContainerController.h"
#import "XYScrollContentView.h"
#import "XYDynamicsListController.h"
#import "PopoverView.h"
#import "XYReleaseTimelineController.h"
#import "XYActionAlertView.h"

#import "TZImagePickerController.h"
#import "UIView+TZLayout.h"
#import "TZTestCell.h"
#import <Photos/Photos.h>
#import "LxGridViewFlowLayout.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZAssetCell.h"
#import "YYTextView.h"
#import "FeedbackView.h"

#import "TZImageRequestOperation.h"

@interface XYTimelineContainerController ()<XYPageContentViewDelegate,XYSegmentTitleViewDelegate,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIView * navBgView;

@property (nonatomic, strong) XYSegmentTitleView *titleView;

@property (nonatomic, strong) UIButton * publishBtn;

@property (nonatomic, strong) XYPageContentView *pageContentView;

@property (strong, nonatomic) XYReleaseDynamicDataManager *dataManager;

@property (nonatomic, strong)UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) NSOperationQueue * operationQueue;
@end

@implementation XYTimelineContainerController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupNavBar];
  
  [self setupSubviews];
  
}

#pragma - action
- (void)publish {
  PopoverAction *video = [PopoverAction actionWithImage:[UIImage imageNamed:@"icon_22_photograph"] title:@"拍摄" handler:^(PopoverAction *action) {
    [self takePhotoWithAllowVideo];
   // [self chooseSourceStyleWithShooting:YES];
  }];
  
    PopoverAction *photo = [PopoverAction actionWithImage:[UIImage imageNamed:@"icon_22_album"] title:@"从相册选择" handler:^(PopoverAction *action) {
      [self pushImagePickerControllerWithAllowPickingVideo:NO];
  }];
  
  PopoverAction *text = [PopoverAction actionWithImage:[UIImage imageNamed:@"icon_22_text"] title:@"纯文字" handler:^(PopoverAction *action) {
    XYReleaseTimelineController *vc = [[XYReleaseTimelineController alloc] init];
    vc.type = ReleaseDynamicType_Text;
    vc.dataManager = self.dataManager;
    [self cyl_pushViewController:vc animated:YES];
  }];
  
  PopoverView *popoverView = [PopoverView popoverView];
  popoverView.showShade = YES;
  popoverView.arrowStyle = PopoverViewArrowStyleRound;
  [popoverView showToView:self.publishBtn withActions:@[video,photo,text]];
}

- (void)chooseSourceStyleWithShooting:(BOOL)shooting {
 // XYActionAlertView *alert = [[XYActionAlertView alloc] init];
//  alert.destroy = @"取消";
 // alert.dataSource = @[@"视频",@"图片"];
 // alert.selectedBlock = ^(NSInteger value) {
    //if (value == 0) {
      if (shooting) {
        XYReleaseTimelineController *vc = [[XYReleaseTimelineController alloc] init];
        vc.type = ReleaseDynamicType_Shooting_Video;
        vc.dataManager = self.dataManager;
        [self cyl_pushViewController:vc animated:YES];
      } else {
//        XYReleaseTimelineController *vc = [[XYReleaseTimelineController alloc] init];
//        vc.type = ReleaseDynamicType_Album_Video;
//        [self cyl_pushViewController:vc animated:YES];
        XYReleaseTimelineController *vc = [[XYReleaseTimelineController alloc] init];
        vc.type = ReleaseDynamicType_Album_Photo;
        vc.dataManager = self.dataManager;
        [self cyl_pushViewController:vc animated:YES];
      }
    //} else if (value == 1) {
    //  if (shooting) {
      //  XYReleaseTimelineController *vc = [[XYReleaseTimelineController alloc] init];
      //  vc.type = ReleaseDynamicType_Shooting_Photo;
      //  [self cyl_pushViewController:vc animated:YES];
     // } else {
//  XYReleaseTimelineController *vc = [[XYReleaseTimelineController alloc] init];
//  vc.type = ReleaseDynamicType_Album_Photo;
//  [self cyl_pushViewController:vc animated:YES];
//      }
//    }
//  };
//  [alert show];
}

#pragma mark - XYPageContentViewDelegate
- (void)XYSegmentTitleView:(XYSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)XYContenViewDidEndDecelerating:(XYPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}
#pragma - UI
- (void)setupNavBar {
  self.gk_navigationBar.hidden = YES;
}

- (void)setupSubviews {
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.navBgView];
  [self.navBgView addSubview:self.titleView];
  [self.navBgView addSubview:self.publishBtn];
  [self.view addSubview:self.pageContentView];
}

- (UIView *)navBgView {
  if (!_navBgView) {
    _navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NAVBAR_HEIGHT)];
    _navBgView.backgroundColor = ColorHex(XYThemeColor_B);
  }
  return _navBgView;
}

- (UIButton *)publishBtn {
  if (!_publishBtn) {
    _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_publishBtn setImage:[UIImage imageNamed:@"icon_22_fabu_1"] forState:UIControlStateNormal];
    [_publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    _publishBtn.frame = CGRectMake(kScreenWidth-60, StatusBarHeight(), 44, 44);
  }
  return _publishBtn;
}

- (XYSegmentTitleView *)titleView {
  if (!_titleView) {
    _titleView = [[XYSegmentTitleView alloc]initWithFrame:CGRectMake(0, StatusBarHeight(), 120, 44) titles:@[@"推荐",@"关注"] delegate:self indicatorType:XYIndicatorTypeCustom];
    _titleView.indicatorColor = ColorHex(XYTextColor_635FF0);
    _titleView.titleFont = AdaptedFont(16);
    _titleView.titleSelectFont = AdaptedMediumFont(20);
    _titleView.titleNormalColor = ColorHex(XYTextColor_999999);
    _titleView.titleSelectColor = ColorHex(XYTextColor_222222);
    _titleView.itemMargin = 14;
    _titleView.selectIndex = 0;
    
  }
  return _titleView;
}

-(XYReleaseDynamicDataManager *)dataManager {
  if (!_dataManager) {
    _dataManager = [[XYReleaseDynamicDataManager alloc] init];
  }
  return _dataManager;
}
- (NSOperationQueue *)operationQueue {
  if (!_operationQueue) {
    _operationQueue = [[NSOperationQueue alloc] init];
    _operationQueue.maxConcurrentOperationCount = 3;
  }
  return _operationQueue;
}
- (XYPageContentView *)pageContentView {
  if (!_pageContentView) {
    XYDynamicsListController *recommendVc = [[XYDynamicsListController alloc] init];
    recommendVc.viewType = XYDynamicsViewType_Recommend;
    
    XYDynamicsListController *attentionVc = [[XYDynamicsListController alloc] init];
    attentionVc.viewType = XYDynamicsViewType_Attention;
    
    _pageContentView = [[XYPageContentView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, kScreenWidth, kScreenHeight-NAVBAR_HEIGHT) childVCs:@[recommendVc, attentionVc] parentVC:self delegate:self];
    _pageContentView.contentViewCurrentIndex = 0;
  }
  return _pageContentView;
}


- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
      _imagePickerVc.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}
- (void)pushImagePickerControllerWithAllowPickingVideo:(BOOL)allowPickingVideo {
  TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:allowPickingVideo ? 1 : 9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.selectedAssets = self.dataManager.selectedAssets;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowTakeVideo = NO;
  imagePickerVc.allowPickingVideo = YES;
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    }];
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    //imagePickerVc.allowPickingVideo = allowPickingVideo;
    //imagePickerVc.allowPickingImage = !allowPickingVideo;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO;
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)takePhotoWithAllowVideo{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)) {
        
        NSDictionary *infoDict = [TZCommonTools tz_getInfoDictionary];
        // 无权限 做一个友好的提示
        NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
        if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
        if (!appName) appName = [infoDict valueForKey:@"CFBundleExecutable"];

        NSString *title = [NSBundle tz_localizedStringForKey:@"Can not use camera"];
        NSString *message = [NSString stringWithFormat:[NSBundle tz_localizedStringForKey:@"Please allow %@ to access your camera in \"Settings -> Privacy -> Camera\""],appName];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:[NSBundle tz_localizedStringForKey:@"Cancel"] style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAct];
        UIAlertAction *settingAct = [UIAlertAction actionWithTitle:[NSBundle tz_localizedStringForKey:@"Setting"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alertController addAction:settingAct];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self pushTakePhotoControllerWithAllowVideo];
                });
            }
        }];
    } else {
        [self pushTakePhotoControllerWithAllowVideo];
    }
}

// 调用相机
- (void)pushTakePhotoControllerWithAllowVideo {
    // 提前定位
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: sourceType]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
      //  if (!allowVideo) {
            [mediaTypes addObject:@"public.image"];
       // }
       // if (allowVideo) {
            [mediaTypes addObject:@"public.movie"];
            self.imagePickerVc.videoMaximumDuration = 180;
       // }
        self.imagePickerVc.mediaTypes = mediaTypes;
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}
#pragma mark - UIImagePickerController
- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    [self.dataManager.selectedAssets addObject:asset];
    [self.dataManager.selectedPhotos addObject:image];
  
 // self.imagesView.dataSource = self.dataManager.selectedPhotos;
//    [_collectionView reloadData];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
      XYShowLoading;
        UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediaMetadata];
        if (photo) {
            [[TZImageManager manager] savePhotoWithImage:photo meta:meta location:nil completion:^(PHAsset *asset, NSError *error){
                if (!error && asset) {
                    [self addPHAsset:asset];
                } else {
                  XYHiddenLoading;
                }
            }];
        }
    } else if ([type isEqualToString:@"public.movie"]) {
      XYShowLoading;
        NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
     // self.url = videoUrl;
        if (videoUrl) {
            [[TZImageManager manager] saveVideoWithUrl:videoUrl location:nil completion:^(PHAsset *asset, NSError *error) {
                if (!error && asset) {
                    [self addPHAsset:asset];
                } else {
                  XYHiddenLoading;
                }
            }];
        }
    }
}

- (void)addPHAsset:(PHAsset *)asset {
    XYHiddenLoading;
    TZAssetModel *model = [[TZImageManager manager] createModelWithAsset:asset];
    TZImageRequestOperation *operation = [[TZImageRequestOperation alloc] initWithAsset:model.asset completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
      if (isDegraded) return;
      if (photo) {
          if (![TZImagePickerConfig sharedInstance].notScaleImage) {
              photo = [[TZImageManager manager] scaleImage:photo toSize:CGSizeMake(828, (int)(828 * photo.size.height / photo.size.width))];
          }
      }
      [self callDelegateMethodWithPhoto:photo asset:asset info:info];
    } progressHandler:^(double progress, NSError * _Nonnull error, BOOL * _Nonnull stop, NSDictionary * _Nonnull info) {
      
    }];
  [self.operationQueue addOperation:operation];

}

- (void)callDelegateMethodWithPhoto:(UIImage *)photo
                              asset:(PHAsset *)asset
                               info:(NSDictionary *)info {
  if ([[TZImageManager manager] isVideo:asset]) {
    [self imagePickerController:nil didFinishPickingVideo:photo sourceAssets:asset];
    return;
  }
  [self imagePickerController:nil didFinishPickingPhotos:@[photo] sourceAssets:@[asset] isSelectOriginalPhoto:NO infos:@[info]];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    self.dataManager.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    self.dataManager.selectedAssets = [NSMutableArray arrayWithArray:assets];
 // self.imagesView.dataSource = self.dataManager.selectedPhotos;
   // [_collectionView reloadData];
  [self chooseSourceStyleWithShooting:NO];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    self.dataManager.selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    self.dataManager.selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
  
  
  [self chooseSourceStyleWithShooting:YES];
 // self.imagesView.dataSource = self.dataManager.selectedPhotos;
//  if (self.bottomView) {
  //  self.img.image =coverImage;
  //  self.img2.image =coverImage;
//  }
//
//  XYReleaseTimelineController *vc = [[XYReleaseTimelineController alloc] init];
//  vc.type = ReleaseDynamicType_Text;
//  [self cyl_pushViewController:vc animated:YES];
  
  
  
   // [_collectionView reloadData];
}

// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(PHFetchResult *)result {
    return YES;
}

// 决定asset显示与否
- (BOOL)isAssetCanBeDisplayed:(PHAsset *)asset {
    return YES;
}

// 决定照片能否被选中
- (BOOL)isAssetCanBeSelected:(PHAsset *)asset {
    return YES;
}


@end
