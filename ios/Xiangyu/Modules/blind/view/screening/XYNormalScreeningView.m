//
//  XYNormalScreeningView.m
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
#import "XYNormalScreeningView.h"

#import "XYScreeningGroupView.h"
#import "XYScreeningSliderView.h"
#import "XYScreeningSecectedGroupView.h"

#import "XYScreeningCityView.h"
#import "XYScreeningSchoolView.h"
@interface XYNormalScreeningView ()

@property(nonatomic,strong)UIScrollView *scrollView;


@property(nonatomic,strong)XYScreeningGroupView *cityView;
@property(nonatomic,strong)XYScreeningSliderView *ageView;
@property(nonatomic,strong)XYScreeningSliderView *heightView;

@property(nonatomic,strong)XYScreeningSecectedGroupView *eduView;
@property(nonatomic,strong)XYScreeningSecectedGroupView *distanceView;

@property(nonatomic,strong)XYScreeningGroupView *juniorSchoolView;
@property(nonatomic,strong)XYScreeningGroupView *highSchoolView;

@property(nonatomic,strong)XYAddressItem *proviceItem;
@property(nonatomic,strong)XYAddressItem *cityItem;
@property(nonatomic,strong)XYAddressItem *  areaItem;

@property(nonatomic,strong)NSString *eduStr;

@property(nonatomic,strong)NSString *distanceStr;

@property(nonatomic,strong)UIView *bottomView;
@end
@implementation XYNormalScreeningView
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
  
  [self.scrollView addSubview:self.cityView];
  [self.cityView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.scrollView);
  }];
  
  [self.scrollView addSubview:self.ageView];
  [self.ageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.cityView.mas_bottom).offset(AutoSize(10));
  }];
  
  [self.scrollView addSubview:self.heightView];
  [self.heightView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.ageView.mas_bottom).offset(AutoSize(10));
  }];
  
  [self.scrollView addSubview:self.eduView];
  [self.eduView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.heightView.mas_bottom).offset(AutoSize(10));
  }];
  
  [self.scrollView addSubview:self.distanceView];
  [self.distanceView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.eduView.mas_bottom).offset(AutoSize(10));
  }];
  
  [self.scrollView addSubview:self.juniorSchoolView];
  [self.juniorSchoolView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.distanceView.mas_bottom).offset(AutoSize(10));
  }];
  
  [self.scrollView addSubview:self.highSchoolView];
  [self.highSchoolView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.juniorSchoolView.mas_bottom).offset(AutoSize(10));
    make.bottom.equalTo(self.scrollView).offset(-AutoSize(15));
  }];
  
  

  
  
}
-(void)show{
  [super show];
  
  // 数据回显
  if (self.reqParams.province) {
    self.proviceItem = [[XYAddressService sharedService] queryModelWithAdcode:self.reqParams.province];
  }
  if (self.reqParams.city) {
    self.cityItem = [[XYAddressService sharedService] queryModelWithAdcode:self.reqParams.city];
  }
  if (self.reqParams.area) {
    self.areaItem = [[XYAddressService sharedService] queryModelWithAdcode:self.reqParams.area];
  }
  [self setCityData];
}

