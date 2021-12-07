//
//  XYAddressContentView.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/30.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYAddressContentView.h"
#import "XYAddressSelectorCell.h"
#import "XYAddressMenu.h"

@interface XYAddressContentView () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) XYAddressMenu * tabbar;

@property (nonatomic,strong) UIScrollView * contentView;

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *descLable;

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) UIButton *sureBtn;

@property (nonatomic,strong) UIView *topBgView;
@property (nonatomic,strong) UIView *centerBgView;

@property (nonatomic,strong) UIView *separtLine;

@property (nonatomic,strong) UIView *underLine;

@property (nonatomic,strong) NSMutableArray * tableViews;

@property (nonatomic,strong) NSMutableArray <UIButton *> * items;

@property (nonatomic,weak) UIButton * selectedButton;

@property (nonatomic,strong) NSArray <XYAddressItem *> * dataSouce;

@property (nonatomic,strong) NSArray <XYAddressItem *> * cityDataSouce;

@property (nonatomic,strong) NSArray <XYAddressItem *> * districtDataSouce;

@property (nonatomic,strong) NSArray <XYAddressItem *> * townDataSouce;

@property (nonatomic, assign, getter=isWithoutTitleView) BOOL withoutTitleView;

@property (nonatomic, assign, getter=isWithTown) BOOL withTown;

@property (nonatomic, assign, getter=isWithSure) BOOL withSure;

@property (nonatomic, strong) NSIndexPath *firstSelectedIndexPath;
@property (nonatomic, strong) NSIndexPath *secondSelectedIndexPath;
@property (nonatomic, strong) NSIndexPath *thirdSelectedIndexPath;
@property (nonatomic, strong) NSIndexPath *forthSelectedIndexPath;

@end

@implementation XYAddressContentView

