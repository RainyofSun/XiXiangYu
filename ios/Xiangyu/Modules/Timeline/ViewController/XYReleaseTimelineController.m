//
//  XYReleaseTimelineController.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/3/14.
//

#import "XYReleaseTimelineController.h"
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

#import "ShowImagesView.h"
#import "XYTopicModel.h"

#import "XYAddTopicViewController.h"

#import "XYHotTopicView.h"

#import "PlayViewController.h"
@interface XYReleaseTimelineController ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    CGFloat _itemWH;
    CGFloat _margin;
}
//@property (nonatomic, strong) UICollectionView *collectionView;
//@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) FeedbackView *textView;

@property (nonatomic, strong)UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) NSOperationQueue * operationQueue;

@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)UIButton *releaseButton;

@property(nonatomic,strong)ShowImagesView *imagesView;


@property(nonatomic,strong)UIView *bottomView;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIImageView *img2;
// 话题
@property(nonatomic,strong)XYHotTopicView *topicView;
//@property(nonatomic,strong)XYTopicModel * __nullable topicmodel;
//@property(nonatomic,strong)UIButton *closeBtn;

@property(nonatomic,strong)NSURL *url;
//
@end

@implementation XYReleaseTimelineController

- (void)viewDidLoad {
    [super viewDidLoad];
  CGFloat rgb = 244 / 255.0;
  self.view.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    [self setupNavBar];
    [self configCollectionView];
  
  [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
  [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
  
  
 
//  [self.view handleTapGestureRecognizerEventWithBlock:^(id sender) {
//    [self.view endEditing:YES];
//  }];
}

- (void)submit {
  [self.view endEditing:YES];
  if (self.type == ReleaseDynamicType_Text) {
    self.dataManager.type = 1;
  } else if (self.type == ReleaseDynamicType_Album_Photo || self.type == ReleaseDynamicType_Shooting_Photo) {
    self.dataManager.type = 2;
  } else if (self.type == ReleaseDynamicType_Album_Video || self.type == ReleaseDynamicType_Shooting_Video) {
    self.dataManager.type = 3;
  }
  
  self.dataManager.subjectId = self.topicView.model.id;
  self.dataManager.subjectText = self.topicView.model.title;
  
  if (!self.textView.textView.text.isNotBlank) {
    XYToastText(@"请输入动态内容");
    return;
  }
  self.dataManager.content = self.textView.textView.text;
  XYShowLoading;
  [self.dataManager releaseDynamicWithBlock:^(XYError *error) {
    XYHiddenLoading;
    if (error) {
      XYToastText(error.msg);
    } else {
      XYToastText(@"发布成功");
      [self.navigationController popViewControllerAnimated:YES];
    }
  }];
}

//- (void)deleteBtnClik:(UIButton *)sender {
//  [self.view endEditing:YES];
//    if ([self collectionView:self.collectionView numberOfItemsInSection:0] <= self.dataManager.selectedPhotos.count) {
//        [self.dataManager.selectedPhotos removeObjectAtIndex:sender.tag];
//        [self.dataManager.selectedAssets removeObjectAtIndex:sender.tag];
//        [self.collectionView reloadData];
//        return;
//    }
//
//    [self.dataManager.selectedPhotos removeObjectAtIndex:sender.tag];
//    [self.dataManager.selectedAssets removeObjectAtIndex:sender.tag];
//    [_collectionView performBatchUpdates:^{
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
//        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
//    } completion:^(BOOL finished) {
//        [self->_collectionView reloadData];
//    }];
//}

#pragma mark UICollectionView
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    if (self.dataManager.selectedPhotos.count >= 9) {
//        return self.dataManager.selectedPhotos.count;
//    }
//
//    for (PHAsset *asset in self.dataManager.selectedAssets) {
//        if (asset.mediaType == PHAssetMediaTypeVideo) {
//            return self.dataManager.selectedPhotos.count;
//        }
//    }
//    return self.dataManager.selectedPhotos.count + 1;
//}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
//    cell.videoImageView.hidden = YES;
//    if (indexPath.item == self.dataManager.selectedPhotos.count) {
//        cell.imageView.image = [UIImage imageNamed:@"AlbumAddBtn.png"];
//        cell.deleteBtn.hidden = YES;
//        cell.gifLable.hidden = YES;
//    } else {
//        cell.imageView.image = self.dataManager.selectedPhotos[indexPath.item];
//        cell.asset = self.dataManager.selectedAssets[indexPath.item];
//        cell.deleteBtn.hidden = NO;
//    }
//    cell.gifLable.hidden = YES;
//    cell.deleteBtn.tag = indexPath.item;
//    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
//    return cell;
//}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//  [self.view endEditing:YES];
//    if (indexPath.item == self.dataManager.selectedPhotos.count) {
//      [self chooseSourceStyle];
//    } else { // preview photos or video / 预览照片或者视频
//        PHAsset *asset = self.dataManager.selectedAssets[indexPath.item];
//        BOOL isVideo = NO;
//        isVideo = asset.mediaType == PHAssetMediaTypeVideo;
//        if ([[asset valueForKey:@"filename"] containsString:@"GIF"]) {
//            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
//            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
//            vc.model = model;
//            vc.modalPresentationStyle = UIModalPresentationFullScreen;
//            [self presentViewController:vc animated:YES completion:nil];
//        } else if (isVideo) { // perview video / 预览视频
//            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
//            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
//            vc.model = model;
//            vc.modalPresentationStyle = UIModalPresentationFullScreen;
//            [self presentViewController:vc animated:YES completion:nil];
//        } else { // preview photos / 预览照片
//            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.dataManager.selectedAssets selectedPhotos:self.dataManager.selectedPhotos index:indexPath.item];
//            imagePickerVc.maxImagesCount = 9;
//            imagePickerVc.allowPickingGif = NO;
//            imagePickerVc.autoSelectCurrentWhenDone = NO;
//            imagePickerVc.allowPickingOriginalPhoto = NO;
//            imagePickerVc.allowPickingMultipleVideo = NO;
//            imagePickerVc.showSelectedIndex = YES;
//            imagePickerVc.isSelectOriginalPhoto = NO;
//            imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
//            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//                self.dataManager.selectedPhotos = [NSMutableArray arrayWithArray:photos];
//                self.dataManager.selectedAssets = [NSMutableArray arrayWithArray:assets];
//                [self->_collectionView reloadData];
//                self->_collectionView.contentSize = CGSizeMake(0, ((self.dataManager.selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
//            }];
//            [self presentViewController:imagePickerVc animated:YES completion:nil];
//        }
//    }
//}

//#pragma mark - LxGridViewDataSource
//- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
//    return indexPath.item < self.dataManager.selectedPhotos.count;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
//    return (sourceIndexPath.item < self.dataManager.selectedPhotos.count && destinationIndexPath.item < self.dataManager.selectedPhotos.count);
//}
//
//- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
//    UIImage *image = self.dataManager.selectedPhotos[sourceIndexPath.item];
//    [self.dataManager.selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
//    [self.dataManager.selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
//
//    id asset = self.dataManager.selectedAssets[sourceIndexPath.item];
//    [self.dataManager.selectedAssets removeObjectAtIndex:sourceIndexPath.item];
//    [self.dataManager.selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
//
//    [_collectionView reloadData];
//}
//-(void)resetTopicTitle:(NSString *)title canDel:(BOOL)del{
//
//  self.closeBtn.hidden = !del;
//
//  NSMutableAttributedString *all_attr = [NSMutableAttributedString new];
//
//
//
//  NSMutableAttributedString *textt_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"#"]];
//  textt_attr.yy_font = AdaptedFont(15);
//  textt_attr.yy_color = ColorHex(@"#F92B5E");
//  [all_attr appendAttributedString:textt_attr];
//
//  //创建属性字符串
//  NSMutableAttributedString *text_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", title?:@""]];
//  text_attr.yy_font = AdaptedFont(14);
//  text_attr.yy_color = ColorHex(XYTextColor_333333);
//  [all_attr appendAttributedString:text_attr];
//
////  if (del) {
////    UIImage *image = [UIImage imageNamed: @"close"];
////    NSMutableAttributedString *image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:AdaptedFont(14) alignment:YYTextVerticalAlignmentCenter];
////    [all_attr appendAttributedString:image_attr];
////  }
//
//
//
//
//
//
//  self.topicLabel.attributedText = all_attr;
//  [self.topicLabel sizeToFit];
//
//  CGSize size =  self.topicLabel.size;
//
//  [self.topicLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//    make.width.mas_equalTo(size.width+AutoSize(20));
//  }];
//  self.topicLabel.textAlignment = NSTextAlignmentCenter;
//
//
//}

-(void)imageYuLan:(NSInteger)index{
   // preview photos or video / 预览照片或者视频
      PHAsset *asset = self.dataManager.selectedAssets[index];
      BOOL isVideo = NO;
      isVideo = asset.mediaType == PHAssetMediaTypeVideo;
      if ([[asset valueForKey:@"filename"] containsString:@"GIF"]) {
          TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
          TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
          vc.model = model;
          vc.modalPresentationStyle = UIModalPresentationFullScreen;
          [self presentViewController:vc animated:YES completion:nil];
      } else if (isVideo) { // perview video / 预览视频
          TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
          TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
          vc.model = model;
          vc.modalPresentationStyle = UIModalPresentationFullScreen;
          [self presentViewController:vc animated:YES completion:nil];
      } else { // preview photos / 预览照片
          TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:self.dataManager.selectedAssets selectedPhotos:self.dataManager.selectedPhotos index:index];
          imagePickerVc.maxImagesCount = 9;
          imagePickerVc.allowPickingGif = NO;
          imagePickerVc.autoSelectCurrentWhenDone = NO;
          imagePickerVc.allowPickingOriginalPhoto = NO;
          imagePickerVc.allowPickingMultipleVideo = NO;
          imagePickerVc.showSelectedIndex = YES;
          imagePickerVc.isSelectOriginalPhoto = NO;
          imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
          [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
              self.dataManager.selectedPhotos = [NSMutableArray arrayWithArray:photos];
              self.dataManager.selectedAssets = [NSMutableArray arrayWithArray:assets];
            
            
            self.imagesView.dataSource = self.dataManager.selectedPhotos;
//              [self->_collectionView reloadData];
//              self->_collectionView.contentSize = CGSizeMake(0, ((self.dataManager.selectedPhotos.count + 2) / 3 ) * (self->_margin + self->_itemWH));
          }];
          [self presentViewController:imagePickerVc animated:YES completion:nil];
      }
  
}

#pragma mark - TZImagePickerController

- (void)chooseSourceStyle {
  switch (self.type) {
    case ReleaseDynamicType_Shooting_Photo:
      [self takePhotoWithAllowVideo:NO];
      break;
    case ReleaseDynamicType_Shooting_Video:
      [self takePhotoWithAllowVideo:YES];
      break;
    case ReleaseDynamicType_Album_Photo:
      [self pushImagePickerControllerWithAllowPickingVideo:NO];
      break;
    case ReleaseDynamicType_Album_Video:
      [self pushImagePickerControllerWithAllowPickingVideo:YES];
      break;
    default:
      break;
  }
}

- (void)pushImagePickerControllerWithAllowPickingVideo:(BOOL)allowPickingVideo {
  TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:allowPickingVideo ? 1 : 9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;
    imagePickerVc.selectedAssets = self.dataManager.selectedAssets;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowTakeVideo = NO;
    [imagePickerVc setUiImagePickerControllerSettingBlock:^(UIImagePickerController *imagePickerController) {
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
    }];
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    imagePickerVc.allowPickingVideo = allowPickingVideo;
    imagePickerVc.allowPickingImage = !allowPickingVideo;
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

- (void)takePhotoWithAllowVideo:(BOOL)allowVideo {
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
                    [self pushTakePhotoControllerWithAllowVideo:allowVideo];
                });
            }
        }];
    } else {
        [self pushTakePhotoControllerWithAllowVideo:allowVideo];
    }
}

