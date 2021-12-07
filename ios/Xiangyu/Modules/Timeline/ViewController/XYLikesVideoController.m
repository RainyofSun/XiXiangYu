//
//  XYLikesVideoController.m
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "XYLikesVideoController.h"
#import "XYTimelineProfileVideoCell.h"
#import "XYTimelineVideoDataManager.h"
#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "GKDYPlayerViewController.h"

@interface XYLikesVideoController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic,strong) XYTimelineVideoDataManager *dataManager;

@end

@implementation XYLikesVideoController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self setupNavBar];
  
  [self setupSubviews];
  
  [self.collectionView.mj_header beginRefreshing];
  
}

- (void)fetchNewData {
  @weakify(self);
  [self.dataManager fetchLikesNewDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
    [weak_self.collectionView.mj_header endRefreshing];
    if (error) {
      XYToastText(error.msg);
    } else {
      [self.collectionView reloadData];
    }
  }];
}

- (void)fetchNextData {
 @weakify(self);
  [self.dataManager fetchLikesNextPageDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
   [weak_self.collectionView.mj_footer endRefreshing];
   if (error) {
     XYToastText(error.msg);
   } else {
     [self.collectionView reloadData];
   }
 }];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.dataManager.likesVideos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  XYTimelineProfileVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XYTimelineProfileVideoCell class]) forIndexPath:indexPath];
  cell.coverUrl = self.dataManager.likesVideos[indexPath.row].coverUrl;
  cell.count = self.dataManager.likesVideos[indexPath.row].fabulous.stringValue;
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  GKDYVideoModel *model = [self.dataManager createLikesVideoDataWithIndex:indexPath.item];
  GKDYPlayerViewController *vc = [[GKDYPlayerViewController alloc] initWithVideoModel:model];
  [self cyl_pushViewController:vc animated:YES];
}

#pragma - UI
- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
  self.gk_navTitle = @"赞过";
}
- (void)setupSubviews {
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.collectionView.frame = CGRectMake(0, NAVBAR_HEIGHT, self.view.XY_width, self.view.XY_height - NAVBAR_HEIGHT);
  [self.view addSubview:self.collectionView];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
      UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
      flowLayout.itemSize = CGSizeMake((kScreenWidth-8)/3, ((kScreenWidth-8)/3)*167/120);
      flowLayout.minimumInteritemSpacing = 4;
      flowLayout.minimumLineSpacing = 4;
      [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
      _collectionView.backgroundColor = [UIColor whiteColor];
      @weakify(self);
      _collectionView.mj_header = [XYRefreshHeader headerWithRefreshingBlock:^{
          @strongify(self);
        [self fetchNewData];
      }];
      _collectionView.mj_footer = [XYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self fetchNextData];
      }];
      [_collectionView registerClass:[XYTimelineProfileVideoCell class] forCellWithReuseIdentifier:@"XYTimelineProfileVideoCell"];
      if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.scrollIndicatorInsets = _collectionView.contentInset;
      }
    }
    return _collectionView;
}

- (XYTimelineVideoDataManager *)dataManager {
  if (!_dataManager) {
    _dataManager = [[XYTimelineVideoDataManager alloc] init];
    _dataManager.userID = [[XYUserService service] fetchLoginUser].userId;
  }
  return _dataManager;
}
@end