- (instancetype)initWithWithoutTitleView:(BOOL)withoutTitleView withTown:(BOOL)withTown withSure:(BOOL)withSure {
    if (self = [super init]) {
      self.withoutTitleView = withoutTitleView;
      self.withTown = withTown;
      self.withSure = withSure;
      [self setupViews];
    }
    return self;
}
- (instancetype)initWithWithoutTitleView:(BOOL)withoutTitleView withTown:(BOOL)withTown withSure:(BOOL)withSure  withDesc:(NSString *)desc{
  if (self = [super init]) {
    self.withoutTitleView = withoutTitleView;
    self.withTown = withTown;
    self.withSure = withSure;
    self.desc = desc;
    [self setupViews];
  }
  return self;
}
- (void)setupViews {
  if (!self.isWithoutTitleView) {
    [self addSubview:self.topBgView];
    [self.topBgView addSubview:self.titleLable];
    [self.topBgView addSubview:self.closeBtn];
  }
 // [self addSubview:self.centerBgView];
  [self addSubview:self.descLable];
  [self addSubview:self.tabbar];
  [self addSubview:self.separtLine];
  [self.tabbar addSubview:self.underLine];
  [self addSubview:self.contentView];
  
  if (self.isWithoutTitleView) {
    self.tabbar.frame = CGRectMake(0, 0, kScreenWidth, 44);
    
    self.separtLine.frame = CGRectMake(0, 45, kScreenWidth, 1);
    
    self.contentView.frame = CGRectMake(0, 47, kScreenWidth, 290);
  } else {
    self.topBgView.frame = CGRectMake(0, 0, kScreenWidth, 44);
    
    self.centerBgView.frame = CGRectMake(0, 40, kScreenWidth, CGRectGetMinY(self.frame));
    
    
    self.closeBtn.frame = CGRectMake(kScreenWidth-38, 16, 22, 22);
    
    self.titleLable.frame = CGRectMake(16, 8, CGRectGetMinX(self.closeBtn.frame)-16, 36);
    
    self.descLable.frame = CGRectMake(16, 45, CGRectGetMinX(self.closeBtn.frame)-16,self.desc? 20:0);
//
//    if (self.desc) {
//
//    }else{
//      self.tabbar.frame = CGRectMake(0, CGRectGetMinY(self.descLable.frame), kScreenWidth, 44);
//      self.separtLine.frame = CGRectMake(0, CGRectGetMaxY(self.tabbar.frame), kScreenWidth, 1);
//
//      self.contentView.frame = CGRectMake(0, CGRectGetMaxY(self.separtLine.frame), kScreenWidth, 290);
//    }
    
    self.tabbar.frame = CGRectMake(0, CGRectGetMaxY(self.descLable.frame), kScreenWidth, 44);
    self.separtLine.frame = CGRectMake(0, CGRectGetMaxY(self.tabbar.frame), kScreenWidth, 1);
    
    self.contentView.frame = CGRectMake(0, CGRectGetMaxY(self.separtLine.frame), kScreenWidth, 270);
    

    
    
   CGRect frame = CGRectMake(0, 0, kScreenWidth, 400);
//    //绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = frame;

    //设置图形样子
    maskLayer.path = maskPath.CGPath;

    self.layer.mask = maskLayer;
 
    
  }
  
  if (self.isWithSure) {
    [self addSubview:self.sureBtn];
    self.sureBtn.frame = CGRectMake(kScreenWidth-44, self.isWithoutTitleView ? 0 : 45, 44, 44);
  }
  
  [self addTopBarItem];
  
  self.underLine.XY_height = 2;
  self.underLine.top = 42;
  [self.tabbar layoutIfNeeded];
  
  UIButton * btn = self.items.lastObject;
  [self changeUnderLineFrame:btn];
  
  [self addTableView];
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([self.tableViews indexOfObject:tableView] == 0){
        return self.dataSouce.count;
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        return self.cityDataSouce.count;
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        return self.districtDataSouce.count;
    }  else if ([self.tableViews indexOfObject:tableView] == 3) {
      return self.townDataSouce.count;
  }
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYAddressSelectorCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YWAddressTableViewCell"];
    if (!cell) {
        cell = [[XYAddressSelectorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YWAddressTableViewCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    XYAddressItem * item;
    //省级别
    if([self.tableViews indexOfObject:tableView] == 0){
        item = self.dataSouce[indexPath.row];
        //市级别
    } else if ([self.tableViews indexOfObject:tableView] == 1){
        item = self.cityDataSouce[indexPath.row];
        //县级别
    } else if ([self.tableViews indexOfObject:tableView] == 2){
        item = self.districtDataSouce[indexPath.row];
    }  else if ([self.tableViews indexOfObject:tableView] == 3){
      item = self.townDataSouce[indexPath.row];
  }
    cell.title = item.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView selectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.tableViews indexOfObject:tableView] == 0) {
        //1.1 获取下一级别的数据源(市级别,如果是直辖市时,下级则为区级别)
        XYAddressItem * provinceItem = self.dataSouce[indexPath.row];
        self.cityDataSouce = [[XYAddressService sharedService] querySubAreaWithAdcode:provinceItem.code level:XYAddressLevelSecond];

        //选择过省
        if (self.firstSelectedIndexPath) {
          NSInteger tableViewsCount = self.tableViews.count;
            for (int i = 1; i < tableViewsCount; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:provinceItem.name];
        } else {
          //第一次选择省
          [self addTopBarItem];
          [self addTableView];
          XYAddressItem * item = self.dataSouce[indexPath.row];
          [self scrollToNextItem:item.name];
        }
        
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        
        XYAddressItem * cityItem = self.cityDataSouce[indexPath.row];
        self.districtDataSouce = [[XYAddressService sharedService] querySubAreaWithAdcode:cityItem.code level:XYAddressLevelThird];
        
        if (self.secondSelectedIndexPath) {
          NSInteger tableViewsCount = self.tableViews.count;
          for (int i = 2; i < tableViewsCount; i++) {
              [self removeLastItem];
          }
          [self addTopBarItem];
          [self addTableView];
          [self scrollToNextItem:cityItem.name];
        } else {
          [self addTopBarItem];
          [self addTableView];
          XYAddressItem * item = self.cityDataSouce[indexPath.row];
          [self scrollToNextItem:item.name];
          
        }
        
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
      if (self.withTown) {
        XYAddressItem * areaItem = self.districtDataSouce[indexPath.row];
        [XYLoadingHUD showOnView:self];
        [[XYAddressService sharedService] queryTownWithAreacode:areaItem.code block:^(NSArray *data) {
          [XYLoadingHUD hiddenOnView:self];
          self.townDataSouce = data;
          
          if (self.thirdSelectedIndexPath) {
            NSInteger tableViewsCount = self.tableViews.count;
            for (int i = 3; i < tableViewsCount; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:areaItem.name];
          } else {
            [self addTopBarItem];
            [self addTableView];
            XYAddressItem * item = self.districtDataSouce[indexPath.row];
            [self scrollToNextItem:item.name];
          }
          self.thirdSelectedIndexPath = indexPath;
        }];
      } else {
        XYAddressItem * item = self.districtDataSouce[indexPath.row];
        [self setUpAddress:item];
      }
    } else if ([self.tableViews indexOfObject:tableView] == 3) {
      XYAddressItem * item = self.townDataSouce[indexPath.row];
      [self setUpAddress:item];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:tableView selectRowAtIndexPath:indexPath];
  
    XYAddressItem * item;
    if([self.tableViews indexOfObject:tableView] == 0) {
        item = self.dataSouce[indexPath.row];
      self.firstSelectedIndexPath = indexPath;
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        item = self.cityDataSouce[indexPath.row];
      self.secondSelectedIndexPath = indexPath;
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        item = self.districtDataSouce[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 3) {
      item = self.townDataSouce[indexPath.row];
      self.forthSelectedIndexPath = indexPath;
    }
    item.isSelected = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XYAddressItem * item;
    if([self.tableViews indexOfObject:tableView] == 0) {
        item = self.dataSouce[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        item = self.cityDataSouce[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        item = self.districtDataSouce[indexPath.row];
    }  else if ([self.tableViews indexOfObject:tableView] == 3) {
        item = self.townDataSouce[indexPath.row];
  }
    item.isSelected = NO;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
#pragma mark - <UIScrollView>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView != self.contentView) return;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        NSInteger index = scrollView.contentOffset.x / kScreenWidth;
        UIButton * btn = weakSelf.items[index];
        [weakSelf changeUnderLineFrame:btn];
    }];
}
#pragma mark - private
- (void)addTableView {
    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * kScreenWidth, 0, kScreenWidth, _contentView.XY_height)];
    [_contentView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
}

- (void)addTopBarItem {
    UIButton * barItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [barItem setTitle:@"请选择" forState:UIControlStateNormal];
    barItem.titleLabel.font = AdaptedMediumFont(XYFont_D);
    [barItem setTitleColor:ColorHex(XYTextColor_222222) forState:UIControlStateNormal];
    [barItem setTitleColor:ColorHex(XYTextColor_FE2D63) forState:UIControlStateSelected];
//    [barItem sizeToFit];
    barItem.XY_width = (kScreenWidth-10*(self.withTown ? 5 : 4))/(self.withTown ? 4 : 3);
    barItem.XY_height = 30;
    barItem.centerY = _tabbar.XY_height * 0.5;
    [self.items addObject:barItem];
    [_tabbar addSubview:barItem];
    [barItem addTarget:self action:@selector(barItemClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)barItemClick:(UIButton *)btn {
    NSInteger index = [self.items indexOfObject:btn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index * kScreenWidth, 0);
        [self changeUnderLineFrame:btn];
    }];
}

- (void)changeUnderLineFrame:(UIButton  *)btn {
    _selectedButton.selected = NO;
    btn.selected = YES;
    _selectedButton = btn;
    _underLine.XY_left = btn.XY_left;
    _underLine.XY_width = btn.XY_width;
}

- (void)removeLastItem {
    
    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.items.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.items removeLastObject];
}

