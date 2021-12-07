//
//  XYScreeningCityView.m
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
#import "XYScreeningCityView.h"
#import "XYScreeningItemTableViewCell.h"
@interface XYScreeningCityView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView1;
@property(nonatomic,strong)UITableView *tableView2;
@property(nonatomic,strong)UITableView *tableView3;
@property(nonatomic,strong)UIView *bottomView;

@property (nonatomic,copy) NSArray <XYAddressItem *> *proviceData;
@property (nonatomic,copy) NSArray <XYAddressItem *> *cityData;
@property (nonatomic,copy) NSArray <XYAddressItem *> *areaData;


@end
@implementation XYScreeningCityView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
      [self configProperty];
    }
    return self;
}
- (void)configProperty
{
    FWPopupBaseViewProperty *property = [FWPopupBaseViewProperty manager];
    property.popupAlignment = FWPopupAlignmentRightCenter;
    property.popupAnimationStyle = FWPopupAnimationStylePosition;
    property.touchWildToHide = @"1";
  property.maskViewColor = [UIColor colorWithWhite:0 alpha:0.8];
    //property.maskViewColor = [UIColor clearColor];
    //    property.popupEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //    property.animationDuration = 0.2;
    self.vProperty = property;
}
-(void)newView{
  
  [self addSubview:self.bottomView];
  [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.bottom.trailing.equalTo(self);
  }];
  
  self.tableView1 = [LSHControl createTableViewWithFrame:CGRectZero style:UITableViewStylePlain dataSource:self delegate:self];
  self.tableView1.rowHeight = AutoSize(56);
