//
//  GKDYPlayerViewController.m
//  GKDYVideo
//
//  Created by QuintGao on 2018/9/23.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDYPlayerViewController.h"
#import "UIImage+GKCategory.h"
#import "GKSlidePopupView.h"
#import "GKDYCommentView.h"
#import "GKBallLoadingView.h"
#import "GKLikeView.h"
#import "QNRecordingViewController.h"         // 拍摄
#import "NSObject+QNAuth.h"
#import "ShareView.h"
#import "GKDYGiftView.h"
#import "XYGeneralAPI.h"
#import "XYSearchVideoContainer.h"
#import "XYUserService.h"
#import "WebViewController.h"
#import "TypeMenu.h"
#import "TZImagePickerController.h"
#import "QBImagePickerController.h"
#import "QNTranscodeViewController.h"
#import "PopoverView.h"
#import "XYPlatformService.h"
#import "XYTimelineProfileController.h"

#define kTitleViewY         (GK_STATUSBAR_HEIGHT)
// 过渡中心点
#define kTransitionCenter   20.0f

@interface GKDYPlayerViewController ()<GKDYVideoViewDelegate, UINavigationControllerDelegate,QBImagePickerControllerDelegate> {
  NSString *_type;
}
@property (nonatomic, strong) ShareView * shareView;
@property (nonatomic, strong) UIView                *titleBgView;
@property (nonatomic, strong) UIView                *titleView;
@property (nonatomic, strong) UIButton              *shootBtn;  // 随拍

@property (nonatomic, strong) UIView                *refreshView;
@property (nonatomic, strong) UILabel               *refreshLabel;
@property (nonatomic, strong) UIView                *loadingBgView;
@property (nonatomic, strong) GKBallLoadingView     *refreshLoadingView;

@property (nonatomic, strong) UIButton              *backBtn;
@property (nonatomic, strong) UIButton              *searchBtn;

@property (nonatomic, strong) UIButton              *recBtn;
@property (nonatomic, strong) UIButton              *cityBtn;

@property (nonatomic, strong) NSArray               *videos;
@property (nonatomic, assign) NSInteger             playIndex;

// 是否从某个控制器push过来
@property (nonatomic, assign) BOOL                  isPushed;
@property (nonatomic, strong) GKSlidePopupView *popupView ;
@property (nonatomic, strong) GKSlidePopupView *giftPopupView ;
@property (nonatomic, strong) UIImpactFeedbackGenerator *clickFeedback;
@property (nonatomic, strong) TypeMenu *typeMenu;
@end

@implementation GKDYPlayerViewController

- (instancetype)initWithVideoModel:(GKDYVideoModel *)model {
    if (self = [super init]) {
      self.videos = @[model];
      self.playIndex = 0;
      self.isPushed = YES;
    }
    return self;
}