-(XYScreeningGroupView *)cityView{
  if (!_cityView) {
    _cityView = [[XYScreeningGroupView alloc] initWithFrame:CGRectMake(0, 0, AutoSize(300), AutoSize(40))];
    _cityView.title = @"家乡地址";
    [_cityView handleTapGestureRecognizerEventWithBlock:^(id sender) {
      XYScreeningCityView *view = [[XYScreeningCityView alloc]initWithFrame:CGRectMake(AutoSize(75), 0, SCREEN_WIDTH-AutoSize(75), SCREEN_HEIGHT)];
      view.proviceItem = self.proviceItem;
      view.cityItem = self.cityItem;
      view.areaItem = self.areaItem;
      @weakify(self);
      view.selectedBlock = ^(XYAddressItem * _Nonnull proviceItem, XYAddressItem * _Nonnull cityItem, XYAddressItem * _Nonnull areaItem) {
        @strongify(self);
    
        self.proviceItem = proviceItem;
        self.cityItem = cityItem;
        self.areaItem = areaItem;
     
        [self setCityData];
        
      };
      [view show];
    }];
  }
  return _cityView;
}
-(void)setCityData{
  NSString *cityStr = @"";
  if (self.proviceItem) {
   cityStr = [NSString stringWithFormat:@"%@",self.proviceItem.name];
  }
  if (self.cityItem) {
    cityStr = [NSString stringWithFormat:@"%@%@",cityStr,self.cityItem.name];
  }
  if (self.areaItem) {
    cityStr = [NSString stringWithFormat:@"%@%@",cityStr,self.areaItem.name];
  }
  if (cityStr.length) {
    self.cityView.dataSource = @[cityStr];
  }
  
  [self.heightView insetMinSelectValue:self.reqParams.startHeight?[self.reqParams.startHeight integerValue]:155 maxSelectValue:self.reqParams.endHeight?[self.reqParams.endHeight integerValue]:170];
  
  [self.ageView insetMinSelectValue:self.reqParams.startAge?[self.reqParams.startAge integerValue]:22 maxSelectValue:self.reqParams.endAge?[self.reqParams.endAge integerValue]:40];
  
}
-(XYScreeningSliderView *)ageView{
  if (!_ageView) {
    _ageView = [[XYScreeningSliderView alloc] initWithMinValue:18 maxValue:50 minSelectValue:22 maxSelectValue:40 unit:@"岁"];
    _ageView.title = @"年龄";
//    @weakify(self);
//    _ageView.selectedBlock = ^(NSNumber * _Nonnull min, NSNumber * _Nonnull max) {
//      @strongify(self);
//      self.reqParams.startAge = min;
//      self.reqParams.endAge = max;
//    };
  }
  return _ageView;
}
-(XYScreeningSliderView *)heightView{
  if (!_heightView) {
    _heightView = [[XYScreeningSliderView alloc] initWithMinValue:140 maxValue:210 minSelectValue:155 maxSelectValue:170 unit:@"cm"];
    _heightView.title = @"身高";
//    @weakify(self);
//    _heightView.selectedBlock = ^(NSNumber * _Nonnull min, NSNumber * _Nonnull max) {
//      @strongify(self);
//
//    };
  }
  return _heightView;
}
-(XYScreeningSecectedGroupView *)eduView{
  if (!_eduView) {
    _eduView = [[XYScreeningSecectedGroupView alloc] initWithFrame:CGRectMake(0, 0, AutoSize(300), AutoSize(40))];
    _eduView.title = @"学历";
//    _eduView.dataSource = @[@{@"id":@"0",@"name":@"不限"},
//    @{@"id":@"1",@"name":@"初中及以下"},
//    @{@"id":@"2",@"name":@"高中及中专"},
//    @{@"id":@"3",@"name":@"大专"},
//    @{@"id":@"4",@"name":@"本科"},
//    @{@"id":@"5",@"name":@"硕士及以上"}];
    [_eduView reshEdu];
    @weakify(self);
    _eduView.selectedBlock = ^(NSDictionary * _Nonnull item) {
      @strongify(self);
      self.reqParams.education = [item objectForKey:@"name"];
    };
  }
  return _eduView;
}
-(XYScreeningSecectedGroupView *)distanceView{
  if (!_distanceView) {
    _distanceView = [[XYScreeningSecectedGroupView alloc] initWithFrame:CGRectMake(0, 0, AutoSize(300), AutoSize(40))];
    _distanceView.title = @"距离";
    _distanceView.dataSource = @[@{@"id":@"0",@"name":@"不限"},
    @{@"id":@"1",@"name":@"≤1km"},
    @{@"id":@"2",@"name":@"≤2km"},
    @{@"id":@"3",@"name":@"≤3km"},
    @{@"id":@"4",@"name":@"≤4km"},
    @{@"id":@"5",@"name":@"≤5km"}];
    @weakify(self);
    _distanceView.selectedBlock = ^(NSDictionary * _Nonnull item) {
      @strongify(self);
      self.reqParams.education = [item objectForKey:@"id"];
    };
  }
  return _distanceView;
}
-(XYScreeningGroupView *)juniorSchoolView{
  if (!_juniorSchoolView) {
    _juniorSchoolView =  [[XYScreeningGroupView alloc] initWithFrame:CGRectMake(0, 0, AutoSize(300), AutoSize(40))];
    _juniorSchoolView.title = @"初中毕业学校";
    [_juniorSchoolView handleTapGestureRecognizerEventWithBlock:^(id sender) {
      XYScreeningSchoolView *view = [[XYScreeningSchoolView alloc]initWithFrame:CGRectMake(AutoSize(75), 0, SCREEN_WIDTH-AutoSize(75), SCREEN_HEIGHT)];
      view.schoolType = 1;
      view.reqParams = self.reqParams;
      @weakify(self);
      view.selectedBlock = ^(XYSchoolModel * _Nonnull school) {
        @strongify(self);
        self.juniorSchoolView.dataSource = @[school.schoolName];
        self.reqParams.middleSchool = school.schoolName;
      };
      [view show];
    }];
  }
  return _juniorSchoolView;
}
-(XYScreeningGroupView *)highSchoolView{
  if (!_highSchoolView) {
    _highSchoolView =  [[XYScreeningGroupView alloc] initWithFrame:CGRectMake(0, 0, AutoSize(300), AutoSize(40))];
    _highSchoolView.title = @"高中毕业学校";
    [_highSchoolView handleTapGestureRecognizerEventWithBlock:^(id sender) {
      XYScreeningSchoolView *view = [[XYScreeningSchoolView alloc]initWithFrame:CGRectMake(AutoSize(75), 0, SCREEN_WIDTH-AutoSize(75), SCREEN_HEIGHT)];
      view.schoolType = 2;
      view.reqParams = self.reqParams;
      @weakify(self);
      view.selectedBlock = ^(XYSchoolModel * _Nonnull school) {
        @strongify(self);
        self.highSchoolView.dataSource = @[school.schoolName];
        self.reqParams.highSchool = school.schoolName;
      };
      [view show];
    }];
  }
  return _highSchoolView;
}
-(UIView *)bottomView{
  if (!_bottomView) {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *confirmBtn=[LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(14) buttonTitle:@"确定" buttonTitleColor:ColorHex(XYTextColor_FFFFFF)];
    [confirmBtn roundSize:AutoSize(18)];
    confirmBtn.backgroundColor = ColorHex(@"#F92B5E");
    [confirmBtn handleControlEventWithBlock:^(id sender) {
      
      
      self.reqParams.province = self.proviceItem.code;
      self.reqParams.city = self.cityItem.code;
      self.reqParams.area = self.areaItem.code;
      
      self.reqParams.startAge = @((int)self.ageView.slider.selectedMinimum);
      self.reqParams.endAge =  @((int)self.ageView.slider.selectedMaximum);
      
      self.reqParams.startHeight = @((int)self.heightView.slider.selectedMinimum);
      self.reqParams.endHeight =  @((int)self.heightView.slider.selectedMaximum);
      
      if (self.selectedBlock) {
        self.selectedBlock(@{});
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
      self.reqParams.province = [[XYUserService service] fetchLoginUser].province;
      self.reqParams.city = [[XYUserService service] fetchLoginUser].city;
      self.reqParams.area = nil;
      self.reqParams.highSchool = nil;
      self.reqParams.middleSchool = nil;
      self.highSchoolView.dataSource=@[];
      self.juniorSchoolView.dataSource=@[];
      self.reqParams.startAge = nil;
      self.reqParams.endAge =  nil;
      self.reqParams.education = nil;
      self.reqParams.distance = nil;
      self.reqParams.startHeight = nil;
      self.reqParams.endHeight =  nil;
      
      
    
      [self.distanceView resetData ];
      [self.eduView resetData ];
      // 数据回显
      if (self.reqParams.province) {
        self.proviceItem = [[XYAddressService sharedService] queryModelWithAdcode:self.reqParams.province];
      }
      if (self.reqParams.city) {
        self.cityItem = [[XYAddressService sharedService] queryModelWithAdcode:self.reqParams.city];
      }
      if (self.reqParams.area) {
        self.areaItem = [[XYAddressService sharedService] queryModelWithAdcode:self.reqParams.area];
      }
      [self setCityData];
      
      
      
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
