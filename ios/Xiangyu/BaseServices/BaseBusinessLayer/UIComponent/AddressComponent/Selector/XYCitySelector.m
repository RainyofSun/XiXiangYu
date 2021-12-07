//
//  XYCitySelector.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/21.
//

#import "XYCitySelector.h"
#import "XYAddressService.h"
#import "GCDThrottle.h"
#import "XYLocationService.h"
#import "UIButton+Extension.h"

@interface XYCitySelectorTextField : UITextField

@end

@implementation XYCitySelectorTextField
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 12; //像右边偏15
    return iconRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 35, 0);
    
}
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 35, 0);
}
@end

@interface XYCitySelectorHeader : UITableViewHeaderFooterView

@property (nonatomic,strong) UILabel *curTitleLable;

@property (nonatomic,strong) UIButton *curBtn;

@property (nonatomic,strong) UILabel *hotTitleLable;

@property (nonatomic,copy) NSArray <XYAddressItem *> *hotCitys;

@property (nonatomic,copy) void(^selectedBlock)(XYAddressItem *item);

@property (nonatomic,strong) XYAddressItem *curItem;

@end

@implementation XYCitySelectorHeader

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      self.contentView.backgroundColor = ColorHex(XYThemeColor_F);
        [self setupSubViews];
    }
    return self;
}


- (void)setHotCitys:(NSArray *)hotCitys {
  _hotCitys = hotCitys;
  NSUInteger index = 0;
  CGFloat btn_W = (kScreenWidth-48)/3;
  for (XYAddressItem *item in hotCitys) {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:item.name forState:UIControlStateNormal];
    [btn setTitleColor:ColorHex(XYTextColor_333333) forState:UIControlStateNormal];
    btn.titleLabel.font = AdaptedFont(15);
    [btn setBackgroundColor:ColorHex(XYThemeColor_B)];
    btn.layer.cornerRadius = 4;
    btn.frame = CGRectMake(12*(index%3+1)+btn_W*(index%3), CGRectGetMaxY(self.hotTitleLable.frame)+12*((index/3)+1)+40*(index/3), btn_W, 40);
    btn.tag = index;
    [btn addTarget:self action:@selector(selectHotCity:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    index ++;
  }
}

- (void)setCurItem:(XYAddressItem *)curItem {
  _curItem = curItem;
  if (curItem.name.isNotBlank) {
    [self.curBtn setTitle:curItem.name forState:UIControlStateNormal];
  }
}

- (void)selectHotCity:(UIButton *)sender {
  XYAddressItem *item = self.hotCitys[sender.tag];
  XYFormattedArea *area = [[XYFormattedArea alloc] init];
  area.latitude = item.latitude.floatValue;
  area.longitude = item.longitude.floatValue;
  area.provinceCode = item.parentId;
  area.provinceName = [[XYAddressService sharedService] queryAreaNameWithAdcode:item.parentId];
  area.cityCode = item.code;
  area.cityName = item.name;
  area.code = @"";
  area.districtName = @"";
  area.townCode = @"";
  area.townName = @"";
  area.formattedAddress = @"";
  
  [[XYLocationService sharedService] changeLocationWithArea:area];
  
  if (self.selectedBlock) {
    self.selectedBlock(self.hotCitys[sender.tag]);
  }
}

- (void)selectCurrentCity {
  XYFormattedArea *area = [[XYFormattedArea alloc] init];
  area.latitude = self.curItem.latitude.floatValue;
  area.longitude = self.curItem.longitude.floatValue;
  area.provinceCode = self.curItem.parentId;
  area.provinceName = [[XYAddressService sharedService] queryAreaNameWithAdcode:self.curItem.parentId];
  area.cityCode = self.curItem.code;
  area.cityName = self.curItem.name;
  area.code = @"";
  area.districtName = @"";
  area.townCode = @"";
  area.townName = @"";
  area.formattedAddress = @"";
  
  [[XYLocationService sharedService] changeLocationWithArea:area];
  
  if (self.selectedBlock) {
    self.selectedBlock(self.curItem);
  }
}

- (void)setupSubViews {
    [self.contentView addSubview:self.curTitleLable];
    [self.contentView addSubview:self.hotTitleLable];
    [self.contentView addSubview:self.curBtn];
    
  self.curTitleLable.frame = CGRectMake(16, 12, kScreenWidth-32, 18);
  self.curBtn.frame = CGRectMake(16, CGRectGetMaxY(self.curTitleLable.frame)+9, 110, 40);
  self.hotTitleLable.frame = CGRectMake(16, CGRectGetMaxY(self.curBtn.frame)+20, kScreenWidth-32, 18);
  [self.curBtn horizontalCenterImageAndTitle:4];
  
}

#pragma mark - getter

- (UILabel *)curTitleLable {
    if (!_curTitleLable) {
        _curTitleLable = [[UILabel alloc] init];
        _curTitleLable.textColor = ColorHex(XYTextColor_999999);
        _curTitleLable.font = AdaptedFont(XYFont_C);
      _curTitleLable.text = @"当前城市";
    }
    return _curTitleLable;
}

- (UILabel *)hotTitleLable {
    if (!_hotTitleLable) {
        _hotTitleLable = [[UILabel alloc] init];
        _hotTitleLable.textColor = ColorHex(XYTextColor_999999);
        _hotTitleLable.font = AdaptedFont(XYFont_C);
      _hotTitleLable.text = @"热门城市";
    }
    return _hotTitleLable;
}

- (UIButton *)curBtn {
    if (!_curBtn) {
      _curBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [_curBtn setTitle:@"定位中..." forState:UIControlStateNormal];
      [_curBtn setTitleColor:ColorHex(XYTextColor_666666) forState:UIControlStateNormal];
      [_curBtn setImage:[UIImage imageNamed:@"system_map2"] forState:UIControlStateNormal];
      _curBtn.titleLabel.font = AdaptedFont(16);
      [_curBtn setBackgroundColor:ColorHex(XYThemeColor_B)];
      _curBtn.layer.cornerRadius = 4;
      [_curBtn addTarget:self action:@selector(selectCurrentCity) forControlEvents:UIControlEventTouchUpInside];
    }
    return _curBtn;
}
@end


@interface XYCitySelector () <UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIView * topView;

@property (nonatomic,strong) XYCitySelectorTextField *searchBar;

@property (nonatomic,strong) UIButton *cancleBtn;

@property (nonatomic,strong) UITableView *listView;

@property (nonatomic,copy) NSArray <NSArray <XYAddressItem *> *> *cityData;

@property (nonatomic,copy) NSArray <XYAddressItem *> *searchData;

@property (nonatomic,strong) XYAddressItem *curCityModel;

@property (nonatomic,copy) NSArray <NSString *> * indexTitles;

@property (nonatomic, assign, getter=isEditing) BOOL editing;

@end

@implementation XYCitySelector

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  [self setupNavBar];
  
  [self layoutPageSubviews];
  
  [self fetchData];
  
  [self fetchLocation];
}