- (instancetype)initWithVideos:(NSArray *)videos index:(NSInteger)index {
    if (self = [super init]) {
        self.videos = videos;
        self.playIndex = index;
        
        self.isPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navigationBar.hidden  = YES;
    self.view.backgroundColor = [UIColor blackColor];
  
  
  
    [self.view addSubview:self.videoView];
  _type = @"1";
  
    [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
  
  [self.view addSubview:self.titleBgView];
    
    if (self.isPushed) {
        [self.view addSubview:self.backBtn];
        [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15.0f);
            make.top.equalTo(self.view).offset(GK_SAFEAREA_TOP + 20.0f);
            make.width.height.mas_equalTo(44.0f);
        }];
        
        [self.videoView setModels:self.videos index:self.playIndex];
    }else {
        [self.view addSubview:self.searchBtn];
        
        [self.view addSubview:self.titleView];
        [self.titleView addSubview:self.shootBtn];
        [self.titleView addSubview:self.recBtn];
        [self.titleView addSubview:self.cityBtn];
        [self.titleView addSubview:self.searchBtn];
        
        [self.view addSubview:self.refreshView];
        [self.refreshView addSubview:self.refreshLabel];
        [self.view addSubview:self.loadingBgView];
        
        self.loadingBgView.frame = CGRectMake(SCREEN_WIDTH - 15 - 44, GK_SAFEAREA_TOP, 44, 44);
        self.refreshLoadingView = [GKBallLoadingView loadingViewInView:self.loadingBgView];
        
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(GK_STATUSBAR_HEIGHT);
            make.height.mas_equalTo(44.0f);
        }];
        
        [self.shootBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleView);
            make.width.mas_offset(ADAPTATIONRATIO * 48.0f);
            make.height.mas_equalTo(ADAPTATIONRATIO * 48.0f);
          make.right.equalTo(self.view).offset(-15.0f);
        }];
        
        [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleView);
          make.left.equalTo(self.view).offset(15.0f);
        }];
        
        [self.recBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleView);
            make.centerX.equalTo(self.titleView).offset(-28);
        }];
        
        [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleView);
            make.centerX.equalTo(self.titleView).offset(28);
        }];
        
        [self.refreshView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(GK_SAFEAREA_BTM + 20.0f);
            make.height.mas_equalTo(44.0f);
        }];
        
        [self.refreshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.refreshView);
        }];
      
        GKBallLoadingView *loadingView = [GKBallLoadingView loadingViewInView:self.view];
        [loadingView startLoading];

        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);

            [loadingView stopLoading];
            [loadingView removeFromSuperview];
          [self.videoView.viewModel refresh:@"1" newListWithSuccess:^(NSArray * _Nonnull list) {
                [self.videoView setModels:list index:0];
            } failure:^(NSError * _Nonnull error) {
                
            }];
        });
    }
  
  [[XYPlatformService shareService] fetchOnlineSwitchWithBlock:^(BOOL status) {
      self.videoView.isAudit = status;
  }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
  
    [self.videoView resume];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 停止播放
    [self.videoView pause];
  
}

- (void)dealloc {
    [_videoView destoryPlayer];
    
    DLog(@"playerVC dealloc");
}

- (void)searchClick:(id)sender {
  XYSearchVideoContainer *vc = [[XYSearchVideoContainer alloc] init];
      [self cyl_pushViewController:vc animated:YES];
}

- (void)shootClick:(id)sender {
  @weakify(self);
    PopoverAction *video = [PopoverAction actionWithImage:[UIImage imageNamed:@"icon_22_photograph"] title:@"拍摄" handler:^(PopoverAction *action) {
      [NSObject haveCameraAccess:^(BOOL isAuth) {
        if (isAuth) {
          QNRecordingViewController *recordingController = [[QNRecordingViewController alloc] init];
          recordingController.modalPresentationStyle = UIModalPresentationFullScreen;
          [weak_self presentViewController:recordingController animated:YES completion:nil];
        }
      }];
    }];
    
      PopoverAction *photo = [PopoverAction actionWithImage:[UIImage imageNamed:@"icon_22_album"] title:@"从相册选择" handler:^(PopoverAction *action) {
        QBImagePickerController *picker = [[QBImagePickerController alloc] init];
        picker.delegate = weak_self;
        picker.mediaType = QBImagePickerMediaTypeVideo;
        picker.allowsMultipleSelection = 1;
        picker.showsNumberOfSelectedAssets = YES;
        picker.maximumNumberOfSelection = 1;
        picker.minimumNumberOfSelection = 1;

        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [weak_self presentViewController:picker animated:YES completion:nil];

    }];
    
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.showShade = YES;
    popoverView.arrowStyle = PopoverViewArrowStyleRound;
    [popoverView showToView:sender withActions:@[video,photo]];
  
}

