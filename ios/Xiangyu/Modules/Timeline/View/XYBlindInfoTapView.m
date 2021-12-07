//
//  XYBlindInfoTapView.m
//  Xiangyu
//
//  Created by Kang on 2021/6/30.
//
//------made in china-------
/**   The code comes frome breakfly
 *
 *       ┏┓　　 ┏┓
 *     ┏━┛┻━━━━┛┻┓
 * 　　┃　  　━　 ┃
 * 　　┃ 　 ^    ^ ┃
 * 　　┃　　　 ┻　 ┃
 * 　　┗━━━━━━━━━┛
 *
 * --------萌萌哒-------
 */
#import "XYBlindInfoTapView.h"
#import "XYBlindInfoItemCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"
@interface XYBlindInfoTapView ()<UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
@property(nonatomic,strong)WSLWaterFlowLayout *flowLayout;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UILabel *titleLabel;

@end
@implementation XYBlindInfoTapView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(12) textColor:ColorHex(XYTextColor_666666) text:@"个人信息"];
  [self addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self).offset(AutoSize(16));
    make.top.equalTo(self).offset(AutoSize(10));
  }];
  

  
  self.collectionView = [LSHControl createCollectionViewFromFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize(60)) collectionViewLayout:self.flowLayout dataSource:self delegate:self];
  [self.collectionView registerClass:NSClassFromString(@"XYBlindInfoItemCollectionViewCell") forCellWithReuseIdentifier:@"XYBlindInfoItemCollectionViewCell"];
  [self addSubview:self.collectionView];
  self.collectionView.backgroundColor = [UIColor whiteColor];
  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.titleLabel.mas_bottom).offset(AutoSize(10));
    make.bottom.equalTo(self).offset(-AutoSize(5)).priority(800);
  }];
  
}
-(WSLWaterFlowLayout *)flowLayout{
  if (!_flowLayout) {
    _flowLayout = [[WSLWaterFlowLayout alloc] init];
    _flowLayout.delegate=self;
    _flowLayout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
  }
  return _flowLayout;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  XYBlindInfoItemCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"XYBlindInfoItemCollectionViewCell" forIndexPath:indexPath];
  cell.titleLabel.text = [self.dataSource objectAtIndex:indexPath.item];
  return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 3;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return AutoSize(12);
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
  return AutoSize(10);
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(AutoSize(0), AutoSize(16), AutoSize(10), AutoSize(16));
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  NSString *str = [self.dataSource objectAtIndex:indexPath.item];
 
  
  return [XYBlindInfoItemCollectionViewCell getItemCellSizeWithData:str];
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
-(void)setTitle:(NSString *)title{
  self.titleLabel.text = title;
}
-(void)setDataSource:(NSArray *)dataSource{
  _dataSource = dataSource;
  [self.collectionView reloadData];
  [self.collectionView layoutIfNeeded];
  [self layoutIfNeeded];
  [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(self.collectionView.collectionViewLayout.collectionViewContentSize.height);
  }];
  
  
  [self updateConstraintsIfNeeded];
  
  
  CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