// 调用相机
- (void)pushTakePhotoControllerWithAllowVideo:(BOOL)allowVideo {
    // 提前定位
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: sourceType]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        if (!allowVideo) {
            [mediaTypes addObject:@"public.image"];
        }
        if (allowVideo) {
            [mediaTypes addObject:@"public.movie"];
            self.imagePickerVc.videoMaximumDuration = 180;
        }
        self.imagePickerVc.mediaTypes = mediaTypes;
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
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

#pragma mark - UIImagePickerController
- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    [self.dataManager.selectedAssets addObject:asset];
    [self.dataManager.selectedPhotos addObject:image];
  
  self.imagesView.dataSource = self.dataManager.selectedPhotos;
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
      self.url = videoUrl;
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
  self.imagesView.dataSource = self.dataManager.selectedPhotos;
   // [_collectionView reloadData];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(PHAsset *)asset {
    self.dataManager.selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    self.dataManager.selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
  self.imagesView.dataSource = self.dataManager.selectedPhotos;
  if (self.bottomView) {
    self.img.image =coverImage;
    self.img2.image =coverImage;
  }
  
  
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

#pragma mark - Click Event
- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
//  UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
//  [doneBtn setTitle:@"发布" forState:UIControlStateNormal];
//  [doneBtn setTitleColor:ColorHex(XYTextColor_FE2D63) forState:UIControlStateNormal];
//  doneBtn.titleLabel.font = AdaptedFont(15);
//  [doneBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
//  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
  self.gk_navTitle = @"发布动态";
}