- (void)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)itemClick:(id)sender {
    if (sender == self.recBtn) {
        self.recBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        self.cityBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        
        [self.recBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.cityBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
      _type = @"1";
    }else {
        self.recBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        self.cityBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        
        [self.recBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.cityBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      _type = @"2";
    }
  
  [self.videoView.viewModel refresh:_type newListWithSuccess:^(NSArray * _Nonnull list) {
          [self.videoView setModels:list index:0];
      } failure:^(NSError * _Nonnull error) {
          
      }];
}

#pragma mark - GKDYVideoViewDelegate
- (void)videoView:(GKDYVideoView *)videoView didClickIcon:(GKDYVideoModel *)videoModel {
  XYTimelineProfileController *profileVc = [[XYTimelineProfileController alloc] init];
  profileVc.userId = @(videoModel.author.user_id.integerValue);
  [self cyl_pushViewController:profileVc animated:YES];
}

- (void)videoView:(GKDYVideoView *)videoView didClickPraise:(GKDYVideoModel *)videoModel {
    
    GKDYVideoModel *model = videoModel;
    
    model.isAgree = !model.isAgree;
    
    int agreeNum = model.agree_num.intValue;
    
    if (model.isAgree) {
        model.agree_num = [NSString stringWithFormat:@"%d", agreeNum + 1];
    }else {
        model.agree_num = [NSString stringWithFormat:@"%d", agreeNum - 1];
    }
    
    videoView.currentPlayView.model = videoModel;
  [self clickPraise:videoModel];
}

- (void)clickPraise:(GKDYVideoModel *)videoModel {
    GKBallLoadingView *loadingView = [GKBallLoadingView loadingViewInView:self.view];
    [loadingView startLoading];
    
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];

  NSString *method = @"api/v1/ShortVideo/VideoFabulous";
  
  NSString *shortVideoId =videoModel.post_id;
  
  NSDictionary *params = @{
    @"userId": user.userId,
      @"shortVideoId": @([shortVideoId intValue])
  };

  XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
    api.apiRequestMethodType = XYRequestMethodTypePOST;
  
  api.requestParameters = params ?: @{};
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    [loadingView stopLoading];
    [loadingView removeFromSuperview];
    if (!error) {
      
    } else {

    }
  };
  [api start];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [loadingView stopLoading];
    [loadingView removeFromSuperview];
  });
}
- (void)clickCloseBtn {
  [_popupView dismiss];
}
- (void)videoView:(GKDYVideoView *)videoView didClickComment:(GKDYVideoModel *)videoModel {
    GKDYCommentView *commentView = [GKDYCommentView new];
  [commentView.closeBtn addTarget:self action:@selector(clickCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    commentView.frame = CGRectMake(0, 0, GK_SCREEN_WIDTH, ADAPTATIONRATIO * 980.0f);
  commentView.videoModel = videoModel;
    _popupView = [GKSlidePopupView popupViewWithFrame:[UIScreen mainScreen].bounds contentView:commentView];
    [_popupView showFrom:[UIApplication sharedApplication].keyWindow completion:^{
        [commentView requestData];
    }];
}
- (void)clickGiftCloseBtn {
  [_giftPopupView dismiss];
}
- (void)videoView:(GKDYVideoView *)videoView didClickGift:(GKDYVideoModel *)videoModel {
  GKDYGiftView *commentView = [GKDYGiftView new];
  MJWeakSelf
  commentView.closePage = ^{
    [weakSelf clickGiftCloseBtn];
  };
//  [commentView.closeBtn handleControlEventWithBlock:^(id sender) {
//    [weakSelf clickGiftCloseBtn];
//  }];
  [commentView.closeBtn addTarget:self action:@selector(clickGiftCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    commentView.frame = CGRectMake(0, 0, GK_SCREEN_WIDTH, ADAPTATIONRATIO * 780.0f);
  commentView.user_id = videoModel.author.user_id;
    _giftPopupView = [GKSlidePopupView popupViewWithFrame:[UIScreen mainScreen].bounds contentView:commentView];
    [_giftPopupView showFrom:[UIApplication sharedApplication].keyWindow completion:^{
        [commentView requestData];
    }];
}


- (void)videoView:(GKDYVideoView *)videoView didClickShare:(GKDYVideoModel *)videoModel {
  [self.shareView showWithContentType:JSHARELink shareType:@{@"type":@"7",@"id":videoModel.post_id,@"id":videoModel.post_id,@"title":videoModel.title,@"remark":videoModel.remark.length < 1 ? @"" : videoModel.remark,@"iconUrl":videoModel.first_frame_cover}];
  
}

- (void)videoView:(GKDYVideoView *)videoView didClickLookDec:(GKDYVideoModel *)videoModel{
  
      WebViewController *vc = [[WebViewController alloc] init];
      vc.urlStr = videoModel.extUrl;
      [self.navigationController pushViewController:vc animated:YES];
}

- (void)videoView:(GKDYVideoView *)videoView didScrollIsCritical:(BOOL)isCritical {
    if ([self.delegate respondsToSelector:@selector(playerVC:controlView:isCritical:)]) {
        [self.delegate playerVC:self controlView:videoView.currentPlayView isCritical:isCritical];
    }
}

- (void)videoView:(GKDYVideoView *)videoView didPanWithDistance:(CGFloat)distance isEnd:(BOOL)isEnd {
    if (self.isRefreshing) return;
    
    if (isEnd) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.titleView.frame;
            frame.origin.y = kTitleViewY;
            self.titleView.frame = frame;
            self.refreshView.frame = frame;
            
            CGRect loadingFrame = self.loadingBgView.frame;
            loadingFrame.origin.y = kTitleViewY;
            self.loadingBgView.frame = loadingFrame;
            
            self.refreshView.alpha      = 0;
            self.titleView.alpha        = 1;
            self.loadingBgView.alpha    = 1;
        }];
        
        if (distance >= 2 * kTransitionCenter) { // 刷新
            self.shootBtn.hidden = YES;
            [self.refreshLoadingView startLoading];
            self.isRefreshing = YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.refreshLoadingView stopLoading];
                self.loadingBgView.alpha = 0;
                self.shootBtn.hidden = NO;
                self.isRefreshing = NO;
              
              [self.videoView.viewModel refresh:_type newListWithSuccess:^(NSArray * _Nonnull list) {
                      [self.videoView setModels:list index:0];
                  } failure:^(NSError * _Nonnull error) {
                      
                  }];
            });
        }else {
            self.loadingBgView.alpha = 0;
        }
    }else {
        if (distance < 0) {
            self.refreshView.alpha = 0;
            self.titleView.alpha = 1;
        }else if (distance > 0 && distance < kTransitionCenter) {
            CGFloat alpha = distance / kTransitionCenter;
            
            self.refreshView.alpha      = 0;
            self.titleView.alpha        = 1 - alpha;
            self.loadingBgView.alpha    = 0;
            
            // 位置改变
            CGRect frame = self.titleView.frame;
            frame.origin.y = kTitleViewY + distance;
            self.titleView.frame = frame;
            self.refreshView.frame = frame;
            
            CGRect loadingFrame = self.loadingBgView.frame;
            loadingFrame.origin.y = frame.origin.y;
            self.loadingBgView.frame = loadingFrame;
        }else if (distance >= kTransitionCenter && distance <= 2 * kTransitionCenter) {
            CGFloat alpha = (2 * kTransitionCenter - distance) / kTransitionCenter;
            
            self.refreshView.alpha      = 1 - alpha;
            self.titleView.alpha        = 0;
            self.loadingBgView.alpha    = 1 - alpha;
            
            // 位置改变
            CGRect frame = self.titleView.frame;
            frame.origin.y = kTitleViewY + distance;
            self.titleView.frame    = frame;
            self.refreshView.frame  = frame;
            
            CGRect loadingFrame = self.loadingBgView.frame;
            loadingFrame.origin.y = frame.origin.y;
            self.loadingBgView.frame = loadingFrame;
            
            [self.refreshLoadingView startLoadingWithProgress:(1 - alpha)];
        }else {
            self.titleView.alpha    = 0;
            self.refreshView.alpha  = 1;
            self.loadingBgView.alpha = 1;
            [self.refreshLoadingView startLoadingWithProgress:1];
        }
    }
}

