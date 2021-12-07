//
//  XYIndustryCircleScreenView.m
//  Xiangyu
//
//  Created by Kang on 2021/8/9.
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
#import "XYIndustryCircleScreenView.h"
#import "XYScreeningGroupView.h"
#import "XYScreeningSliderView.h"
#import "XYScreeningSecectedGroupView.h"

#import "XYScreeningCityView.h"
#import "XYScreeningSchoolView.h"

#import "XYLinkageRecycleViewController.h"

@interface XYIndustryCircleScreenView ()
@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)XYScreeningGroupView *industryView;

@property(nonatomic,strong)XYScreeningGroupView *cityView;

@property(nonatomic,strong)XYScreeningGroupView *dwellcityView;






@property(nonatomic,strong)XYScreeningGroupView *juniorSchoolView;
@property(nonatomic,strong)XYScreeningGroupView *highSchoolView;

@property(nonatomic,strong)XYAddressItem *proviceItem;
@property(nonatomic,strong)XYAddressItem *cityItem;
@property(nonatomic,strong)XYAddressItem *  areaItem;

@property(nonatomic,strong)XYAddressItem *dwellproviceItem;
@property(nonatomic,strong)XYAddressItem *dwellcityItem;
@property(nonatomic,strong)XYAddressItem *  dwellareaItem;



@property(nonatomic,strong)UIView *bottomView;
@end
@implementation XYIndustryCircleScreenView
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
  
  //
  
  [self.scrollView addSubview:self.industryView];
  [self.industryView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.scrollView);
  }];
  
  [self.scrollView addSubview:self.cityView];
  [self.cityView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.industryView.mas_bottom).offset(AutoSize(10));
  }];
  
  [self.scrollView addSubview:self.dwellcityView];
  [self.dwellcityView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.cityView.mas_bottom).offset(AutoSize(10));
  }];
  
  
  
  [self.scrollView addSubview:self.juniorSchoolView];
  [self.juniorSchoolView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.dwellcityView.mas_bottom).offset(AutoSize(10));
  }];
  
  [self.scrollView addSubview:self.highSchoolView];
  [self.highSchoolView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self);
    make.top.equalTo(self.juniorSchoolView.mas_bottom).offset(AutoSize(10));
    make.bottom.equalTo(self.scrollView).offset(-AutoSize(15));
  }];
  
  

  
  
}
-(void)showWithStateBlock:(FWPopupStateBlock)stateBlock{
  [super showWithStateBlock:stateBlock];
  
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
  
  // 数据回显
  if (self.reqParams.dwellProvince) {
    self.dwellproviceItem = [[XYAddressService sharedService] queryModelWithAdcode:self.reqParams.dwellProvince];
  }
  if (self.reqParams.dwellCity) {
    self.dwellcityItem = [[XYAddressService sharedService] queryModelWithAdcode:self.reqParams.dwellCity];
  }
  if (self.reqParams.dwellArea) {
    self.dwellareaItem = [[XYAddressService sharedService] queryModelWithAdcode:self.reqParams.dwellArea];
  }
  
  if (self.industryName) {
    self.industryView.dataSource = @[self.industryName];
  }
  
  
  [self setCityData];
}
-(XYScreeningGroupView *)industryView{
  if (!_industryView) {
    _industryView = [[XYScreeningGroupView alloc] initWithFrame:CGRectMake(0, 0, AutoSize(300), AutoSize(40))];
    _industryView.title = @"行业";
    @weakify(self);
    [_industryView handleTapGestureRecognizerEventWithBlock:^(id sender) {
  
      @strongify(self);
      [self selectIndustry];
      
      
    }];
  }
  return _industryView;
}

- (void)selectIndustry {
  @weakify(self);
  //self.hidden = YES;
  
  [self.attachedView sendSubviewToBack:self];
  

  
  XYLinkageRecycleViewController *vc = [[XYLinkageRecycleViewController alloc] init];
  vc.selectedBlock = ^(NSString *name, NSNumber *firstCode, NSNumber *secondCode) {
    @strongify(self);
    [self.attachedView bringSubviewToFront:self];
   // weak_self.hidden = NO;
    self.industryName = name;
    self.industryView.dataSource= @[name];
    self.reqParams.oneIndustry = firstCode;
    self.reqParams.twoIndustry = secondCode;
  };
  [self.targetVc.navigationController pushViewController:vc animated:YES];
}


-(XYScreeningGroupView *)cityView{
  if (!_cityView) {
    _cityView = [[XYScreeningGroupView alloc] initWithFrame:CGRectMake(0, 0, AutoSize(300), AutoSize(40))];
    _cityView.title = @"故乡地址";
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


-(XYScreeningGroupView *)dwellcityView{
  if (!_dwellcityView) {
    _dwellcityView = [[XYScreeningGroupView alloc] initWithFrame:CGRectMake(0, 0, AutoSize(300), AutoSize(40))];
    _dwellcityView.title = @"现居住地";
    [_dwellcityView handleTapGestureRecognizerEventWithBlock:^(id sender) {
      XYScreeningCityView *view = [[XYScreeningCityView alloc]initWithFrame:CGRectMake(AutoSize(75), 0, SCREEN_WIDTH-AutoSize(75), SCREEN_HEIGHT)];
      view.proviceItem = self.dwellproviceItem;
      view.cityItem = self.dwellcityItem;
      view.areaItem = self.dwellareaItem;
      @weakify(self);
      view.selectedBlock = ^(XYAddressItem * _Nonnull proviceItem, XYAddressItem * _Nonnull cityItem, XYAddressItem * _Nonnull areaItem) {
        @strongify(self);
    
        self.dwellproviceItem = proviceItem;
        self.dwellcityItem = cityItem;
        self.dwellareaItem = areaItem;
     
        [self setCityData];
        
      };
      [view show];
    }];
  }
  return _dwellcityView;
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
  
  
  NSString *dwellcityStr = @"";
  if (self.dwellproviceItem) {
    dwellcityStr = [NSString stringWithFormat:@"%@",self.dwellproviceItem.name];
  }
  if (self.dwellcityItem) {
    dwellcityStr = [NSString stringWithFormat:@"%@%@",dwellcityStr,self.dwellcityItem.name];
  }
  if (self.dwellareaItem) {
    dwellcityStr = [NSString stringWithFormat:@"%@%@",dwellcityStr,self.dwellareaItem.name];
  }
  if (dwellcityStr.length) {
    self.dwellcityView.dataSource = @[dwellcityStr];
  }
  

  
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
      self.industryView.dataSource=@[];
      self.reqParams.startAge = nil;
      self.reqParams.endAge =  nil;
      self.reqParams.education = nil;
      self.reqParams.distance = nil;
      self.reqParams.startHeight = nil;
      self.reqParams.endHeight =  nil;
      self.reqParams.oneIndustry=@(-10);
      self.reqParams.twoIndustry=@(-10);
   
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
      
      // 数据回显
      if (self.reqParams.dwellProvince) {
        self.dwellproviceItem = [[XYAddressService sharedService] queryModelWithAdcode:self.reqParams.dwellProvince];
      }
      if (self.reqParams.dwellCity) {
        self.dwellcityItem = [[XYAddressService sharedService] queryModelWithAdcode:self.reqParams.dwellCity];
      }
      if (self.reqParams.dwellArea) {
        self.dwellareaItem = [[XYAddressService sharedService] queryModelWithAdcode:self.reqParams.dwellArea];
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