//  self.tableView1.backgroundColor  = [UIColor redColor];
  [self addSubview:self.tableView1];
  [self.tableView1 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self).offset(GK_STATUSBAR_HEIGHT);
    make.leading.equalTo(self);
    make.width.mas_equalTo(AutoSize(100));
    make.bottom.equalTo(self.bottomView.mas_top);
  }];
  
  self.tableView2 = [LSHControl createTableViewWithFrame:CGRectZero style:UITableViewStylePlain dataSource:self delegate:self];
  self.tableView2.rowHeight = AutoSize(56);
  [self addSubview:self.tableView2];
  [self.tableView2 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self).offset(GK_STATUSBAR_HEIGHT);
    make.centerX.equalTo(self);
    make.width.mas_equalTo(AutoSize(100));
    make.bottom.equalTo(self.bottomView.mas_top);
  }];
  
  
  
  self.tableView3 = [LSHControl createTableViewWithFrame:CGRectZero style:UITableViewStylePlain dataSource:self delegate:self];
  self.tableView3.rowHeight = AutoSize(56);
  [self addSubview:self.tableView3];
  [self.tableView3 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self).offset(GK_STATUSBAR_HEIGHT);
    make.trailing.equalTo(self);
    make.width.mas_equalTo(AutoSize(100));
    make.bottom.equalTo(self.bottomView.mas_top);
  }];
  
  [self getProviceDataList];
}
-(UIView *)bottomView{
  if (!_bottomView) {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *confirmBtn=[LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(14) buttonTitle:@"确定" buttonTitleColor:ColorHex(XYTextColor_FFFFFF)];
    [confirmBtn roundSize:AutoSize(18)];
    confirmBtn.backgroundColor = ColorHex(@"#F92B5E");
    @weakify(self);
    [confirmBtn handleControlEventWithBlock:^(id sender) {
      @strongify(self);
      if (self.selectedBlock) {
        self.selectedBlock(self.proviceItem, self.cityItem, self.areaItem);
      }
      [self hide];
    }];
    [_bottomView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.trailing.equalTo(_bottomView).offset(-AutoSize(20));
      make.top.equalTo(_bottomView).offset(AutoSize(10));
      make.size.mas_equalTo(CGSizeMake(AutoSize(124), AutoSize(38)));
      make.bottom.equalTo(_bottomView).offset(-AutoSize(10)-GK_SAFEAREA_BTM).priority(800);
    }];
    
    
    UIButton *resetBtn=[LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(14) buttonTitle:@"返回" buttonTitleColor:ColorHex(@"#F92B5E")];
    [resetBtn roundSize:AutoSize(18) color:ColorHex(@"#F92B5E")];
    [_bottomView addSubview:resetBtn];
    [resetBtn handleControlEventWithBlock:^(id sender) {
      @strongify(self);
      [self hide];
    }];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.leading.equalTo(_bottomView).offset(AutoSize(20));
      make.centerY.equalTo(confirmBtn);
      make.size.mas_equalTo(CGSizeMake(AutoSize(124), AutoSize(38)));
    }];
    
    _bottomView.layer.masksToBounds = NO;
    // 阴影颜色
    _bottomView.layer.shadowColor = ColorHex(XYTextColor_EEEEEE).CGColor;
    // 阴影偏移，默认(0, -3)
    _bottomView.layer.shadowOffset = CGSizeMake(0,-1.5);
    // 阴影透明度，默认0
    _bottomView.layer.shadowOpacity = 1;
    // 阴影半径，默认3
    _bottomView.layer.shadowRadius = 3;
  }
  return _bottomView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (tableView == self.tableView1) {
    return self.proviceData.count;
  }else if (tableView == self.tableView2){
    return self.cityData.count;
  }
  return self.areaData.count + 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  XYScreeningItemTableViewCell *cell
  = [XYScreeningItemTableViewCell cellWithTableView:tableView indexPath:indexPath];
  if (tableView == self.tableView1) {
    XYAddressItem *item = [self.proviceData objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.name;
    cell.isSelected = self.proviceItem && [self.proviceItem.code isEqualToString:item.code];
  }else if (tableView == self.tableView2){
    XYAddressItem *item = [self.cityData objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.name;
    cell.isSelected = self.cityItem && [self.cityItem.code isEqualToString:item.code];
  }else{
    if (indexPath.row == 0) {
      cell.titleLabel.text = @"全市区";
      cell.isSelected = (!self.areaItem);
    }else{
      XYAddressItem *item = [self.areaData objectAtIndex:indexPath.row-1];
      cell.titleLabel.text = item.name;
      cell.isSelected = self.areaItem && [self.areaItem.code isEqualToString:item.code];
    }
  }
  return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if (tableView == self.tableView1) {
    XYAddressItem *item = [self.proviceData objectAtIndex:indexPath.row];
//    cell.titleLabel.text = item.name;
    self.proviceItem = item;
  }else if (tableView == self.tableView2){
    XYAddressItem *item = [self.cityData objectAtIndex:indexPath.row];
    self.cityItem = item;
//    cell.titleLabel.text = item.name;
  }else{
    
    if (indexPath.row == 0) {
      self.areaItem = nil;
    }else{
      self.areaItem = [self.areaData objectAtIndex:indexPath.row-1];
    
    }
  }
  [tableView reloadData];
}
-(void)getProviceDataList{
 self.proviceData = [[XYAddressService sharedService] queryProvince];

  if (!self.proviceItem) {
    self.proviceItem = self.proviceData.firstObject;
  }
  [self.tableView1 reloadData];
  //[self getCityDataListWithPid:@"410000"];
}
-(void)getCityDataListWithPid:(NSString *)pid{

  self.cityData = [[XYAddressService sharedService] querySubAreaWithAdcode:pid];
  if (!self.cityItem || ![self.cityItem.parentId isEqual:self.proviceItem.code]) {
    self.cityItem = self.cityData.firstObject;
  }
  [self.tableView2 reloadData];

}
-(void)getAreaDataListWithPid:(NSString *)pid{
  
  self.areaData = [[XYAddressService sharedService] querySubAreaWithAdcode:pid];
  if (!self.areaItem || ![self.areaItem.parentId isEqual:self.cityItem.code]) {
    self.areaItem = nil;
  }
  [self.tableView3 reloadData];
}
-(void)setProviceItem:(XYAddressItem *)proviceItem{
  _proviceItem = proviceItem;
  
  if (proviceItem) {
    [self getCityDataListWithPid:proviceItem.code];
  }
  
  
}
-(void)setCityItem:(XYAddressItem *)cityItem{
  _cityItem = cityItem;
  if (cityItem) {
    [self getAreaDataListWithPid:cityItem.code];
  }
 
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
