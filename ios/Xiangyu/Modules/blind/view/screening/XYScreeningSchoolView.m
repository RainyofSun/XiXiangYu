//
//  XYScreeningSchoolView.m
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
#import "XYScreeningSchoolView.h"
#import "XYScreeningItemTableViewCell.h"

@interface XYScreeningSchoolView ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy) NSArray  *schoolData;
@property(nonatomic,strong)UIView *bottomView;
@end
@implementation XYScreeningSchoolView
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
    //    property.maskViewColor = [UIColor colorWithWhite:0 alpha:0.3];
    //    property.popupEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //    property.animationDuration = 0.2;
    self.vProperty = property;
}
-(void)show{
  [super show];
  [self getMiddleSchool];
}
-(void)getMiddleSchool{
  NSString *area = self.reqParams.area;
  // 很湿SB，加上area 相亲没数据，不加area 学校没数据
  // 这是明显的接口没处理好
  if ([self.reqParams.city isEqual:[[XYUserService service] fetchLoginUser].city]) {
    area = [[XYUserService service] fetchLoginUser].area;
  }
  
  
  @weakify(self);
  [[XYPlatformService shareService] fetchSchoolDataWithProvice:self.reqParams.province
                                                          city:self.reqParams.city
                                                          area:area
                                                          type:self.schoolType
                                                         block:^(NSArray<XYSchoolModel *> *data, XYError *error) {
    @strongify(self);
    self.schoolData = data;
    [self.tableView reloadData];
  }];
  
  
}



-(void)newView{
  
  [self addSubview:self.bottomView];
  [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.bottom.trailing.equalTo(self);
  }];
  
  self.tableView = [LSHControl createTableViewWithFrame:CGRectMake(0, GK_STATUSBAR_HEIGHT, self.width, self.height-GK_STATUSBAR_HEIGHT-GK_SAFEAREA_BTM) style:UITableViewStylePlain dataSource:self delegate:self];
  self.tableView.rowHeight = AutoSize(56);
 // self.tableView.backgroundColor  = [UIColor redColor];
  [self addSubview:self.tableView];
//  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.top.equalTo(self).offset(GK_STATUSBAR_HEIGHT);
//    make.leading.trailing.equalTo(self);
//    make.bottom.equalTo(self.bottomView.mas_top);
//  }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.schoolData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  XYScreeningItemTableViewCell *cell
  = [XYScreeningItemTableViewCell cellWithTableView:tableView indexPath:indexPath];
  XYSchoolModel *model = [self.schoolData objectAtIndex:indexPath.row];
  cell.titleLabel.text = model.schoolName;
  return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  XYSchoolModel *model = [self.schoolData objectAtIndex:indexPath.row];
  if (self.selectedBlock) {
    self.selectedBlock(model);
    [self hide];
  }
}
-(UIView *)bottomView{
  if (!_bottomView) {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, GK_SAFEAREA_BTM)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
//    UIButton *confirmBtn=[LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(14) buttonTitle:@"确定" buttonTitleColor:ColorHex(XYTextColor_FFFFFF)];
//    [confirmBtn roundSize:AutoSize(18)];
//    confirmBtn.backgroundColor = ColorHex(@"#F92B5E");
//    @weakify(self);
//    [confirmBtn handleControlEventWithBlock:^(id sender) {
//      @strongify(self);
//      if (self.selectedBlock) {
//        self.selectedBlock(self.proviceItem, self.cityItem, self.areaItem);
//      }
//      [self hide];
//    }];
//    [_bottomView addSubview:confirmBtn];
//    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.trailing.equalTo(_bottomView).offset(-AutoSize(20));
//      make.top.equalTo(_bottomView).offset(AutoSize(10));
//      make.size.mas_equalTo(CGSizeMake(AutoSize(124), AutoSize(38)));
//      make.bottom.equalTo(_bottomView).offset(-AutoSize(10)-GK_SAFEAREA_BTM).priority(800);
//    }];
//    
//    
//    UIButton *resetBtn=[LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(14) buttonTitle:@"重置" buttonTitleColor:ColorHex(@"#F92B5E")];
//    [resetBtn roundSize:AutoSize(18) color:ColorHex(@"#F92B5E")];
//    [_bottomView addSubview:resetBtn];
//    [resetBtn handleControlEventWithBlock:^(id sender) {
//      @strongify(self);
//      [self hide];
//    }];
//    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.leading.equalTo(_bottomView).offset(AutoSize(20));
//      make.centerY.equalTo(confirmBtn);
//      make.size.mas_equalTo(CGSizeMake(AutoSize(124), AutoSize(38)));
//    }];
//    
//    _bottomView.layer.masksToBounds = NO;
//    // 阴影颜色
//    _bottomView.layer.shadowColor = ColorHex(XYTextColor_EEEEEE).CGColor;
//    // 阴影偏移，默认(0, -3)
//    _bottomView.layer.shadowOffset = CGSizeMake(0,-1.5);
//    // 阴影透明度，默认0
//    _bottomView.layer.shadowOpacity = 1;
//    // 阴影半径，默认3
//    _bottomView.layer.shadowRadius = 3;
  }
  return _bottomView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