- (void)scrollToNextItem:(NSString *)preTitle {
    
    NSInteger index = self.contentView.contentOffset.x / kScreenWidth;
    UIButton * btn = self.items[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
//    [btn sizeToFit];
    [_tabbar layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.contentSize = (CGSize){self.tableViews.count * kScreenWidth,0};
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + kScreenWidth, offset.y);
        [self changeUnderLineFrame: [self.tabbar.subviews lastObject]];
    }];
}

//完成地址选择,执行chooseFinish代码块
- (void)setUpAddress:(XYAddressItem *)item {
    
    NSInteger index = self.contentView.contentOffset.x / kScreenWidth;
    UIButton * btn = self.items[index];
    [btn setTitle:item.name forState:UIControlStateNormal];
//    [btn sizeToFit];
    [_tabbar layoutIfNeeded];
    [self changeUnderLineFrame:btn];
  
    XYFormattedArea *area = [[XYFormattedArea alloc] init];
    NSMutableString * addressStr = [[NSMutableString alloc] init];
    NSInteger i = 0;
    for (UIButton * btn in self.items) {
        if (i == 0) {
          area.provinceName = btn.currentTitle;
        } else if (i == 1) {
          area.cityName = btn.currentTitle;
        } else if (i == 2) {
          area.districtName = btn.currentTitle;
        }  else if (i == 3) {
          area.townName = btn.currentTitle;
          area.townCode = item.code;
         }
        [addressStr appendString:btn.currentTitle];
        i ++;
    }
    area.formattedAddress = addressStr;
  area.provinceCode = self.withTown ? [item.parentId stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"0000"] : [item.code stringByReplacingCharactersInRange:NSMakeRange(2, 4) withString:@"0000"];
  area.cityCode = self.withTown ? [item.parentId stringByReplacingCharactersInRange:NSMakeRange(4, 2) withString:@"00"] : [item.code stringByReplacingCharactersInRange:NSMakeRange(4, 2) withString:@"00"];
  area.code = self.withTown ? item.parentId : item.code;
    
    if (self.chooseFinish) self.chooseFinish(area);
}

