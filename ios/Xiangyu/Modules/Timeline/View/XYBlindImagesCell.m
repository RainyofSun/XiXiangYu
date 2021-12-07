//
//  XYBlindImagesCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/25.
//

#import "XYBlindImagesCell.h"
#import "XYHomeViewFlowLayout.h"
//#import "YBImageBrowser.h"
#import "HZPhotoBrowser.h"
@interface XYBlindHeaderImageCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *indexLable;

@end

@implementation XYBlindHeaderImageCell

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

@interface XYBlindImagesCell() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) XYHomeViewFlowLayout *flowLayout;

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation XYBlindImagesCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.backgroundColor = [UIColor whiteColor];
      [self.contentView addSubview:self.collectionView];
      self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    }
    return self;
}

- (void)setResources:(NSArray<NSString *> *)resources {
  _resources = resources;
  [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.resources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  XYBlindHeaderImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYBlindHeaderImageCell" forIndexPath:indexPath];
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
      [_collectionView registerClass:[XYBlindHeaderImageCell class] forCellWithReuseIdentifier:@"XYBlindHeaderImageCell"];
      _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

- (XYHomeViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[XYHomeViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}
@end
