//
//  XYCarNeedScreenView.m
//  Xiangyu
//
//  Created by Kang on 2021/7/2.
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
#import "XYCarNeedScreenView.h"
#import "XYScreeningGroupView.h"
#import "XYScreeningCityView.h"

#import "BRDatePickerView.h"
@interface XYCarNeedScreenView ()
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)XYScreeningGroupView *startView;
@property(nonatomic,strong)XYScreeningGroupView *endView;

@property(nonatomic,strong)XYScreeningGroupView *dateView;
@property(nonatomic,strong)UIView *bottomView;


@property(nonatomic,strong)XYAddressItem *s_proviceItem;
@property(nonatomic,strong)XYAddressItem *s_cityItem;
@property(nonatomic,strong)XYAddressItem *  s_areaItem;

@property(nonatomic,strong)XYAddressItem *e_proviceItem;
@property(nonatomic,strong)XYAddressItem *e_cityItem;
@property(nonatomic,strong)XYAddressItem *  e_areaItem;

@property(nonatomic,strong)NSString *sendDate;
@property(nonatomic,strong)NSString *startAddress;
@property(nonatomic,strong)NSString *endAddress;

@end
@implementation XYCarNeedScreenView
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
    //    property.maskViewColor = [UIColor colorWithWhite:0 alpha:0.3];
    //    property.popupEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //    property.animationDuration = 0.2;
    self.vProperty = property;
}
-(void)newView{
  [self addSubview:self.bottomView];
  [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.bottom.trailing.equalTo(self);
  }];

  
  
  
  self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
  if (@available(iOS 11.0, *)) {
    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.scrollView.scrollIndicatorInsets = self.scrollView.contentInset;
  }
  [self addSubview:self.scrollView];
  [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self).offset(GK_STATUSBAR_HEIGHT);
    make.leading.trailing.equalTo(self);
    make.bottom.equalTo(self.bottomView.mas_top);
  }];
  
  [self.scrollView addSubview:self.startView];
  [self.startView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.scrollView);
  }];
  
  [self.scrollView addSubview:self.endView];
  [self.endView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.startView.mas_bottom).offset(AutoSize(10));
  }];
  
  [self.scrollView addSubview:self.dateView];
  [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.endView.mas_bottom).offset(AutoSize(10));
  }];
  
}
-(XYScreeningGroupView *)startView{
  if (!_startView) {
    _startView = [[XYScreeningGroupView alloc] initWithFrame:CGRectMake(0, 0, AutoSize(300), AutoSize(40))];
    _startView.title = @"出发地";
    [_startView handleTapGestureRecognizerEventWithBlock:^(id sender) {
      XYScreeningCityView *view = [[XYScreeningCityView alloc]initWithFrame:CGRectMake(AutoSize(75), 0, SCREEN_WIDTH-AutoSize(75), SCREEN_HEIGHT)];
     view.proviceItem = self.s_proviceItem;
      view.cityItem = self.s_cityItem;
      view.areaItem = self.s_areaItem;
      @weakify(self);
      view.selectedBlock = ^(XYAddressItem * _Nonnull proviceItem, XYAddressItem * _Nonnull cityItem, XYAddressItem * _Nonnull areaItem) {
        @strongify(self);
    
        self.s_proviceItem = proviceItem;
        self.s_cityItem = cityItem;
        self.s_areaItem = areaItem;
     
        [self setCityData];
        
      };
      [view show];
    }];
  }
  return _startView;
}