- (void)setAdcode:(NSString *)adcode {
  _adcode = adcode;
  if (!adcode || adcode.length < 6) return;
  
  NSString *areaCode = adcode;
  if (adcode.length == 8) areaCode = [adcode substringToIndex:6];
  
  self.cityDataSouce = [[XYAddressService sharedService]
                        querySubAreaWithAdcode:areaCode
                        level:XYAddressLevelSecond];
  
  self.districtDataSouce = [[XYAddressService sharedService]
                            querySubAreaWithAdcode:areaCode
                            level:XYAddressLevelThird];
  
  dispatch_group_t batch_api_group = dispatch_group_create();
  dispatch_group_enter(batch_api_group);
  if (adcode.length == 8) {
    [[XYAddressService sharedService] queryTownWithAreacode:areaCode block:^(NSArray *data) {
      self.townDataSouce = data;
      dispatch_group_leave(batch_api_group);
    }];
  } else {
    dispatch_group_leave(batch_api_group);
  }
  dispatch_group_notify(batch_api_group, dispatch_get_main_queue(), ^{
    NSUInteger viewCount = adcode.length == 8 ? 3 : 2;
    for (int i = 0; i < viewCount; i ++) {
      [self addTableView];
      [self addTopBarItem];
    }
    
    NSString * provinceName = [[XYAddressService sharedService] queryAreaNameWithAdcode:[areaCode stringByReplacingCharactersInRange:(NSRange){2,4} withString:@"0000"]];
    UIButton * firstBtn = self.items.firstObject;
    [firstBtn setTitle:provinceName forState:UIControlStateNormal];
    
    NSString * cityName = [[XYAddressService sharedService] queryAreaNameWithAdcode:[areaCode stringByReplacingCharactersInRange:NSMakeRange(4, 2) withString:@"00"]];
    UIButton * midBtn = self.items[1];
    [midBtn setTitle:cityName forState:UIControlStateNormal];
    
    NSString * districtName = [[XYAddressService sharedService] queryAreaNameWithAdcode:areaCode];
    NSString * townName;
    UIButton * lastBtn;
    if (adcode.length == 8) {
      UIButton * thirdBtn = self.items[2];
      [thirdBtn setTitle:districtName forState:UIControlStateNormal];
      
      for (XYAddressItem *item in self.townDataSouce) {
        if ([item.code isEqualToString:adcode]) {
          townName = item.name;
          lastBtn = self.items.lastObject;
          [lastBtn setTitle:townName forState:UIControlStateNormal];
          break;
        }
      }
    } else {
      lastBtn = self.items.lastObject;
      [lastBtn setTitle:districtName forState:UIControlStateNormal];
    }
    
//    [self.items makeObjectsPerformSelector:@selector(sizeToFit)];
    [self.tabbar layoutIfNeeded];
    
    [self changeUnderLineFrame:lastBtn];
    
    //2.4 设置偏移量
    self.contentView.contentSize = (CGSize){self.tableViews.count * kScreenWidth,0};
    CGPoint offset = self.contentView.contentOffset;
    self.contentView.contentOffset = CGPointMake((self.tableViews.count - 1) * kScreenWidth, offset.y);
    
    [self setSelectedProvince:provinceName andCity:cityName andDistrict:districtName andTownName:townName];
  });
}

