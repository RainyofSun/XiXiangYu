//
//  XYWithdrawMoneyTableViewCell.m
//  Xiangyu
//
//  Created by Kang on 2021/7/4.
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
#import "XYWithdrawMoneyTableViewCell.h"
#import "XYScreeningItemCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"
@interface XYWithdrawMoneyTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
@property(nonatomic,strong)WSLWaterFlowLayout *flowLayout;
@property(nonatomic,strong)UICollectionView *collectionView;

@end
@implementation XYWithdrawMoneyTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier = @"XYWithdrawMoneyTableViewCell";
    XYWithdrawMoneyTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell=[[XYWithdrawMoneyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
      //  cell.supertableView = tableView;
    }
    //cell.indexPath = indexPath;
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  self.collectionView = [LSHControl createCollectionViewFromFrame:CGRectMake(0, 0, SCREEN_WIDTH-AutoSize(75), AutoSize(60)) collectionViewLayout:self.flowLayout dataSource:self delegate:self];
  self.collectionView.backgroundColor = [UIColor whiteColor];
  [self.collectionView registerClass:NSClassFromString(@"XYScreeningItemCollectionViewCell") forCellWithReuseIdentifier:@"XYScreeningItemCollectionViewCell"];
  [self.contentView addSubview:self.collectionView];
  
  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.leading.trailing.equalTo(self.contentView);

    make.bottom.equalTo(self.contentView).offset(-AutoSize(5)).priority(800);
  }];
  
}
-(WSLWaterFlowLayout *)flowLayout{
  if (!_flowLayout) {
    _flowLayout = [[WSLWaterFlowLayout alloc] init];
    _flowLayout.delegate=self;
    _flowLayout.flowLayoutStyle = WSLWaterFlowVerticalEqualWidth;
  }
  return _flowLayout;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  XYScreeningItemCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"XYScreeningItemCollectionViewCell" forIndexPath:indexPath];
  NSString *money = [self.dataSource objectAtIndex:indexPath.item];
  cell.titleLabel.text = money;
  cell.colortype = 1;
  cell.isSelected = self.currentObj && [self.currentObj isEqual:money];
  cell.titleLabel.font = AdaptedFont(18);
  
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
    return UIEdgeInsetsMake(AutoSize(10), AutoSize(32), AutoSize(10), AutoSize(32));
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  
  
  return CGSizeMake((SCREEN_WIDTH - AutoSize(84))/3.0, AutoSize(40));
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
  [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(self.collectionView.collectionViewLayout.collectionViewContentSize.height);
  }];
  
  
  [self updateConstraintsIfNeeded];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