- (void)configCollectionView {
  
  
  self.mainScrollView.backgroundColor = ColorHex(XYTextColor_FFFFFF);
  [self.view addSubview:self.mainScrollView];
  [self.mainScrollView addSubview:self.textView];
  [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.view).offset(AutoSize(16));
    make.top.equalTo(self.mainScrollView).offset(AutoSize(20));
    make.centerX.equalTo(self.view);
    make.height.mas_equalTo(AutoSize(140));
  }];
  
  
  
  [self.mainScrollView addSubview:self.topicView];
  [self.view addSubview:self.releaseButton];
  if (self.type == ReleaseDynamicType_Album_Photo) {
    ShowImagesView *showView=[[ShowImagesView alloc]initWithFrame:CGRectMake(AutoSize(0),0, SCREEN_WIDTH-AutoSize(0), AutoSize(80))];
     showView.lineNum = 3;
    showView.backgroundColor = [UIColor whiteColor];
    showView.maxNum = (self.type == ReleaseDynamicType_Shooting_Video ||self.type == ReleaseDynamicType_Album_Video )?1: 9;
    showView.spaceItem = AutoSize(10);
     showView.setoff = AutoSize(15);
 
   // @weakify(self);
   showView.dataSource=self.dataManager.selectedPhotos;
    @weakify(self);
 showView.addblock = ^(id obj) {
        @strongify(self);
   [self.textView resignFirstResponder];
   [self chooseSourceStyle];
    };
    @weakify(showView);
 showView.selectedblock = ^(NSInteger index, id obj) {
        @strongify(self);
        @strongify(showView);
   [self.textView resignFirstResponder];
        if ([obj boolValue]) {
      
          [self imageYuLan:index];
        }else{
           [self.dataManager.selectedAssets removeObjectAtIndex:index];
          [self.dataManager.selectedPhotos removeObjectAtIndex:index];
          showView.dataSource=self.dataManager.selectedPhotos ;
        }
    };
    

    [self.mainScrollView addSubview:showView];
 
 [showView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.leading.equalTo(self.view);
     make.trailing.equalTo(self.view).offset(-AutoSize(20));
     make.top.equalTo(self.textView.mas_bottom).offset(AutoSize(10));
 }];
    self.imagesView = showView;
    [self.topicView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.leading.equalTo(self.textView);
      make.top.equalTo(showView.mas_bottom).offset(AutoSize(10));
      make.height.mas_equalTo(AutoSize(24));
      make.trailing.lessThanOrEqualTo(self.textView.mas_trailing);
      make.bottom.equalTo(self.mainScrollView).offset(-AutoSize(20)).priority(800);
    }];
    //
    
  }else    if (self.type == ReleaseDynamicType_Shooting_Video){
    self.bottomView = [LSHControl viewWithBackgroundColor:ColorHex(XYTextColor_FFFFFF)];
    [self.mainScrollView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.top.equalTo(self.textView.mas_bottom).offset(AutoSize(10));
      make.height.mas_equalTo(ADAPTATIONRATIO *580);
    }];
    
    [self.bottomView addSubview:self.img];
    [self.bottomView addSubview:self.img2];
    
    
    [self.topicView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.leading.equalTo(self.textView);
      make.top.equalTo(self.bottomView.mas_bottom).offset(AutoSize(10));
      make.height.mas_equalTo(AutoSize(24));
      make.trailing.lessThanOrEqualTo(self.textView.mas_trailing);
      make.bottom.equalTo(self.mainScrollView).offset(-AutoSize(20)).priority(800);
    }];
    //[self chooseSourceStyle];
    
  } else {
    [self.topicView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.leading.equalTo(self.textView);
      make.top.equalTo(self.textView.mas_bottom).offset(AutoSize(20));
      make.height.mas_equalTo(AutoSize(24));
      make.trailing.lessThanOrEqualTo(self.textView.mas_trailing);
      make.bottom.equalTo(self.mainScrollView).offset(-AutoSize(20)).priority(800);
    }];
  }
  