//初始化选中状态
- (void)setSelectedProvince:(NSString *)provinceName
                    andCity:(NSString *)cityName
                andDistrict:(NSString *)districtName
                andTownName:(NSString *)townName {
    
    for (XYAddressItem * item in self.dataSouce) {
        if ([item.name isEqualToString:provinceName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.dataSouce indexOfObject:item] inSection:0];
            UITableView * tableView  = self.tableViews.firstObject;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
          self.firstSelectedIndexPath = indexPath;
            break;
        }
    }
    
    for (int i = 0; i < self.cityDataSouce.count; i++) {
        XYAddressItem * item = self.cityDataSouce[i];
        
        if ([item.name isEqualToString:cityName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView * tableView  = self.tableViews[1];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
          self.secondSelectedIndexPath = indexPath;
            break;
        }
    }
    
    for (int i = 0; i <self.districtDataSouce.count; i++) {
        XYAddressItem * item = self.districtDataSouce[i];
        if ([item.name isEqualToString:districtName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView * tableView  = self.tableViews[2];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
          self.thirdSelectedIndexPath = indexPath;
            break;
        }
    }
    
  if (townName.isNotBlank) {
    for (int i = 0; i <self.townDataSouce.count; i++) {
        XYAddressItem * item = self.townDataSouce[i];
        if ([item.name isEqualToString:townName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView * tableView  = self.tableViews[3];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
          self.forthSelectedIndexPath = indexPath;
            break;
        }
    }
  }
}

- (void)dismiss {
    if (self.dismissAction) self.dismissAction();
}

- (void)sure {
  XYFormattedArea *area = [[XYFormattedArea alloc] init];
  if (!self.firstSelectedIndexPath) {
    if (self.chooseFinish) self.chooseFinish(area);
    return;
  }
  
  if (!self.secondSelectedIndexPath) {
    area.provinceCode = self.dataSouce[self.firstSelectedIndexPath.row].code;
    area.provinceName = self.dataSouce[self.firstSelectedIndexPath.row].name;
    area.latitude = self.dataSouce[self.firstSelectedIndexPath.row].latitude.floatValue;
    area.longitude = self.dataSouce[self.firstSelectedIndexPath.row].longitude.floatValue;
    area.formattedAddress = area.provinceName;
    if (self.chooseFinish) self.chooseFinish(area);
    return;
  }
  
  if (!self.thirdSelectedIndexPath) {
    area.provinceCode = self.dataSouce[self.firstSelectedIndexPath.row].code;
    area.provinceName = self.dataSouce[self.firstSelectedIndexPath.row].name;
    area.cityCode = self.dataSouce[self.secondSelectedIndexPath.row].code;
    area.cityName = self.dataSouce[self.secondSelectedIndexPath.row].name;
    area.latitude = self.cityDataSouce[self.secondSelectedIndexPath.row].latitude.floatValue;
    area.longitude = self.cityDataSouce[self.secondSelectedIndexPath.row].longitude.floatValue;
    area.formattedAddress = [NSString stringWithFormat:@"%@%@",area.provinceName, area.cityName];
    if (self.chooseFinish) self.chooseFinish(area);
    return;
  }
  
  if (!self.forthSelectedIndexPath) {
    area.provinceCode = self.dataSouce[self.firstSelectedIndexPath.row].code;
    area.provinceName = self.dataSouce[self.firstSelectedIndexPath.row].name;
    area.cityCode = self.dataSouce[self.secondSelectedIndexPath.row].code;
    area.cityName = self.dataSouce[self.secondSelectedIndexPath.row].name;
    area.code = self.dataSouce[self.thirdSelectedIndexPath.row].code;
    area.districtName = self.dataSouce[self.thirdSelectedIndexPath.row].name;
    area.latitude = self.cityDataSouce[self.thirdSelectedIndexPath.row].latitude.floatValue;
    area.longitude = self.cityDataSouce[self.thirdSelectedIndexPath.row].longitude.floatValue;
    area.formattedAddress = [NSString stringWithFormat:@"%@%@%@",area.provinceName, area.cityName, area.districtName];
    if (self.chooseFinish) self.chooseFinish(area);
    return;
  }
  
  area.provinceCode = self.dataSouce[self.firstSelectedIndexPath.row].code;
  area.provinceName = self.dataSouce[self.firstSelectedIndexPath.row].name;
  area.cityCode = self.dataSouce[self.secondSelectedIndexPath.row].code;
  area.cityName = self.dataSouce[self.secondSelectedIndexPath.row].name;
  area.code = self.dataSouce[self.thirdSelectedIndexPath.row].code;
  area.districtName = self.dataSouce[self.thirdSelectedIndexPath.row].name;
  area.townCode = self.dataSouce[self.forthSelectedIndexPath.row].code;
  area.townName = self.dataSouce[self.forthSelectedIndexPath.row].name;
  area.latitude = self.cityDataSouce[self.forthSelectedIndexPath.row].latitude.floatValue;
  area.longitude = self.cityDataSouce[self.forthSelectedIndexPath.row].longitude.floatValue;
  area.formattedAddress = [NSString stringWithFormat:@"%@%@%@%@",area.provinceName, area.cityName, area.districtName, area.townName];
  if (self.chooseFinish) self.chooseFinish(area);
  
}

#pragma mark - getter

- (XYAddressMenu *)tabbar {
    if (!_tabbar) {
        _tabbar = [[XYAddressMenu alloc] init];
    }
    return _tabbar;
}
- (UIScrollView *)contentView {
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.contentSize = CGSizeMake(kScreenWidth, 0);
        _contentView.pagingEnabled = YES;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.delegate = self;
    }
    return _contentView;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = AdaptedFont(XYFont_D);
        _titleLable.textColor = ColorHex(XYTextColor_666666);
        _titleLable.text = @"选择地区";
    }
    return _titleLable;
}
-(UILabel *)descLable{
  if (!_descLable) {
    _descLable = [[UILabel alloc] init];
    _descLable.font = AdaptedFont(XYFont_D);
    _descLable.textColor = ColorHex(XYTextColor_FF5672);
    _descLable.text = @"家乡地址将不能更改，请认真填写";
    _descLable.clipsToBounds = YES;
  }
  return _descLable;
}
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"icon-pop-Close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
      _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      _sureBtn.titleLabel.font = AdaptedFont(15);
      [_sureBtn setTitleColor:ColorHex(XYTextColor_FE2D63) forState:UIControlStateNormal];
      [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
      [_sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = ColorHex(XYThemeColor_F);
      
      CGRect frame = CGRectMake(0, 0, kScreenWidth, 44);
      //绘制圆角 要设置的圆角 使用“|”来组合
      UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
      
      CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
      //设置大小
      maskLayer.frame = frame;
      
      //设置图形样子
      maskLayer.path = maskPath.CGPath;
      
      _topBgView.layer.mask = maskLayer;
      _topBgView.layer.masksToBounds = YES;
      
    //  [self roundSize:10];
      
    }
    return _topBgView;
}

-(UIView *)centerBgView{
  if (!_centerBgView) {
    _centerBgView = [LSHControl viewWithBackgroundColor:[UIColor whiteColor]];
  }
  return _centerBgView;
}
- (UIView *)separtLine {
    if (!_separtLine) {
        _separtLine = [[UIView alloc] init];
        _separtLine.backgroundColor = ColorHex(XYThemeColor_E);
    }
    return _separtLine;
}

- (UIView *)underLine {
    if (!_underLine) {
        _underLine = [[UIView alloc] init];
        _underLine.backgroundColor = ColorHex(XYThemeColor_A);
    }
    return _underLine;
}

- (NSArray *)dataSouce {
    if (!_dataSouce) {
        _dataSouce = [[XYAddressService sharedService] queryProvince];
    }
    return _dataSouce;
}

- (NSMutableArray *)tableViews {
    
    if (!_tableViews) {
        _tableViews = @[].mutableCopy;
    }
    return _tableViews;
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = @[].mutableCopy;
    }
    return _items;
}
@end
