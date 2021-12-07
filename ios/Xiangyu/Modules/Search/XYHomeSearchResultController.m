//
//  XYHomeSearchResultController.m
//  Xiangyu
//
//  Created by dimon on 18/03/2021.
//

#import "XYHomeSearchResultController.h"
#import "XYScrollContentView.h"
#import "XYSubSearchVideoController.h"
#import "XYSubSearchFriendController.h"
#import "XYMyDynamicsListController.h"
#import "XYSubSearchListController.h"

@interface XYHomeSearchResultController ()<UITextFieldDelegate, XYPageContentViewDelegate, XYSegmentTitleViewDelegate>

@property (nonatomic, strong) UIView *naviView;

@property (nonatomic, strong) UITextField *searchBar;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIView * titleViewBgView;

@property (nonatomic, strong) XYSegmentTitleView *titleView;

@property (nonatomic, strong) XYPageContentView *pageContentView;

@property (nonatomic, assign) BOOL active;

@property (nonatomic, weak) XYSubSearchFriendController * authorVc;

@property (nonatomic, weak) XYSubSearchVideoController * productVc;

@property (nonatomic, weak) XYMyDynamicsListController * dynamicVc;

@property (nonatomic, weak) XYSubSearchListController * demandVc;

@property (nonatomic, weak) XYSubSearchListController * activityVc;

@end

@implementation XYHomeSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.gk_navigationBar.hidden = YES;
    self.gk_popMaxAllowedDistanceToLeftEdge = 16.0;
    [self setupSubviews];
}

#pragma mark - actions
- (void)cancelBtnClicked:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldActions
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  [self.navigationController popViewControllerAnimated:YES];
  return NO;
}

#pragma - UI
#pragma mark - XYPageContentViewDelegate
- (void)XYSegmentTitleView:(XYSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)XYContenViewDidEndDecelerating:(XYPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}

#pragma mark - ZQSearchChildViewDelegate
- (void)searchChildViewDidScroll {
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)setupSubviews {
  self.view.backgroundColor = ColorHex(XYThemeColor_F);
  [self.view addSubview:self.naviView];
  [self.naviView addSubview:self.cancelBtn];
  [self.naviView addSubview:self.searchBar];
  [self.view addSubview:self.titleViewBgView];
  [self.titleViewBgView addSubview:self.titleView];
  [self.view addSubview:self.pageContentView];
}

- (UIView *)titleViewBgView {
  if (!_titleViewBgView) {
    _titleViewBgView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, kScreenWidth, 44)];
    _titleViewBgView.backgroundColor = ColorHex(XYThemeColor_B);
  }
  return _titleViewBgView;
}

- (XYSegmentTitleView *)titleView {
  if (!_titleView) {
    _titleView = [[XYSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) titles:@[@"好友",@"短视频",@"圈子",@"需求", @"活动"] delegate:self indicatorType:XYIndicatorTypeEqualTitle];
    _titleView.indicatorColor = ColorHex(XYTextColor_635FF0);
    _titleView.titleFont = AdaptedFont(16);
    _titleView.titleSelectFont = AdaptedMediumFont(20);
    _titleView.titleNormalColor = ColorHex(XYTextColor_999999);
    _titleView.titleSelectColor = ColorHex(XYTextColor_222222);
    _titleView.itemMargin = 14;
    _titleView.selectIndex = 0;
    
  }
  return _titleView;
}


- (XYPageContentView *)pageContentView {
  if (!_pageContentView) {
    XYSubSearchFriendController *friendVc = [[XYSubSearchFriendController alloc] init];
    [friendVc.dataManager.authors addObjectsFromArray:self.searchData.users];
    friendVc.needRefresh = NO;
    self.authorVc = friendVc;
    
    XYSubSearchVideoController *videoVc = [[XYSubSearchVideoController alloc] init];
    videoVc.needRefresh = NO;
    [videoVc.dataManager.videos addObjectsFromArray:self.searchData.shortVideo];
    self.productVc = videoVc;
    
    
    XYMyDynamicsListController *dynamicVc = [[XYMyDynamicsListController alloc] init];
    dynamicVc.needRefresh = NO;
    dynamicVc.localData = YES;
    [dynamicVc.dataManager insertDynamics:self.searchData.dynamic];
    self.dynamicVc = dynamicVc;
    
    XYSubSearchListController *demandVc = [[XYSubSearchListController alloc] init];
    demandVc.demandData = self.searchData.demand;
    demandVc.cellHeight = 138;
    demandVc.cellClassString = @"XYDemandCell";
    self.demandVc = demandVc;
    
    XYSubSearchListController *activityVc = [[XYSubSearchListController alloc] init];
    activityVc.activityData = self.searchData.activity;
    activityVc.cellHeight = 112;
    activityVc.cellClassString = @"XYActivityCell";
    self.activityVc = activityVc;
    
    _pageContentView = [[XYPageContentView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT+44, kScreenWidth, kScreenHeight-NAVBAR_HEIGHT-44) childVCs:@[friendVc, videoVc, dynamicVc, demandVc, activityVc] parentVC:self delegate:self];
    _pageContentView.contentViewCurrentIndex = 0;
  }
  return _pageContentView;
}

- (UITextField *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(16, NAVBAR_HEIGHT - 30 - 7, kScreenWidth - 84, 30)];
        _searchBar.placeholder = @"搜索作品名称、作者名称";
        _searchBar.text = self.keywords;
        _searchBar.layer.cornerRadius = 15.f;
        _searchBar.font = [UIFont systemFontOfSize:14];
        _searchBar.leftView = [self leftView];
        _searchBar.leftViewMode = UITextFieldViewModeAlways;
      _searchBar.backgroundColor = ColorHex(XYThemeColor_F);
        _searchBar.delegate = self;
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.clearButtonMode = UITextFieldViewModeWhileEditing;
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

- (UIView *)naviView {
    if (!_naviView) {
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NAVBAR_HEIGHT)];
        _naviView.backgroundColor = [UIColor whiteColor];
    }
    return _naviView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(kScreenWidth - 48, NAVBAR_HEIGHT - 20 - 12, 36, 20);
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:ColorHex(XYTextColor_635FF0) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

@end