//  [self.view addSubview:self.closeBtn];
//  [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.leading.equalTo(self.topicLabel.mas_trailing);
//    make.centerY.equalTo(self.topicLabel);
//    make.width.height.mas_equalTo(AutoSize(18));
//  }];
//  [self resetTopicTitle:@"添加话题" canDel:NO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//  _textView.frame = CGRectMake(16, NAVBAR_HEIGHT+8, kScreenWidth-16, 200);
//
//  if (self.type != ReleaseDynamicType_Text) {
//    _margin = 4;
//    _itemWH = (self.view.tz_width - 2 * _margin - 4) / 3 - _margin;
//    _layout.itemSize = CGSizeMake(_itemWH, _itemWH);
//    _layout.minimumInteritemSpacing = _margin;
//    _layout.minimumLineSpacing = _margin;
//    [self.collectionView setCollectionViewLayout:_layout];
//    CGFloat collectionViewY = CGRectGetMaxY(_textView.frame);
//    self.collectionView.frame = CGRectMake(0, collectionViewY, self.view.tz_width, self.view.tz_height - collectionViewY);
//  }
}
-(UIScrollView *)mainScrollView{
  if (!_mainScrollView) {
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT-SafeAreaBottom()-ADAPTATIONRATIO * 140)];
    _mainScrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (@available(iOS 11.0, *)) {
      _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      _mainScrollView.scrollIndicatorInsets = _mainScrollView.contentInset;
    }
  }
  return _mainScrollView;
}
-(FeedbackView *)textView {
  if (!_textView) {
    _textView = [[FeedbackView alloc] initWithFrame:CGRectMake(0,ADAPTATIONRATIO * 40 , SCREEN_WIDTH, ADAPTATIONRATIO *280)];
    _textView.textView.placeholder = @"这一刻的想法...";

   // _textView.layer.borderWidth =ADAPTATIONRATIO *1;
    //_textView.layer.borderColor = ColorHex(@"#E6E6E6").CGColor;
   // _textView.font = AdaptedFont(14);
   // _textView.layer.masksToBounds = YES;
   // _textView.layer.cornerRadius = 8;
    //_textView.placeholderFont = AdaptedFont(14);
   // _textView.placeholderTextColor = ColorHex(XYTextColor_CCCCCC);
    //_textView.textView.p
    _textView.textView.textColor = ColorHex(XYTextColor_222222);
    _textView.textView.placeholderColor = ColorHex(XYTextColor_CCCCCC);
  }
  return  _textView;
}
-(XYHotTopicView *)topicView{
  if (!_topicView) {
    _topicView = [[XYHotTopicView alloc]initWithFrame:CGRectZero];
    @weakify(self);
    [_topicView handleTapGestureRecognizerEventWithBlock:^(id sender) {
              @strongify(self);
              [self.textView resignFirstResponder];
              if (!self.topicView.model) {
                XYAddTopicViewController *VC = [[XYAddTopicViewController alloc]init];
                VC.block = ^(id  _Nonnull obj) {
                  self.topicView.model = obj;
                };
                [self.navigationController pushViewController:VC animated:YES];
              }
    }];
  }
  return _topicView;
}