-(void)show{
  [super show];
  
  // 数据回显
  if ([self.dic objectForKey:@"s_pcode"]) {
    self.s_proviceItem = [[XYAddressService sharedService] queryModelWithAdcode:[self.dic objectForKey:@"s_pcode"]];
  }
  
  if ([self.dic objectForKey:@"s_ccode"]) {
    self.s_cityItem = [[XYAddressService sharedService] queryModelWithAdcode:[self.dic objectForKey:@"s_ccode"]];
  }
  
  if ([self.dic objectForKey:@"s_acode"]) {
    self.s_areaItem = [[XYAddressService sharedService] queryModelWithAdcode:[self.dic objectForKey:@"s_acode"]];
  }
  
  if ([self.dic objectForKey:@"e_pcode"]) {
    self.e_proviceItem = [[XYAddressService sharedService] queryModelWithAdcode:[self.dic objectForKey:@"e_pcode"]];
  }
  
  if ([self.dic objectForKey:@"e_ccode"]) {
    self.e_cityItem = [[XYAddressService sharedService] queryModelWithAdcode:[self.dic objectForKey:@"e_ccode"]];
  }
  
  if ([self.dic objectForKey:@"e_acode"]) {
    self.e_areaItem = [[XYAddressService sharedService] queryModelWithAdcode:[self.dic objectForKey:@"e_acode"]];
  }
  
  if ([self.dic objectForKey:@"sendDate"]) {
    self.sendDate =[self.dic objectForKey:@"sendDate"];
  }
  if ([self.dic objectForKey:@"startAddress"]) {
    self.startAddress =[self.dic objectForKey:@"startAddress"];
  }
  if ([self.dic objectForKey:@"endAddress"]) {
    self.endAddress =[self.dic objectForKey:@"endAddress"];
  }
  

  
  [self setCityData];
}
-(void)setCityData{
  NSString *cityStr = @"";
  if (self.s_proviceItem) {
   cityStr = [NSString stringWithFormat:@"%@",self.s_proviceItem.name];
  }
  if (self.s_cityItem) {
    cityStr = [NSString stringWithFormat:@"%@%@",cityStr,self.s_cityItem.name];
  }
  if (self.s_areaItem) {
    cityStr = [NSString stringWithFormat:@"%@%@",cityStr,self.s_areaItem.name];
  }
  self.startAddress = cityStr;
  if (cityStr.length) {
    self.startView.dataSource = @[cityStr];
  }
  
  NSString *ecityStr = @"";
  if (self.e_proviceItem) {
    ecityStr = [NSString stringWithFormat:@"%@",self.e_proviceItem.name];
  }
  if (self.e_cityItem) {
    ecityStr = [NSString stringWithFormat:@"%@%@",ecityStr,self.e_cityItem.name];
  }
  if (self.e_areaItem) {
    ecityStr = [NSString stringWithFormat:@"%@%@",ecityStr,self.e_areaItem.name];
  }
  self.endAddress = ecityStr;
  if (ecityStr.length) {
    self.endView.dataSource = @[ecityStr];
  }
  
  if (self.sendDate && self.sendDate.length) {
    self.dateView.dataSource = @[self.sendDate];
  }
  
  
  
}
-(XYScreeningGroupView *)endView{
  if (!_endView) {
    _endView = [[XYScreeningGroupView alloc] initWithFrame:CGRectMake(0, 0, AutoSize(300), AutoSize(40))];
    _endView.title = @"目的地";
    [_endView handleTapGestureRecognizerEventWithBlock:^(id sender) {
      XYScreeningCityView *view = [[XYScreeningCityView alloc]initWithFrame:CGRectMake(AutoSize(75), 0, SCREEN_WIDTH-AutoSize(75), SCREEN_HEIGHT)];
      view.proviceItem = self.e_proviceItem;
      view.cityItem = self.e_cityItem;
      view.areaItem = self.e_areaItem;
      @weakify(self);
      view.selectedBlock = ^(XYAddressItem * _Nonnull proviceItem, XYAddressItem * _Nonnull cityItem, XYAddressItem * _Nonnull areaItem) {
        @strongify(self);
    
        self.e_proviceItem = proviceItem;
        self.e_cityItem = cityItem;
        self.e_areaItem = areaItem;
     
        [self setCityData];
        
      };
      [view show];
    }];
  }
  return _endView;
}
-(XYScreeningGroupView *)dateView{
  if (!_dateView) {
    _dateView = [[XYScreeningGroupView alloc] initWithFrame:CGRectMake(0, 0, AutoSize(300), AutoSize(40))];
    _dateView.title = @"出发日期";
    [_dateView handleTapGestureRecognizerEventWithBlock:^(id sender) {
      NSDate *date =  [NSDate date];
      [BRDatePickerView showDatePickerWithMode:BRDatePickerModeDate title:@"选择日期" selectValue:[date stringWithFormat:XYYTDDateFormatterName] minDate:[NSDate date] maxDate:nil  isAutoSelect:NO resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        self.sendDate = selectValue;
        [self setCityData];
        self.dateView.dataSource = @[selectValue];
//        resolve([selectDate stringWithFormat:XYFullNoZDateFormatterName]);
      }];
    }];
  }
  return _dateView;
}
-(UIView *)bottomView{
  if (!_bottomView) {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *confirmBtn=[LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(14) buttonTitle:@"确定" buttonTitleColor:ColorHex(XYTextColor_FFFFFF)];
    [confirmBtn roundSize:AutoSize(18)];
    confirmBtn.backgroundColor = ColorHex(@"#F92B5E");
    [confirmBtn handleControlEventWithBlock:^(id sender) {
      
      
      NSMutableDictionary *dic = [NSMutableDictionary dictionary];
      
      [dic setValue:self.s_proviceItem.code forKey:@"s_pcode"];
      [dic setValue:self.s_cityItem.code forKey:@"s_ccode"];
      [dic setValue:self.s_areaItem.code forKey:@"s_acode"];
      
      [dic setValue:self.e_proviceItem.code forKey:@"e_pcode"];
      [dic setValue:self.e_cityItem.code forKey:@"e_ccode"];
      [dic setValue:self.e_areaItem.code forKey:@"e_acode"];
      
      [dic setValue:self.sendDate forKey:@"sendDate"];
      
      [dic setValue:self.startAddress forKey:@"startAddress"];
      [dic setValue:self.endAddress forKey:@"endAddress"];
      
//      self.reqParams.province = self.proviceItem.code;
//      self.reqParams.city = self.cityItem.code;
//      self.reqParams.area = self.areaItem.code;
//
//      self.reqParams.startAge = @((int)self.ageView.slider.selectedMinimum);
//      self.reqParams.endAge =  @((int)self.ageView.slider.selectedMaximum);
//
//      self.reqParams.startHeight = @((int)self.heightView.slider.selectedMinimum);
//      self.reqParams.endHeight =  @((int)self.heightView.slider.selectedMaximum);
      
      if (self.selectedBlock) {
        self.selectedBlock(dic);
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
    
    
    UIButton *resetBtn=[LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(14) buttonTitle:@"重置" buttonTitleColor:ColorHex(@"#F92B5E")];
    [resetBtn roundSize:AutoSize(18) color:ColorHex(@"#F92B5E")];
    [resetBtn handleControlEventWithBlock:^(id sender) {
      //self.reqParams = nil;
    }];
    [_bottomView addSubview:resetBtn];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
