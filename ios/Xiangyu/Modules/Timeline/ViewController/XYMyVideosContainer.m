//
//  XYMyVideosContainer.m
//  Xiangyu
//
//  Created by dimon on 01/02/2021.
//

#import "XYMyVideosContainer.h"
#import "XYScrollContentView.h"
#import "XYTimelineVideoController.h"
#import "XYLocalVideoController.h"

@interface XYMyVideosContainer ()<XYPageContentViewDelegate,XYSegmentTitleViewDelegate>

@property (nonatomic, strong) UIView * titleViewBgView;

@property (nonatomic, strong) XYSegmentTitleView *titleView;

@property (nonatomic, strong) XYPageContentView *pageContentView;

@end

@implementation XYMyVideosContainer

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupNavBar];
  
  [self setupSubviews];
  
}

#pragma mark - XYPageContentViewDelegate
- (void)XYSegmentTitleView:(XYSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)XYContenViewDidEndDecelerating:(XYPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}
#pragma - UI
- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
  self.gk_navTitle = @"我的短视频";
}

- (void)setupSubviews {
  self.view.backgroundColor = [UIColor whiteColor];
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
    _titleView = [[XYSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, 120, 44) titles:@[@"作品",@"草稿"] delegate:self indicatorType:XYIndicatorTypeEqualTitle];
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
    XYTimelineVideoController *worksVc = [[XYTimelineVideoController alloc] init];
    worksVc.blendedMode = NO;
    worksVc.userId = [[XYUserService service]fetchLoginUser].userId;
    
    XYLocalVideoController *localVc = [[XYLocalVideoController alloc] init];
    
    _pageContentView = [[XYPageContentView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT+44, kScreenWidth, kScreenHeight-NAVBAR_HEIGHT-44) childVCs:@[worksVc, localVc] parentVC:self delegate:self];
    _pageContentView.contentViewCurrentIndex = 0;
  }
  return _pageContentView;
}
@end
