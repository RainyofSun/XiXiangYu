//
//  XYScreeningGroupView.m
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
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
#import "XYScreeningGroupView.h"
#import "XYScreeningItemCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"
@interface XYScreeningGroupView ()<UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
@property(nonatomic,strong)WSLWaterFlowLayout *flowLayout;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *arrowImage;
@end
@implementation XYScreeningGroupView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_999999)];
  [self addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self).offset(AutoSize(20));
    make.top.equalTo(self).offset(AutoSize(10));
  }];
  
  self.arrowImage =[LSHControl createImageViewWithImageName:@"next"];
  [self addSubview:self.arrowImage];
  [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self).offset(-AutoSize(15));
    make.centerY.equalTo(self.titleLabel);
    make.width.height.mas_equalTo(AutoSize(14));
  }];
  
  self.collectionView = [LSHControl createCollectionViewFromFrame:CGRectMake(0, 0, SCREEN_WIDTH-AutoSize(75), AutoSize(60)) collectionViewLayout:self.flowLayout dataSource:self delegate:self];
  [self.collectionView registerClass:NSClassFromString(@"XYScreeningItemCollectionViewCell") forCellWithReuseIdentifier:@"XYScreeningItemCollectionViewCell"];
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
  XYScreeningItemCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"XYScreeningItemCollectionViewCell" forIndexPath:indexPath];
  cell.isSelected = YES;
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
    return UIEdgeInsetsMake(AutoSize(0), AutoSize(20), AutoSize(10), AutoSize(20));
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  NSString *str = [self.dataSource objectAtIndex:indexPath.item];
 
  
  return CGSizeMake(MIN([str sizeForFont:AdaptedFont(14) size:CGSizeMake(AutoSize(260), AutoSize(30)) mode:NSLineBreakByWordWrapping].width+AutoSize(24), AutoSize(260)), AutoSize(30));
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
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
