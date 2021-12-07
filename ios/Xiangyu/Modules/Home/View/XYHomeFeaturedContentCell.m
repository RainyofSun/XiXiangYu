//
//  XYHomeFeaturedContentCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/30.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYHomeFeaturedContentCell.h"
#import "XYHomeViewFlowLayout.h"
#import "XYHomeFeaturedItemCell.h"

static NSString *const kXYHomeFeaturedItemCellKey = @"XYHomeFeaturedItemCell";

@interface XYHomeFeaturedContentCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation XYHomeFeaturedContentCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      [self.collectionView registerClass:[XYHomeFeaturedItemCell class] forCellWithReuseIdentifier:kXYHomeFeaturedItemCellKey];
      [self.contentView addSubview:self.collectionView];
      
      self.backgroundColor = ColorHex(XYThemeColor_F);
    }
    return self;
}

- (void)setItem:(NSArray *)item {
  [super setItem:item];
  self.items = item.mutableCopy;
  [self.collectionView reloadData];
}

- (void)clickDetailWithItem:(NSDictionary *)item {
  id target = item[XYHome_Router];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([target respondsToSelector:@selector(blindDetailWithItem:)]) {
    [target performSelector:@selector(blindDetailWithItem:) withObject:item];
  }
#pragma clang diagnostic pop
}

- (void)reloadIndex:(NSUInteger)index withItem:(NSDictionary *)item {
  if (index > self.items.count - 1 || !item) {
    return;
  }
  [self.items replaceObjectAtIndex:index withObject:item];
  [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    XYHomeBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kXYHomeFeaturedItemCellKey forIndexPath:indexPath];
    cell.item = self.items[indexPath.row];
  cell.backgroundColor = [UIColor clearColor];
  
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary *item = self.items[indexPath.item];
  [self clickDetailWithItem:item];
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(kScreenWidth*0.85,kScreenWidth*0.85+77);
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
      XYHomeViewFlowLayout *flowLayout = [[XYHomeViewFlowLayout alloc] init];
      flowLayout.sectionInset = UIEdgeInsetsMake(0, 8.0, 0, 8.0);
      flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, 0, self.XY_width, self.XY_height) collectionViewLayout:flowLayout];
      _collectionView.showsHorizontalScrollIndicator = NO;
//      _collectionView.backgroundColor = ColorHex(XYThemeColor_B);
      _collectionView.backgroundColor = [UIColor clearColor];
      _collectionView.dataSource = self;
      _collectionView.delegate = self;
    }
    return _collectionView;
}
@end