- (UIImageView *)img {
  if (!_img) {
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(ADAPTATIONRATIO * 30,0,  (SCREEN_WIDTH-ADAPTATIONRATIO *90)/2.0, ADAPTATIONRATIO *580 )];
   // _img.image = [self getLocationVideoPreViewImage:_url];
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
  if (self.dataManager.selectedAssets.count) {
    PHAsset *asset = self.dataManager.selectedAssets[0];
    TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
    TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
    vc.model = model;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
  }

  
//    PlayViewController *uploadController = [[PlayViewController alloc] init];
//         uploadController.actionType = PLSActionTypePlayer;
//      //uploadController.url = _url;
//       uploadController.modalPresentationStyle = UIModalPresentationFullScreen;
//       [self presentViewController:uploadController animated:YES completion:nil];

}
- (UIImageView *)img2 {
  if (!_img2) {
    _img2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0+ADAPTATIONRATIO * 15,0 ,  (SCREEN_WIDTH-ADAPTATIONRATIO *90)/2.0, ADAPTATIONRATIO *580 )];
   // _img2.image = [self getLocationVideoPreViewImage:_url];
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
    
    if (self.dataManager.selectedPhotos.count) {
      _img2.image = self.dataManager.selectedPhotos.firstObject;
      _img.image = self.dataManager.selectedPhotos.firstObject;
    }
    
    
    
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:_img2.bounds];
//    [btn addTarget:self action:@selector(clickBtn2) forControlEvents:UIControlEventTouchUpInside];
//    [_img2 addSubview:btn];
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
      // [[XYImageUploadManager uploadManager] uploadObject:photos[0] block:^(BOOL success, NSString *token) {
         XYHiddenLoading;
        // _token =token;
        // _type = @"2";
        // NSURL *imageUrl = [NSURL URLWithString:token];
             //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
         weakSelf.img2.image = photos[0];
      // }];
     };
     [self presentViewController:imagePickerVc animated:YES completion:nil];

  
}


