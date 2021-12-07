//
//  XYSearchVideoContainer.m
//  Xiangyu
//
//  Created by dimon on 17/03/2021.
//

#import "XYSearchVideoContainer.h"
#import "XYScrollContentView.h"
#import "XYSubSearchVideoController.h"
#import "XYSubSearchFriendController.h"

@interface XYSearchVideoContainer ()<UITextFieldDelegate, XYPageContentViewDelegate, XYSegmentTitleViewDelegate>

@property (nonatomic, strong) UIView *naviView;

@property (nonatomic, strong) UITextField *searchBar;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIView * titleViewBgView;

@property (nonatomic, strong) XYSegmentTitleView *titleView;

@property (nonatomic, strong) XYPageContentView *pageContentView;

@property (nonatomic, assign) BOOL active;

@property (nonatomic, weak) XYSubSearchFriendController * authorVc;

@property (nonatomic, weak) XYSubSearchVideoController * productVc;

@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation XYSearchVideoContainer

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.selectedIndex = 0;
    self.gk_navigationBar.hidden = YES;
    self.gk_popMaxAllowedDistanceToLeftEdge = 16.0;
    [self setupSubviews];
}

#pragma mark - actions
- (void)cancelBtnClicked:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITextFieldActions
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self fetchData];
  
  return YES;
}

- (void)fetchData {
  [self.searchBar resignFirstResponder];
  if (self.searchBar.text.isNotBlank) {
    if (self.selectedIndex + 1 == 1) {
      [self.productVc fetchNewDataWithKeywords:self.searchBar.text];
    } else {
      [self.authorVc fetchNewDataWithKeywords:self.searchBar.text];
    }
  } else {
    XYToastText(@"请输入作品名称、作者名称");
  }
}
#pragma - UI
#pragma mark - XYPageContentViewDelegate
- (void)XYSegmentTitleView:(XYSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.pageContentView.contentViewCurrentIndex = endIndex;
    self.selectedIndex = endIndex;
    [self fetchData];
}

- (void)XYContenViewDidEndDecelerating:(XYPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
    self.selectedIndex = endIndex;
    [self fetchData];
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
    _titleView = [[XYSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, 120, 44) titles:@[@"作品",@"作者"] delegate:self indicatorType:XYIndicatorTypeEqualTitle];
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
    XYSubSearchVideoController *productVc = [[XYSubSearchVideoController alloc] init];
    productVc.needRefresh = YES;
    self.productVc = productVc;
    
    XYSubSearchFriendController *authorVc = [[XYSubSearchFriendController alloc] init];
    authorVc.needRefresh = YES;
    self.authorVc = authorVc;
    
    _pageContentView = [[XYPageContentView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT+44, kScreenWidth, kScreenHeight-NAVBAR_HEIGHT-44) childVCs:@[productVc, authorVc] parentVC:self delegate:self];
    _pageContentView.contentViewCurrentIndex = 0;
  }
  return _pageContentView;
}

- (UITextField *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(16, NAVBAR_HEIGHT - 30 - 7, kScreenWidth - 84, 30)];
        _searchBar.placeholder = @"搜索作品名称、作者名称";
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
