//
//  XYHomeSelectedCityViewController.m
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
#import "XYHomeSelectedCityViewController.h"
#import "XYHomeDoubleTableView.h"
#import "XYLocationService.h"
#import "XYSearchCityView.h"
#import "GCDThrottle.h"
@interface XYHomeSelectedCityViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UIButton *cancelBtn;

@property(nonatomic,strong)XYHomeDoubleTableView* mainView;
@property(nonatomic,strong)XYSearchCityView *searchView;

@end

@implementation XYHomeSelectedCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self fetchLocation];
  [self reshData];
}
#pragma mark - 网络请求
-(void)reshData{
  XYShowLoading;
  [[XYAddressService sharedService] queryCityWithBlock:^(NSArray *data, NSArray<NSString *> *indexTitles) {
    XYHiddenLoading;
    if (data.count) {
      self.mainView.hotCityData = [data firstObject];
      self.mainView.cityData = [data firstObject];
    }
   
    //self.indexTitles = indexTitles;
    //[self.listView reloadData];
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
    self.mainView.cutCity = item;
  }];
}
#pragma mark - 界面布局
-(void)newView{
  [self.view addSubview:self.mainView];
  [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.view);
    make.top.equalTo(self.view).offset(NAVBAR_HEIGHT);
    make.bottom.equalTo(self.view).offset(-SafeAreaBottom());
  }];
  
  [self.view addSubview:self.searchView];
  [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.mainView);
  }];
  
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  self.searchView.hidden = NO;
 // self.editing = YES;
  //self.cancleBtn.hidden = NO;
 // self.searchBar.frame = CGRectMake(16, 7, CGRectGetMinX(self.cancleBtn.frame)-21, 30);
  //[self.listView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  textField.text = @"";
  self.searchView.hidden = YES;
 // self.searchData = nil;
  //self.editing = NO;
 // self.cancleBtn.hidden = YES;
 // self.searchBar.frame = CGRectMake(16, 7, kScreenWidth-32, 30);
 // [self.listView reloadData];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  [self searchDataWithWords:textField.text];
  return YES;
}
- (void)textFieldDidChangeText:(UITextField *)textField {
  [self searchDataWithWords:textField.text];
}
- (void)searchDataWithWords:(NSString *)words {
  [GCDThrottle throttle:0.5 queue:THROTTLE_GLOBAL_QUEUE block:^{
    if (words.isNotBlank) {
      self.searchView.searchData = [[XYAddressService sharedService] queryCityWithWords:words];
    } else {
      self.searchView.searchData = @[];
    }
   
  }];
}
#pragma mark - 导航
-(void)newNav{
  self.gk_navLeftBarButtonItem = nil;
  self.gk_navTitleView = self.searchBar;
  self.gk_navLineHidden = YES;
  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.cancelBtn];
  
}
- (UITextField *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(16, NAVBAR_HEIGHT - 30 - 7, kScreenWidth - 84, 30)];
        _searchBar.placeholder = @"搜索城市名称";
        _searchBar.layer.cornerRadius = 15.f;
        _searchBar.font = [UIFont systemFontOfSize:14];
        _searchBar.leftView = [self leftView];
        _searchBar.leftViewMode = UITextFieldViewModeAlways;
      _searchBar.backgroundColor = ColorHex(XYThemeColor_F);
        _searchBar.delegate = self;
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
      [_searchBar addTarget:self action:@selector(textFieldDidChangeText:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchBar;
}

- (UIView *)leftView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_14_search"]];
    imgView.frame = CGRectMake(12, 8, 14, 14);
    [view addSubview:imgView];
    return view;
}

-(XYHomeDoubleTableView *)mainView{
  if (!_mainView) {
    _mainView = [[XYHomeDoubleTableView alloc]initWithFrame:CGRectZero];
    @weakify(self);
    _mainView.selectedBlock = ^(XYAddressItem * _Nonnull item) {
      @strongify(self);
      if (self.selectedBlock) self.selectedBlock(item);
      [self.navigationController popViewControllerAnimated:YES];
    };
  }
  return _mainView;
}
-(XYSearchCityView *)searchView{
  if (!_searchView) {
    _searchView =[[XYSearchCityView alloc]initWithFrame:CGRectZero];
    @weakify(self);
    _searchView.selectedBlock = ^(XYAddressItem * _Nonnull item) {
      @strongify(self);
      if (self.selectedBlock) self.selectedBlock(item);
      [self.navigationController popViewControllerAnimated:YES];
    };
    _searchView.hidden = YES;
  }
  return _searchView;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(kScreenWidth - 48, NAVBAR_HEIGHT - 20 - 12, 36, 20);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:ColorHex(XYTextColor_FF5672) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
-(void)cancelBtnClicked:(id)sender{
  [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