//- (YYLabel *)topicLabel {
//    if (!_topicLabel) {
//      _topicLabel = [[YYLabel alloc] init];
//      _topicLabel.backgroundColor = ColorHex(@"#EEEEEE");
//      _topicLabel.font = AdaptedFont(16);
//      [_topicLabel roundSize:AutoSize(12)];
//      @weakify(self);
//      _topicLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        @strongify(self);
//        [self.textView resignFirstResponder];
//        if (!self.topicmodel) {
//          XYAddTopicViewController *VC = [[XYAddTopicViewController alloc]init];
//          VC.block = ^(id  _Nonnull obj) {
//            self.topicmodel = obj;
//            [self resetTopicTitle:self.topicmodel.title canDel:YES];
//          };
//          [self.navigationController pushViewController:VC animated:YES];
//        }
//
//      };
//    }
//    return _topicLabel;
//}
//-(UIButton *)closeBtn{
//  if (!_closeBtn) {
//    _closeBtn = [LSHControl createButtonWithFrame:CGRectMake(0, 0, AutoSize(18), AutoSize(18)) buttonImage:@"close"];
//    _closeBtn.hidden = YES;
//    [_closeBtn handleControlEventWithBlock:^(id sender) {
//      self.topicmodel = nil;
//      [self.textView resignFirstResponder];
//      [self resetTopicTitle:@"添加话题" canDel:NO];
//    }];;
//  }
//  return _closeBtn;
//}
- (UIButton *)releaseButton {
  if (!_releaseButton) {
    _releaseButton = [[UIButton alloc] initWithFrame:CGRectMake(ADAPTATIONRATIO * 30, SCREEN_HEIGHT-ADAPTATIONRATIO * 140-SafeAreaBottom(), SCREEN_WIDTH - ADAPTATIONRATIO * 60, ADAPTATIONRATIO * 88)];
    [_releaseButton setBackgroundColor:ColorHex(@"#F92B5E")];
    [_releaseButton setTitle:@"发布动态" forState:UIControlStateNormal];
    [_releaseButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    _releaseButton.layer.cornerRadius = ADAPTATIONRATIO * 44;
    _releaseButton.layer.masksToBounds = YES;
    [_releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_releaseButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
  }
  return _releaseButton;
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
@end
