//
//  XYTimelineVideoController.m
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "XYTimelineVideoController.h"
#import "XYTimelineProfileVideoCell.h"

#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "GKDYPlayerViewController.h"
#import "UIScrollView+EmptyDataSet.h"

@interface XYTimelineVideoController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>



@property(nonatomic,assign)BOOL pubScroll;

@end

@implementation XYTimelineVideoController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self setupSubviews];
  
  [self fetchNewData];
  
}

- (void)fetchNewData {
  @weakify(self);
  self.dataManager.userID = self.userId;
  if (!self.blendedMode) XYShowLoading;
  [self.dataManager fetchNewDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
    if (!self.blendedMode) XYHiddenLoading;
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
 if (!self.blendedMode) XYShowLoading;
  [self.dataManager fetchNextPageDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
   if (!self.blendedMode) XYHiddenLoading;
   [weak_self.collectionView.mj_footer endRefreshing];
   if (error) {
     XYToastText(error.msg);
   } else {
     [self.collectionView reloadData];
   }
 }];
}

- (void)deleteVideoAtIndexPath:(NSIndexPath *)indexPath {
 @weakify(self);
 XYShowLoading;
  [self.dataManager deleteVideoWithIndex:indexPath.item block:^(XYError *error) {
   XYHiddenLoading;
   if (error) {
     XYToastText(error.msg);
   } else {
     [weak_self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
   }
 }];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
  //[self reshScreollEnabel];
//  if (self.dataManager.videos.count) {
//    self.vcCanScroll = self.pubScroll;
//  }
  
  return self.dataManager.videos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  XYTimelineProfileVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XYTimelineProfileVideoCell class]) forIndexPath:indexPath];
  cell.coverUrl = self.dataManager.videos[indexPath.row].coverUrl;
  cell.count = self.dataManager.videos[indexPath.row].fabulous.stringValue;
  cell.shouldEdit = NO;
  cell.shouldDelete = self.dataManager.videos[indexPath.row].userId.integerValue == [[XYUserService service] fetchLoginUser].userId.integerValue;
  cell.deleteBlock = ^{
    [self deleteVideoAtIndexPath:indexPath];
  };
  return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  BOOL isSelf = self.dataManager.videos[indexPath.row].userId.integerValue == [[XYUserService service] fetchLoginUser].userId.integerValue;
  if (isSelf) {
    return CGSizeMake((kScreenWidth-8)/3, ((kScreenWidth-8)/3)*167/120 + 32);
  } else {
    return CGSizeMake((kScreenWidth-8)/3, ((kScreenWidth-8)/3)*167/120);
  }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  GKDYVideoModel *model = [self.dataManager createVideoDataWithIndex:indexPath.item];
  GKDYPlayerViewController *vc = [[GKDYPlayerViewController alloc] initWithVideoModel:model];
  [self cyl_pushViewController:vc animated:YES];
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
  return YES;
}
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无数据";

    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: AdaptedFont(14),
                                 NSForegroundColorAttributeName:ColorHex(XYTextColor_666666),
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (self.blendedMode) {
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
  
    if (scrollView.contentOffset.y <= 0) {
        _vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];
    }
  
    self.collectionView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
  }
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
      _collectionView.emptyDataSetSource=self;
      _collectionView.emptyDataSetDelegate=self;
    //  _collectionView.bounces = YES;
      _collectionView.backgroundColor = [UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
          _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        }
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
    }
    return _collectionView;
}

- (XYTimelineVideoDataManager *)dataManager {
  if (!_dataManager) {
    _dataManager = [[XYTimelineVideoDataManager alloc] init];
    _dataManager.userID = self.userId;
  }
  return _dataManager;
}

-(void)setVcCanScroll:(BOOL)vcCanScroll{
  _vcCanScroll = vcCanScroll;
  

  self.pubScroll = vcCanScroll;
  
  
 // [self reshScreollEnabel];
  
}
-(void)reshScreollEnabel{
  
//  if (_collectionView) {
//    if (self.dataManager.videos.count<1) {
//      _vcCanScroll = NO;
//      [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];
//     
//      self.collectionView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
//    }else{
//     // _vcCanScroll = self.pubScroll;
//    }
//  }

  
  
}
@end