- (void)layoutPageSubviews {
  [self.view addSubview:self.topView];
  [self.topView addSubview:self.cancleBtn];
  [self.topView addSubview:self.searchBar];
  [self.view addSubview:self.listView];
  self.topView.frame = CGRectMake(0, NAVBAR_HEIGHT, kScreenWidth, 44);
  self.cancleBtn.frame = CGRectMake(kScreenWidth - 55, 7, 40, 30);
  self.searchBar.frame = CGRectMake(16, 7, kScreenWidth-32, 30);
  self.listView.frame = CGRectMake(0, NAVBAR_HEIGHT+44, kScreenWidth, self.view.XY_height - NAVBAR_HEIGHT - 44);
}

- (void)cancle {
  [[IQKeyboardManager sharedManager] resignFirstResponder];
}

#pragma mark - UI
- (void)setupNavBar {
  self.gk_navTitle = @"切换城市";
  self.gk_navLineHidden = YES;
  self.gk_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)fetchData {
  XYShowLoading;
  [[XYAddressService sharedService] queryCityWithBlock:^(NSArray *data, NSArray<NSString *> *indexTitles) {
    XYHiddenLoading;
    self.cityData = data;
    self.indexTitles = indexTitles;
    [self.listView reloadData];
  }];
}

- (void)fetchLocation {
  [[XYLocationService sharedService] requestLocationWithBlock:^(XYFormattedArea *model) {
    XYAddressItem *item = [[XYAddressItem alloc] init];
    item.code = model.cityCode;
    item.name = model.cityName;
    item.parentId = model.provinceCode;
    item.level = @"2";
    item.isSelected = NO;
    self.curCityModel = item;
    if (!self.editing) {
      XYCitySelectorHeader *selector = (XYCitySelectorHeader *)[self.listView headerViewForSection:0];
      selector.curItem = item;
    }
  }];
}

