//
//  XYLinkageRecycleViewController.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/19.
//

#import "XYLinkageRecycleViewController.h"
#import "XYPlatformService.h"
#import "XYLinkageRecycleView.h"

@interface XYLinkageRecycleViewController ()

@property (nonatomic, strong) XYLinkageRecycleView * linkageRecycleView;

@property (nonatomic,strong) NSArray <XYIndustryModel *> *dataSource;

@property (nonatomic, strong) NSNumber * selectedLeftIndex;

@property (nonatomic, strong) NSNumber * selectedRightIndex;

@end

@implementation XYLinkageRecycleViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupNavBar];
  self.view.backgroundColor = ColorHex(XYThemeColor_B);
  [self.view addSubview:self.linkageRecycleView];
  self.linkageRecycleView.frame = CGRectMake(0, NAVBAR_HEIGHT, self.view.XY_width, self.view.XY_height-NAVBAR_HEIGHT);
  
  [self fetchData];
}

- (void)sure {
  XYIndustryModel *firstModel = self.dataSource[self.selectedLeftIndex.integerValue];
  XYIndustryModel *secondModel = firstModel.list[self.selectedRightIndex.integerValue];
  if (self.selectedBlock) {
    self.selectedBlock(secondModel.name, firstModel.code, secondModel.code);
  }
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)fetchData {
  XYShowLoading;
  [[XYPlatformService shareService] fetchIndustryDataWithBlock:^(NSArray<XYIndustryModel *> *data, XYError *error) {
    XYHiddenLoading;
    if (error) {
      XYToastText(error.msg);
      return;
    }
    self.gk_navRightBarButtonItem.enabled = NO;
    self.dataSource = data;
    self.linkageRecycleView.dataSource = data;
  }];
}

- (void)setupNavBar {
  self.gk_navTitle = @"选择行业";
  self.gk_navItemRightSpace = 16;
  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sure)];
  self.gk_navLineHidden = YES;
  self.gk_statusBarStyle = UIStatusBarStyleDefault;
  self.gk_navTintColor = ColorHex(XYThemeColor_A);
}

- (XYLinkageRecycleView *)linkageRecycleView {
    if (!_linkageRecycleView) {
      @weakify(self);
      _linkageRecycleView = [[XYLinkageRecycleView alloc] init];
      _linkageRecycleView.selectedLeftIndex = self.selectedLeftIndex;
      _linkageRecycleView.selectedRightIndex = self.selectedRightIndex;
      _linkageRecycleView.selectedBlock = ^(NSNumber *selectedLeftIndex, NSNumber *selectedRightIndex) {
        weak_self.selectedLeftIndex = selectedLeftIndex;
        weak_self.selectedRightIndex = selectedRightIndex;
        weak_self.gk_navRightBarButtonItem.enabled = YES;
      };
    }
    return _linkageRecycleView;
}
@end
