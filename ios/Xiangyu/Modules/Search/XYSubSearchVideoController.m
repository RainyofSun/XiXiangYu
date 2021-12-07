//
//  XYSubSearchVideoController.m
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "XYSubSearchVideoController.h"
#import "XYTimelineProfileVideoCell.h"
#import "XYSearchVideoDataManager.h"
#import "XYRefreshFooter.h"
#import "GKDYPlayerViewController.h"

@interface XYSubSearchVideoController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation XYSubSearchVideoController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self setupSubviews];
}

- (void)fetchNewDataWithKeywords:(NSString *)keywords {
  self.dataManager.words = keywords;
  @weakify(self);
  [self.dataManager fetchProductNewDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
    [weak_self.collectionView.mj_header endRefreshing];
    if (error) {
      XYToastText(error.msg);
    } else {
      if (self.dataManager.videos.count == 0) {
        XYToastText(@"没有搜索结果");
      }
      [self.collectionView reloadData];
    }
  }];
}

- (void)fetchNextData {
 @weakify(self);
  [self.dataManager fetchProductNextPageDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
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
  return self.dataManager.videos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  XYTimelineProfileVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XYTimelineProfileVideoCell class]) forIndexPath:indexPath];
  XYTimelineVideoModel *model = self.dataManager.videos[indexPath.row];
  cell.coverUrl = model.coverUrl;
  cell.count = model.fabulous.stringValue;
  cell.shouldEdit = NO;
  cell.shouldDelete = NO;
  return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  XYTimelineVideoModel *model = self.dataManager.videos[indexPath.row];
  BOOL isSelf = model.userId.integerValue == [[XYUserService service] fetchLoginUser].userId.integerValue;
  if (isSelf) {
    return CGSizeMake((kScreenWidth-8)/3, ((kScreenWidth-8)/3)*167/120 + 32);
  } else {
    return CGSizeMake((kScreenWidth-8)/3, ((kScreenWidth-8)/3)*167/120);
  }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  GKDYVideoModel *model = [self.dataManager createPlayDataWithIndex:indexPath.item];
  GKDYPlayerViewController *vc = [[GKDYPlayerViewController alloc] initWithVideoModel:model];
  [self cyl_pushViewController:vc animated:YES];
}

#pragma - UI

- (void)setupSubviews {
  self.gk_navigationBar.hidden = YES;
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self.view addSubview:self.collectionView];
  [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
  }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
      UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
      flowLayout.minimumInteritemSpacing = 4;
      flowLayout.minimumLineSpacing = 4;
      [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
      _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
      _collectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
          _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        }
      [_collectionView registerClass:[XYTimelineProfileVideoCell class] forCellWithReuseIdentifier:@"XYTimelineProfileVideoCell"];
      if (self.needRefresh) {
        @weakify(self);
        _collectionView.mj_footer = [XYRefreshFooter footerWithRefreshingBlock:^{
          @strongify(self);
          [self fetchNextData];
        }];
      }
    }
    return _collectionView;
}

- (XYSearchVideoDataManager *)dataManager {
  if (!_dataManager) {
    _dataManager = [[XYSearchVideoDataManager alloc] init];
  }
  return _dataManager;
}
@end
