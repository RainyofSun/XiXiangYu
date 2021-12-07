//
//  XYLocalVideoController.m
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "XYLocalVideoController.h"
#import "XYTimelineProfileVideoCell.h"
#import "XYTimelineVideoDataManager.h"
#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "GKDYPlayerViewController.h"
#import "XYLocationVideo.h"
#import "XYReleaseVideoVC.h"
@interface XYLocalVideoController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic,strong) XYTimelineVideoDataManager *dataManager;

@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation XYLocalVideoController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self setupSubviews];
  
  [self fetchNewData];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchNewData) name:@"KreleaseVideoSuccess" object:nil];
  
}

- (void)fetchNewData {
  
  
  self.dataSource =[NSMutableArray arrayWithArray: [[XYLocationVideo sharedService] queryLocationVideo]];
  
  [self.collectionView reloadData];
  
//  @weakify(self);
//  [self.dataManager fetchNewDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
//    [weak_self.collectionView.mj_header endRefreshing];
//    if (error) {
//      XYToastText(error.msg);
//    } else {
//      [self.collectionView reloadData];
//    }
//  }];
}

- (void)fetchNextData {
 @weakify(self);
  [self.dataManager fetchNextPageDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
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
  return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  XYLocationVideoItem *item = [self.dataSource objectAtIndex:indexPath.item];
  
  XYTimelineProfileVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XYTimelineProfileVideoCell class]) forIndexPath:indexPath];
  cell.locationUrl = item.logo;
  cell.count = @"0";
  cell.shouldEdit = NO;
  cell.shouldDelete = YES;
  @weakify(self);
  cell.deleteBlock = ^{
    @strongify(self);
    [[XYLocationVideo sharedService] cleanVideoDataWithVideo:item.video block:^(BOOL ret) {
      
      if (ret) {
        [self.dataSource removeObject:item];
        [collectionView reloadData];
      }
    }];
    
   
  };
  return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
 // BOOL isSelf = self.dataManager.videos[indexPath.row].userId.integerValue == [[XYUserService service] fetchLoginUser].userId.integerValue;
 // if (isSelf) {
    return CGSizeMake((kScreenWidth-8)/3, ((kScreenWidth-8)/3)*167/120 + 32);
  //} else {
   // return CGSizeMake((kScreenWidth-8)/3, ((kScreenWidth-8)/3)*167/120);
 // }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
  XYLocationVideoItem *item = [self.dataSource objectAtIndex:indexPath.item];
  
  
  XYReleaseVideoVC *uploadController = [[XYReleaseVideoVC alloc] init];
  
  uploadController.url = [NSURL fileURLWithPath:item.video];
  uploadController.contentText = item.text;
  uploadController.onePreImage = [UIImage imageWithContentsOfFile:item.logo];
    uploadController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:uploadController animated:YES completion:nil];
//  GKDYVideoModel *model = [self.dataManager createVideoDataWithIndex:indexPath.item];
//  GKDYPlayerViewController *vc = [[GKDYPlayerViewController alloc] initWithVideoModel:model];
//  [self cyl_pushViewController:vc animated:YES];
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
      _collectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
          _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        }
    //  @weakify(self);
//      _collectionView.mj_header = [XYRefreshHeader headerWithRefreshingBlock:^{
//          @strongify(self);
//        [self fetchNewData];
//      }];
//      _collectionView.mj_footer = [XYRefreshFooter footerWithRefreshingBlock:^{
//        @strongify(self);
//        [self fetchNextData];
//      }];
      [_collectionView registerClass:[XYTimelineProfileVideoCell class] forCellWithReuseIdentifier:@"XYTimelineProfileVideoCell"];
    }
    return _collectionView;
}

- (XYTimelineVideoDataManager *)dataManager {
  if (!_dataManager) {
    _dataManager = [[XYTimelineVideoDataManager alloc] init];
  }
  return _dataManager;
}
@end
