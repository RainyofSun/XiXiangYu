//
//  XYHomeDoubleTableView.m
//  Xiangyu
//
//  Created by Kang on 2021/6/21.
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
#import "XYHomeDoubleTableView.h"
#import "XYMenuCityTableViewCell.h"
#import "XYMainCityTableViewCell.h"
#import "XYAddressService.h"
@interface XYHomeDoubleTableView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *menuListView;
@property(nonatomic,strong)UITableView *mainListView;

@property(nonatomic,strong)NSIndexPath *menuIndexPath;
@end
@implementation XYHomeDoubleTableView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
      
      [self getProviceDataList];
    }
    return self;
}
-(void)newView{
  [self addSubview:self.menuListView];
  [self addSubview:self.mainListView];
  [self.menuListView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.top.bottom.equalTo(self);
    make.width.mas_equalTo(260*ADAPTATIONRATIO);
  }];
  [self.mainListView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.top.bottom.equalTo(self);
    make.leading.equalTo(self.menuListView.mas_trailing);
  }];
  
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  if (self.proviceItem == nil && tableView== self.mainListView) {
    return 2;
  }
  return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (tableView== self.menuListView) {
    return self.proviceData.count + 1;;
  }
  if(self.proviceItem == nil && section == 0 && tableView== self.mainListView){
    return 1;
  }
  return self.cityData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (tableView == self.menuListView) {
    XYMenuCityTableViewCell *cell =[XYMenuCityTableViewCell cellWithTableView:tableView indexPath:indexPath];
    if (indexPath.row ==  0) {
      cell.titleLabel.text = @"主要城市";
    }else{
      XYAddressItem *item = [self.proviceData objectAtIndex:indexPath.row-1];
      cell.titleLabel.text = item.name;
    }
    cell.isSelected =(self.menuIndexPath.row == indexPath.row );
    return cell;
  }
  XYMainCityTableViewCell *cell =[XYMainCityTableViewCell cellWithTableView:tableView indexPath:indexPath];
  cell.isCut = NO;
  if (!self.proviceItem && indexPath.section == 0) {
    cell.isCut = YES;
    cell.titleLabel.text = self.cutCity.name;
  }else{
  
    XYAddressItem *item = [self.cityData objectAtIndex:indexPath.row];
    cell.titleLabel.text = item.name;
  }
  
   
  return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  if (tableView == self.mainListView && self.proviceItem == nil) {
    return 88*ADAPTATIONRATIO;
  }
  return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  if (tableView == self.mainListView && self.proviceItem == nil) {
    
    UIView *header=[UIView new];
    header.backgroundColor =ColorHex(XYThemeColor_F);
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = AdaptedFont(12);
    titleLabel.textColor = ColorHex(XYTextColor_333333);
    titleLabel.text = section?@"推荐城市":@"当前定位";
    [header addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(header);
      make.leading.equalTo(header).offset(ADAPTATIONRATIO*26);
      make.trailing.lessThanOrEqualTo(header).offset(-30*ADAPTATIONRATIO);
    }];
    
    
    return header;
  }
  return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if (self.menuListView == tableView) {
    if (indexPath.row == 0) {
      self.proviceItem = nil;
    }else{
      self.proviceItem = [self.proviceData objectAtIndex:indexPath.row-1];
    }
    self.menuIndexPath = indexPath;
    if (self.proviceItem) {
      [self getCityDataListWithPid:self.proviceItem?self.proviceItem.code:@"410000"];
    }else{
      self.cityData = self.hotCityData;
      [self.mainListView reloadData];
    }
   
    [tableView reloadData];
  }else{
    if (self.proviceItem) {
      self.cityItem = [self.cityData objectAtIndex:indexPath.row];
    }else{
      if (indexPath.section == 0) {
        self.cityItem = self.cutCity;
      }else{
        self.cityItem = [self.cityData objectAtIndex:indexPath.row];
      }
    }
    if (self.selectedBlock) {
      self.selectedBlock(self.cityItem);
    }
    [tableView reloadData];
  }
}

- (UITableView *)menuListView {
    if (!_menuListView) {
      _menuListView = [[UITableView alloc] init];
      _menuListView.separatorColor = ColorHex(XYThemeColor_E);
      _menuListView.dataSource = self;
      _menuListView.delegate = self;
      [_menuListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
      _menuListView.rowHeight =ADAPTATIONRATIO*100;
      _menuListView.backgroundColor =ColorHex(XYThemeColor_F);
      [_menuListView setSectionIndexColor:ColorHex(XYTextColor_999999)];
    }
    return _menuListView;
}
- (UITableView *)mainListView {
    if (!_mainListView) {
      _mainListView = [[UITableView alloc] init];
      _mainListView.separatorColor = ColorHex(XYThemeColor_E);
      [_mainListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
      _mainListView.dataSource = self;
      _mainListView.delegate = self;
      _mainListView.rowHeight =ADAPTATIONRATIO*100;
      _mainListView.backgroundColor =ColorHex(XYTextColor_FFFFFF);
      [_mainListView setSectionIndexColor:ColorHex(XYTextColor_999999)];
    }
    return _mainListView;
}
-(void)getProviceDataList{
 self.proviceData = [[XYAddressService sharedService] queryProvince];
  [self.menuListView reloadData];
 // [self getCityDataListWithPid:@"410000"];
}
-(void)getCityDataListWithPid:(NSString *)pid{
  self.cityData = [[XYAddressService sharedService] querySubAreaWithAdcode:pid];
  [self.mainListView reloadData];
}
-(void)setCutCity:(XYAddressItem *)cutCity{
  _cutCity = cutCity;
  if (!self.proviceItem) {
    [self.mainListView reloadData];
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