#pragma mark - 懒加载
- (GKDYVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[GKDYVideoView alloc] initWithVC:self isPushed:self.isPushed];
        _videoView.delegate = self;
    }
    return _videoView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn setImage:[UIImage gk_imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIButton *)shootBtn {
    if (!_shootBtn) {
        _shootBtn = [UIButton new];
        [_shootBtn setImage:[UIImage imageNamed:@"icon_22_fabu"] forState:UIControlStateNormal];
        [_shootBtn addTarget:self action:@selector(shootClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shootBtn;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton new];
        [_searchBtn setImage:[UIImage gk_changeImage:[UIImage imageNamed:@"icon_22_suos"] color:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [UIView new];
    }
    return _titleView;
}
-(UIView *)titleBgView{
  if (!_titleBgView) {
    _titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GK_SCREEN_WIDTH, GK_STATUSBAR_NAVBAR_HEIGHT)];
    CAGradientLayer *layer=[CAGradientLayer layer];
    layer.frame = _titleBgView.bounds;
    [layer setColors:@[(id)[[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor,(id)[UIColor clearColor].CGColor]];
    [layer setStartPoint:CGPointMake(0, 0)];
    [layer setEndPoint:CGPointMake(0, 1)];
    [_titleBgView.layer insertSublayer:layer atIndex:0];
  }
  return _titleBgView;
}
- (UIButton *)recBtn {
    if (!_recBtn) {
        _recBtn = [UIButton new];
        [_recBtn setTitle:@"推荐" forState:UIControlStateNormal];
        [_recBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _recBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [_recBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recBtn;
}

- (UIButton *)cityBtn {
    if (!_cityBtn) {
        _cityBtn = [UIButton new];
        [_cityBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_cityBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _cityBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_cityBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cityBtn;
}

- (UIView *)refreshView {
    if (!_refreshView) {
        _refreshView = [UIView new];
        _refreshView.backgroundColor = [UIColor clearColor];
        _refreshView.alpha = 0.0f;
    }
    return _refreshView;
}

- (UILabel *)refreshLabel {
    if (!_refreshLabel) {
        _refreshLabel = [UILabel new];
        _refreshLabel.font = [UIFont systemFontOfSize:16.0f];
        _refreshLabel.text = @"下拉刷新内容";
        _refreshLabel.textColor = [UIColor whiteColor];
    }
    return _refreshLabel;
}

- (UIView *)loadingBgView {
    if (!_loadingBgView) {
        _loadingBgView = [UIView new];
        _loadingBgView.backgroundColor = [UIColor clearColor];
        _loadingBgView.alpha = 0.0f;
    }
    return _loadingBgView;
}

- (ShareView *)shareView {
    if (!_shareView) {
      _shareView = [[ShareView alloc] init];
      [_shareView getFactoryShareViewWithCallBack:^(JSHAREPlatform platform, JSHAREMediaType type) {
              
      }];
        [[UIApplication sharedApplication].delegate.window addSubview:self.shareView];
    }
    return _shareView;
}

- (TypeMenu *)typeMenu{
    if (!_typeMenu) {
      MJWeakSelf;
        NSArray *dataArray = [[NSArray alloc]initWithObjects:
           [NSDictionary dictionaryWithObjectsAndKeys:@"拍摄",@"title",@"motify",@"img", nil],
                              [NSDictionary dictionaryWithObjectsAndKeys:@"相册",@"title",@"motify",@"img", nil], nil];
        _typeMenu = [TypeMenu createMenuWithFrame:CGRectMake(SCREEN_WIDTH - 135, ADAPTATIONRATIO * 48.0f + GK_SAFEAREA_TOP + 20.0f + 15, 120, 80) dataArray:dataArray];
        _typeMenu.selectRowBlcok = ^(NSString * _Nonnull title) {
          if ([title isEqualToString:@"拍摄"]) {
            [NSObject haveCameraAccess:^(BOOL isAuth) {
              if (isAuth) {
                QNRecordingViewController *recordingController = [[QNRecordingViewController alloc] init];
                recordingController.modalPresentationStyle = UIModalPresentationFullScreen;
                [weakSelf presentViewController:recordingController animated:YES completion:nil];
              }
            }];
          }else {
            QBImagePickerController *picker = [[QBImagePickerController alloc] init];
            picker.delegate = weakSelf;
            picker.mediaType = QBImagePickerMediaTypeVideo;
            picker.allowsMultipleSelection = 1;
            picker.showsNumberOfSelectedAssets = YES;
            picker.maximumNumberOfSelection = 1;
            picker.minimumNumberOfSelection = 1;

            picker.modalPresentationStyle = UIModalPresentationFullScreen;
            [weakSelf presentViewController:picker animated:YES completion:nil];
            
          }
        };
    }
    return _typeMenu;
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    [self dismissViewControllerAnimated:YES completion:^{
//        if (QNActionTypeEdit == self.action) {
//            [self gotoTranscodeController:assets.firstObject];
//        } else if (QNActionTypeMixRecording == self.action) {
//            [self gotoMixRecorderController:assets.firstObject];
//        }
      
      QNTranscodeViewController *transcodeController = [[QNTranscodeViewController alloc] init];
      transcodeController.phAsset = assets.firstObject;
      transcodeController.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:transcodeController animated:YES completion:nil];
    }];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
