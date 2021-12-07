//
//  XYHeartMoneyView.m
//  Xiangyu
//
//  Created by Kang on 2021/7/5.
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
#import "XYHeartMoneyView.h"
#import "XYScreeningItemCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"
@interface XYHeartMoneyView ()<UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
@property(nonatomic,strong)WSLWaterFlowLayout *flowLayout;
@property(nonatomic,strong)UICollectionView *collectionView;

@end
@implementation XYHeartMoneyView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  
  self.collectionView = [LSHControl createCollectionViewFromFrame:self.bounds collectionViewLayout:self.flowLayout dataSource:self delegate:self];
  self.collectionView.backgroundColor = [UIColor clearColor];
  self.collectionView.showsHorizontalScrollIndicator = NO;
  self.collectionView.showsVerticalScrollIndicator = NO;
  [self.collectionView registerClass:NSClassFromString(@"XYScreeningItemCollectionViewCell") forCellWithReuseIdentifier:@"XYScreeningItemCollectionViewCell"];
  [self addSubview:self.collectionView];
  
  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self);

   // make.bottom.equalTo(self).offset(-AutoSize(5)).priority(800);
  }];
  
}
-(WSLWaterFlowLayout *)flowLayout{
  if (!_flowLayout) {
    _flowLayout = [[WSLWaterFlowLayout alloc] init];
    _flowLayout.delegate=self;
    _flowLayout.flowLayoutStyle = WSLWaterFlowHorizontalEqualHeight;
  }
  return _flowLayout;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  XYScreeningItemCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"XYScreeningItemCollectionViewCell" forIndexPath:indexPath];
  NSDictionary *money = [self.dataSource objectAtIndex:indexPath.item];
  cell.titleLabel.text =  [NSString stringWithFormat:@"%@颗 ¥%@",[money objectForKey:@"count"],[money objectForKey:@"price"]]; //money[@"title"];
  cell.colortype = 2;
 
  cell.titleLabel.font = AdaptedFont(10);
  cell.isSelected = self.currentObj && [self.currentObj isEqual:money];
  return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  self.currentObj = [self.dataSource objectAtIndex:indexPath.item];
  [collectionView reloadData];
  if (self.selectedBlock) {
    self.selectedBlock(self.currentObj);
  }
}
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 3;
}
-(CGFloat)rowCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
  return 1;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return AutoSize(10);
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
  return AutoSize(8);
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(AutoSize(4), AutoSize(12), AutoSize(4), AutoSize(12));
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  NSDictionary *money = [self.dataSource objectAtIndex:indexPath.item];
  NSString *title = [NSString stringWithFormat:@"%@颗 ¥%@",[money objectForKey:@"count"],[money objectForKey:@"price"]];;
 CGFloat width = [title sizeForFont:AdaptedFont(12) size:CGSizeMake(MAXBSIZE, AutoSize(28)) mode:NSLineBreakByWordWrapping].width;
  
  return CGSizeMake(AutoSize(20)+width, AutoSize(28));
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
-(void)layoutResult{
  CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  CGRect frame = self.frame;
  frame.size.height = height;
  self.frame = frame;
}
-(void)setDataSource:(NSArray *)dataSource{
  _dataSource = dataSource;
  [self.collectionView reloadData];
  [self.collectionView layoutIfNeeded];
  [self layoutIfNeeded];
//  [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
//      make.height.mas_equalTo(self.collectionView.collectionViewLayout.collectionViewContentSize.height);
//  }];
  
  
  [self updateConstraintsIfNeeded];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
