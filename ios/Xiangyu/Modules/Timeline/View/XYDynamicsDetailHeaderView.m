//
//  XYDynamicsDetailHeaderView.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/25.
//

#import "XYDynamicsDetailHeaderView.h"
#import "XYHomeViewFlowLayout.h"
#import "SuperPlayer.h"
//#import "YBImageBrowser.h"
#import "HZPhotoBrowser.h"
@interface XYDynamicsDetailHeaderImageCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *indexLable;

@end

@implementation XYDynamicsDetailHeaderImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
  [self.contentView addSubview:self.iconView];
  [self.contentView addSubview:self.indexLable];
  self.iconView.frame = self.contentView.bounds;
  self.indexLable.frame = CGRectMake(kScreenWidth-46, 16, 30, 20);

}

- (UIImageView *)iconView {
  if (!_iconView) {
    _iconView = [[UIImageView alloc] init];
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    _iconView.clipsToBounds = YES;
  }
  return _iconView;
}

- (UILabel *)indexLable {
    if (!_indexLable) {
      _indexLable = [[UILabel alloc] init];
      _indexLable.backgroundColor = UIColorAlpha(XYThemeColor_D, XYColorAlpha_30);
      _indexLable.textColor = ColorHex(XYTextColor_FFFFFF);
      _indexLable.font = AdaptedMediumFont(12);
      _indexLable.textAlignment = NSTextAlignmentCenter;
      _indexLable.layer.cornerRadius = 10;
      _indexLable.layer.masksToBounds = YES;
    }
    return _indexLable;
}
@end

@interface XYDynamicsDetailHeaderView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) UIImageView *videoCoverView;

@property (strong, nonatomic) UIButton *pauseBtn;

@property (strong, nonatomic) YYLabel *contentLable;



//@property(nonatomic,strong)YYLabel *fabulousLabel;

@property (strong, nonatomic) UILabel *timeLable;


@property (nonatomic, strong) SuperPlayerView *playerView;

@property (strong, nonatomic) XYHomeViewFlowLayout *flowLayout;

@property (nonatomic, assign) XYDynamicsDetailType type;

@end