- (void)searchDataWithWords:(NSString *)words {
  [GCDThrottle throttle:0.5 queue:THROTTLE_GLOBAL_QUEUE block:^{
    if (words.isNotBlank) {
      self.searchData = [[XYAddressService sharedService] queryCityWithWords:words];
    } else {
      self.searchData = nil;
    }
    dispatch_async_on_main_queue(^{
      [self.listView reloadData];
    });
  }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.isEditing ? 1 : self.cityData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.isEditing) {
    return self.searchData.count;
  } else {
    if (section == 0) {
      return 0;
    } else {
      return self.cityData[section].count;
    }
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 48;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (self.isEditing) {
    return 0;
  } else {
    if (section == 0) {
      return 149 + (self.cityData[0].count - 1) / 3 * 52 + 24;
    } else {
      return 35;
    }
  }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (self.isEditing) {
    return nil;
  } else {
    if (section == 0) {
      @weakify(self);
      XYCitySelectorHeader *selector = [[XYCitySelectorHeader alloc] init];
      selector.hotCitys = self.cityData.firstObject;
      selector.curItem = self.curCityModel;
      selector.selectedBlock = ^(XYAddressItem *item) {
        if (weak_self.selectedBlock) weak_self.selectedBlock(item);
        [weak_self.navigationController popViewControllerAnimated:YES];
      };
      return selector;
    } else {
      UIView *bgView = [[UIView alloc] init];
      bgView.backgroundColor = ColorHex(XYThemeColor_F);
      UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth-24, 35)];
      lable.textColor = ColorHex(XYTextColor_999999);
      lable.font = AdaptedFont(13);
      lable.text = self.cityData[section].firstObject.firstLetter;
      [bgView addSubview:lable];
      return bgView;
    }
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 && !self.isEditing) {
    return nil;
  } else {
    static NSString *reuseID = @"kCitySelectorCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    cell.textLabel.text = self.isEditing ? self.searchData[indexPath.row].name :  self.cityData[indexPath.section][indexPath.row].name;
    cell.textLabel.font = AdaptedFont(17);
    cell.textLabel.textColor = ColorHex(XYTextColor_333333);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)];
    [cell addGestureRecognizer:tap];
    return cell;
  }
}

- (void)tapCell:(UIGestureRecognizer *)ges {
  NSIndexPath *indexPath = [self.listView indexPathForCell:(UITableViewCell *)ges.view];
  XYAddressItem *item;
  if (indexPath.section == 0) {
    item = self.searchData[indexPath.row];
  } else {
    item = self.cityData[indexPath.section][indexPath.row];
  }
  if (self.selectedBlock) self.selectedBlock(item);
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //设置separatorInset(iOS7之后)
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
    }
    //设置layoutMargins(iOS8之后)
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 12, 0, 12)];
    }
}

/**返回右侧索引所包含的内容*/
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  if (self.isEditing) {
    return nil;
  } else {
    NSMutableArray *sections = [self.indexTitles mutableCopy];
    [sections insertObject:UITableViewIndexSearch  atIndex:0];
    [sections insertObject:@"热" atIndex:1];
    return sections;
  }
}

//点击右侧索引后跳转到的section
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  if (self.isEditing) {
    return 0;
  } else {
    return (index == 0 || index == 1) ? 0 : index - 2;
  }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  self.editing = YES;
  self.cancleBtn.hidden = NO;
  self.searchBar.frame = CGRectMake(16, 7, CGRectGetMinX(self.cancleBtn.frame)-21, 30);
  [self.listView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  textField.text = @"";
  self.searchData = nil;
  self.editing = NO;
  self.cancleBtn.hidden = YES;
  self.searchBar.frame = CGRectMake(16, 7, kScreenWidth-32, 30);
  [self.listView reloadData];
}

- (void)textFieldDidChangeText:(UITextField *)textField {
  [self searchDataWithWords:textField.text];
}


#pragma mark - getter
- (XYCitySelectorTextField *)searchBar {
    if (!_searchBar) {
      _searchBar = [[XYCitySelectorTextField alloc] init];
      UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_14_search"]];
      _searchBar.leftView = imageView;
      _searchBar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索城市名" attributes:@{NSFontAttributeName:AdaptedFont(14),NSForegroundColorAttributeName:ColorHex(XYTextColor_999999)}];
      _searchBar.leftViewMode = UITextFieldViewModeAlways;
      _searchBar.delegate = self;
      _searchBar.backgroundColor = ColorHex(XYThemeColor_F);
      _searchBar.layer.cornerRadius = 15;
      [_searchBar addTarget:self action:@selector(textFieldDidChangeText:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchBar;
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.separatorColor = ColorHex(XYThemeColor_E);
        _listView.dataSource = self;
        _listView.delegate = self;
      [_listView setSectionIndexColor:ColorHex(XYTextColor_999999)];
    }
    return _listView;
}

- (UIView *)topView {
    if (!_topView) {
      _topView = [[UIView alloc] init];
      _topView.backgroundColor = ColorHex(XYThemeColor_B);
    }
    return _topView;
}

- (UIButton *)cancleBtn {
    if (!_cancleBtn) {
      _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
      [_cancleBtn setTitleColor:ColorHex(XYTextColor_FE2D63) forState:UIControlStateNormal];
      _cancleBtn.titleLabel.font = AdaptedFont(15);
      [_cancleBtn addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}
@end
