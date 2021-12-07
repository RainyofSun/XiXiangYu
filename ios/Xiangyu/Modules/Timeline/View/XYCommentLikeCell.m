//
//  XYCommentLikeCell.m
//  Xiangyu
//
//  Created by dimon on 09/02/2021.
//

#import "XYCommentLikeCell.h"
#import "XYHomeViewFlowLayout.h"

@interface XYCommentLikeIconCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *iconView;

@end

@implementation XYCommentLikeIconCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.iconView];

}

-(void)layoutSubviews {
  [super layoutSubviews];
  self.iconView.frame = self.contentView.bounds;
}

#pragma mark - getter

- (UIImageView *)iconView {
    if (!_iconView) {
      _iconView = [[UIImageView alloc] init];
      _iconView.layer.cornerRadius = 16;
      _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

@end

@interface XYCommentLikeCell() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *iconImageView;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) XYHomeViewFlowLayout *flowLayout;

@end

@implementation XYCommentLikeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI {
    if (!_iconImageView) {
      _iconImageView = [[UIImageView alloc] init];
      [_iconImageView setImage:[UIImage imageNamed:@"icon_22_dianzan_normal"]];
      [self.contentView addSubview:_iconImageView];
      [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(16);
          make.top.mas_equalTo(16);
          make.size.mas_equalTo(CGSizeMake(22, 22));
      }];
    }
  
  [self.contentView addSubview:self.collectionView];
  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(_iconImageView.mas_right).offset(8);
    make.top.mas_equalTo(16);
    make.right.mas_equalTo(-16);
    make.height.mas_equalTo(50);
    make.bottom.mas_equalTo(-16);
  }];
}

- (void)setConfigData:(NSArray<XYLikesUserModel *> *)configData {
  _configData = configData;
  NSUInteger preLineCount = (kScreenWidth - 94)/40 + 1;
  
  CGFloat height = 0;
  if (configData.count > preLineCount * 3) {
    height = 112;
  } else {
    NSUInteger lines = (configData.count / preLineCount) + 1;
    height = 32 + 40*lines;
  }
  
  [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(height);
  }];
  [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.configData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  XYCommentLikeIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYCommentLikeIconCell" forIndexPath:indexPath];
  [cell.iconView sd_setImageWithURL:[NSURL URLWithString:self.configData[indexPath.row].headPortrait]];
  return cell;

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  return nil;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(32, 32);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
  return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
  return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 8;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
      _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
      _collectionView.showsVerticalScrollIndicator = NO;
      _collectionView.backgroundColor = ColorHex(XYThemeColor_B);
      _collectionView.dataSource = self;
      _collectionView.delegate = self;
      [_collectionView registerClass:[XYCommentLikeIconCell class] forCellWithReuseIdentifier:@"XYCommentLikeIconCell"];
    }
    return _collectionView;
}

- (XYHomeViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[XYHomeViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _flowLayout;
}
@end