@implementation XYDynamicsDetailHeaderView
- (instancetype)initWithType:(XYDynamicsDetailType)type contentLayout:(YYTextLayout *)layout {
    self = [super init];
    if (self) {
      self.backgroundColor = [UIColor whiteColor];
      self.type = type;
      self.contentLable.textLayout = layout;
      [self addSubview:self.contentLable];
      [self addSubview:self.timeLable];
      [self addSubview:self.topicLabel];
      [self addSubview:self.fabulousLabel];
      
      if (type == 1) {
        self.contentLable.frame = CGRectMake(18, 16, kScreenWidth-36, layout.textBoundingSize.height);
        
      } else if (type == 2) {
        [self addSubview:self.collectionView];
        self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
        self.contentLable.frame = CGRectMake(18, CGRectGetMaxY(self.collectionView.frame)+16, kScreenWidth-36, layout.textBoundingSize.height);
        
      }else if (type == 3) {
        [self addSubview:self.videoCoverView];
        [self.videoCoverView addSubview:self.pauseBtn];
        self.videoCoverView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
        self.pauseBtn.frame = CGRectMake((kScreenWidth-50)/2, (kScreenWidth-50)/2, 50, 50);
        self.contentLable.frame = CGRectMake(18, CGRectGetMaxY(self.videoCoverView.frame)+16, kScreenWidth-36, layout.textBoundingSize.height);
        
      }
    }
    return self;
}
-(void)setDynamicsModel:(XYDynamicsModel *)dynamicsModel{
  _dynamicsModel = dynamicsModel;
  
  self.resources = dynamicsModel.images;
  self.coverImageUrl = dynamicsModel.coverUrl;
  
  
  self.timeLable.text = [dynamicsModel.createTime formateDateWithFormate:XYFullDateFormatterName];
  CGFloat width = [self.timeLable sizeThatFits:CGSizeMake(CGFLOAT_MAX, 18)].width;
  
  
  if ([dynamicsModel.subjectId integerValue]>0) {
    NSMutableAttributedString *all_attr = [NSMutableAttributedString new];
    NSMutableAttributedString *textt_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"#"]];
    textt_attr.yy_font = AdaptedFont(14);
    textt_attr.yy_color = ColorHex(@"#F92B5E");
    [all_attr appendAttributedString:textt_attr];
    
    //创建属性字符串
    NSMutableAttributedString *text_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",dynamicsModel.subjectText]];
    text_attr.yy_font = AdaptedFont(14);
    text_attr.yy_color = ColorHex(XYTextColor_333333);
    [all_attr appendAttributedString:text_attr];
    self.topicLabel.attributedText = all_attr;
   // [self.topicLabel sizeToFit];
    
    CGSize size =  [[NSString stringWithFormat:@"# %@",dynamicsModel.subjectText] sizeForFont:AdaptedFont(14) size:CGSizeMake(AutoSize(240), AutoSize(20)) mode:NSLineBreakByWordWrapping];
    self.topicLabel.textAlignment = NSTextAlignmentCenter;
    self.topicLabel.left = self.contentLable.XY_left;
    self.topicLabel.top = self.contentLable.XY_bottom + AutoSize(8);
    self.topicLabel.width = size.width + AutoSize(20);
    self.topicLabel.height = AutoSize(20);
    self.topicLabel.hidden = NO;
  
    self.timeLable.frame = CGRectMake(kScreenWidth-18-width, CGRectGetMaxY(self.topicLabel.frame)+16, width, 18);
  }else{
    self.topicLabel.hidden = YES;
    self.timeLable.frame = CGRectMake(kScreenWidth-18-width, CGRectGetMaxY(self.contentLable.frame)+16, width, 18);
  }
  self.fabulousLabel.text = [NSString stringWithFormat:@"%@人觉得很赞",dynamicsModel.fabulous];
  
  self.topicLabel.left = self.contentLable.XY_left;
  self.topicLabel.centerY = self.timeLable.centerY;
  self.timeLable.height = 18;
  self.timeLable.width = AutoSize(120);
 
}
- (void)setCreatTime:(NSString *)creatTime {
  _creatTime = creatTime;
  self.timeLable.text = [creatTime formateDateWithFormate:XYFullDateFormatterName];
  CGFloat width = [self.timeLable sizeThatFits:CGSizeMake(CGFLOAT_MAX, 18)].width;
  self.timeLable.frame = CGRectMake(kScreenWidth-18-width, CGRectGetMaxY(self.contentLable.frame)+16, width, 18);
}

- (void)setResources:(NSArray<NSString *> *)resources {
  _resources = resources;
  if (self.type == 2) {
    [self.collectionView reloadData];
  }
}

- (void)setCoverImageUrl:(NSString *)coverImageUrl {
  _coverImageUrl = coverImageUrl;
  if (coverImageUrl.isNotBlank) {
    [self.videoCoverView sd_setImageWithURL:[NSURL URLWithString:coverImageUrl]];
  }
}

- (void)play {
  SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
  // 设置播放地址，直播、点播都可以
  playerModel.videoURL = self.resources.firstObject;
  [self.playerView playWithModel:playerModel];

}

