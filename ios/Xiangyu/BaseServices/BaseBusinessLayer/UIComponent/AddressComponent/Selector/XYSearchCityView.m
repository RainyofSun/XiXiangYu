//
//  XYSearchCityView.m
//  Xiangyu
//
//  Created by Kang on 2021/5/26.
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
#import "XYSearchCityView.h"

@implementation XYSearchCityView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.backgroundColor = [ColorHex(XYTextColor_222222) colorWithAlphaComponent:.5];
  [self addSubview:self.tableView];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self);
  }];
//  UITapGestureRecognizer *tapSecondGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSecondView:)];
//  tapSecondGesture.delegate=self;
//  [self addGestureRecognizer:tapSecondGesture];
  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.searchData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *reuseID = @"kCitySelectorCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
  if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.textLabel.text =  self.searchData[indexPath.row].name;
  cell.textLabel.font = AdaptedFont(15);
  cell.textLabel.textColor = ColorHex(XYTextColor_333333);
  cell.backgroundColor = ColorHex(XYTextColor_FFFFFF);
  return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  XYAddressItem *item=self.searchData[indexPath.row];
  if (self.selectedBlock) self.selectedBlock(item);
}

- (UITableView *)tableView {
    if (!_tableView) {
      _tableView = [[UITableView alloc] init];
      _tableView.separatorColor = [UIColor clearColor];;
      _tableView.dataSource = self;
      _tableView.delegate = self;
      [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
      _tableView.rowHeight =ADAPTATIONRATIO*100;
      _tableView.backgroundColor =[UIColor clearColor];
      [_tableView setSectionIndexColor:[UIColor clearColor]];
    }
    return _tableView;
}
-(void)setSearchData:(NSArray<XYAddressItem *> *)searchData{
  _searchData = searchData;
  CGFloat heigth = MIN(ADAPTATIONRATIO*100 *searchData.count,SCREEN_HEIGHT/2);
  
  
  dispatch_async_on_main_queue(^{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.top.leading.trailing.equalTo(self);
      make.height.mas_equalTo(heigth);
    }];
    [self.tableView reloadData];
  });

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