- (void)releasePlayer {
  [_playerView resetPlayer];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  XYDynamicsDetailHeaderImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYDynamicsDetailHeaderImageCell" forIndexPath:indexPath];
  NSString *urlString = self.resources[indexPath.row];
  [cell.iconView sd_setImageWithURL:[NSURL URLWithString:urlString]];
  cell.indexLable.text = [NSString stringWithFormat:@"%ld/%ld", (long)(indexPath.row+1), (long)self.resources.count];
  return cell;

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  return nil;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
  
//      NSMutableArray * items = [NSMutableArray array];
//      for (int i = 0; i < self.resources.count; i++) {
//        YBIBImageData *data = [YBIBImageData new];
//        data.imageURL = [NSURL URLWithString:self.resources[i]];
//        //data.projectiveView = _imageViewsArray[i];
//        [items addObject:data];
//      }
//    YBImageBrowser *browser = [YBImageBrowser new];
//    browser.dataSourceArray = items;
//    browser.currentPage = indexPath.item;
//    [browser show];
  
  HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
  browser.isFullWidthForLandScape = YES;
  browser.isNeedLandscape = YES;
 browser.currentImageIndex = indexPath.item;
  browser.imageArray = self.resources;
  [browser show];
  
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(kScreenWidth, kScreenWidth);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
  return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
  return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
      _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
      _collectionView.showsVerticalScrollIndicator = NO;
      _collectionView.showsHorizontalScrollIndicator = NO;
      _collectionView.backgroundColor = ColorHex(XYThemeColor_B);
      _collectionView.dataSource = self;
      _collectionView.delegate = self;
      [_collectionView registerClass:[XYDynamicsDetailHeaderImageCell class] forCellWithReuseIdentifier:@"XYDynamicsDetailHeaderImageCell"];
      _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (SuperPlayerView *)playerView {
    if (!_playerView) {
      _playerView = [[SuperPlayerView alloc] init];
      _playerView.fatherView = self.videoCoverView;
      _playerView.isLockScreen = YES;
      SPDefaultControlView *controlView = [[SPDefaultControlView alloc] initWithFrame:CGRectZero];
      controlView.disableBackBtn = YES;
      controlView.disableDanmakuBtn = YES;
      controlView.disableCaptureBtn = YES;
      controlView.disableMoreBtn = YES;
      controlView.fullScreenBtn.hidden = YES;
      _playerView.controlView = controlView;
    }
    return _playerView;
}

- (YYLabel *)contentLable {
    if (!_contentLable) {
      _contentLable = [[YYLabel alloc] init];
    }
    return _contentLable;
}
//
- (YYLabel *)fabulousLabel{
  if (!_fabulousLabel) {
    _fabulousLabel = [[YYLabel alloc] init];
    _fabulousLabel.font = AdaptedFont(12);
    //
    _fabulousLabel.textColor = ColorHex(@"#6160F0");
  }
  return _fabulousLabel;
}
- (YYLabel *)topicLabel {
    if (!_topicLabel) {
      _topicLabel = [[YYLabel alloc] init];
      _topicLabel.backgroundColor = ColorHex(@"#EEEEEE");
      _topicLabel.font = AdaptedFont(16);
      [_topicLabel roundSize:AutoSize(12)];
      @weakify(self);
      _topicLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        @strongify(self);
//        [self.textView resignFirstResponder];
//        if (!self.topicmodel) {
//          XYAddTopicViewController *VC = [[XYAddTopicViewController alloc]init];
//          VC.block = ^(id  _Nonnull obj) {
//            self.topicmodel = obj;
//            [self resetTopicTitle:self.topicmodel.title canDel:YES];
//          };
//          [self.navigationController pushViewController:VC animated:YES];
//        }
       
      };
    }
    return _topicLabel;
}
- (UILabel *)timeLable {
    if (!_timeLable) {
      _timeLable = [[UILabel alloc] init];
      _timeLable.textColor = ColorHex(XYTextColor_999999);
      _timeLable.font = AdaptedFont(12);
    }
    return _timeLable;
}

- (UIImageView *)videoCoverView {
  if (!_videoCoverView) {
    _videoCoverView = [[UIImageView alloc] init];
    _videoCoverView.userInteractionEnabled = YES;
  }
  return _videoCoverView;
}

- (UIButton *)pauseBtn {
  if (!_pauseBtn) {
    _pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pauseBtn setImage:[UIImage imageNamed:@"icon_22bofang"] forState:UIControlStateNormal];
    [_pauseBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
  }
  return _pauseBtn;
}

- (XYHomeViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[XYHomeViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}
@end
