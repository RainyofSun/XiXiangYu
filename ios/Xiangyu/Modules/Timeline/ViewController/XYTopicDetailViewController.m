//
//  XYTopicDetailViewController.m
//  Xiangyu
//
//  Created by Kang on 2021/7/4.
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
#import "XYTopicDetailViewController.h"
#import "XYTopicDetailTopView.h"
#import "XYDynamicsCell.h"
#import "XYDynamicsDetailController.h"
#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "XYPlatSubjectGetListAPI.h"
#import "XYDynamicsAPI.h"

#import "XYDynamicsListDataManager.h"
#import "XYLocationService.h"
#import "UIBarButtonItem+GKNavigationBar.h"
@interface XYTopicDetailViewController ()<UITableViewDelegate, UITableViewDataSource, XYDynamicsCellDelegate>

@property (nonatomic,strong) UITableView *listView;
@property(nonatomic,strong)XYTopicDetailTopView *topView;
@property (nonatomic, strong) XYDynamicsListDataManager *dataManager;

@property(nonatomic,assign)NSInteger page;
@end

@implementation XYTopicDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupNavBar];
  
  [self setupSubviews];
  
  
    [self fetchNewData];
  
}
-(void)getTopInfo{
  XYShowLoading;
   XYPlatGetSubjectAPI *api = [[XYPlatGetSubjectAPI  alloc]initWithId:self.subId];
  @weakify(self);
   api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
     XYHiddenLoading;
     @strongify(self);
     self.topView.model = [XYTopicModel yy_modelWithJSON:data];
     self.listView.tableHeaderView = self.topView;
   };
   [api start];
}
- (void)fetchNewData {
 
  self.page = 0;
  [self getTopInfo];
  
  [self fetchNextData];
//  [self.dataManager fetchNewDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
//    XYHiddenLoading;
//    if ([self.listView.mj_header isRefreshing]) {
//        [self.listView.mj_header endRefreshing];
//    }
//    if (error) {
//      XYToastText(error.msg);
//    } else {
//      isNeedRefresh ? [self.listView reloadData] : nil;
//    }
//  }];
}

- (void)fetchNextData {
  self.page ++;
  
  
  
  [[XYLocationService sharedService] requestCachedLocationWithBlock:^(XYFormattedArea *model) {
   

  XYRecommendDynamicsAPI *api = [[XYRecommendDynamicsAPI alloc] initWithType:1 provice:model.provinceCode city:model.cityCode page:self.page subjectId:self.subId];
  @weakify(self);
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    
    @strongify(self);
    [self.listView.mj_header endRefreshing];
    [self.listView.mj_footer endRefreshing];
    if (self.page ==1) {
      [self.dataManager.layoutsArr removeAllObjects];
    }
   
  
    
    NSArray *arr = nil;
    if ([data isKindOfClass:[NSArray class]]) {
      arr = data;
    }
    if ([data isKindOfClass:[NSDictionary class]]) {
      arr = data[@"dynamics"];
    }
    
    if (arr.count > 0) {
      NSArray <XYDynamicsModel *> *dynamics = [NSArray yy_modelArrayWithClass:[XYDynamicsModel class] json:arr];
      for (XYDynamicsModel * model in dynamics) {
        XYDynamicLayout * layout = [[XYDynamicLayout alloc] initWithModel:model];
        [self.dataManager.layoutsArr addObject:layout];
      }
    } 
    [self.listView reloadData];
  };
  [api start];
  
  }];
  
//  [self.dataManager fetchNextPageDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
//    if ([self.listView.mj_footer isRefreshing]) {
//        [self.listView.mj_footer endRefreshing];
//    }
//    if (error) {
//      XYToastText(error.msg);
//    } else {
//      isNeedRefresh ? [self.listView reloadData] : nil;
//    }
//  }];
}

- (void)setupNavBar {
//  if (self.isLocalData) {
  //  self.gk_navigationBar.hidden = YES;
//  } else {
//    self.gk_navLineHidden = YES;
//    self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
//    self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
//    self.gk_navigationBar.layer.shadowOpacity = 0.06;
//    self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
//    self.gk_navTitle = @"我的动态";
//  }
  self.gk_navTintColor = [UIColor whiteColor];
  self.gk_navBarAlpha = 0;
  self.gk_navLineHidden = YES;
  self.gk_statusBarStyle = UIStatusBarStyleLightContent;
  //icon_arrow_white_22
  //icon_arrow_back_22
  self.gk_navLeftBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"icon_arrow_white_22"] target:self action:@selector(popVCEvent:)];
}
-(void)popVCEvent:(id)sender{
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupSubviews {
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.listView];
  [self.listView makeConstraints:^(MASConstraintMaker *make) {
    make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
  }];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  XYDynamicLayout * layout = self.dataManager.layoutsArr[indexPath.row];
  return layout.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.layoutsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XYDynamicsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicsTableViewCell"];
  cell.layout = self.dataManager.layoutsArr[indexPath.row];
  cell.delegate = self;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  XYDynamicsDetailController *vc = [[XYDynamicsDetailController alloc] init];
  vc.dynamicsModel = self.dataManager.layoutsArr[indexPath.row].model;
  [self cyl_pushViewController:vc animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  [self scrollWithOffset:scrollView.contentOffset.y];
  
}

- (void)scrollWithOffset:(CGFloat)offsetY {
  
  if (offsetY >= (148-StatusBarHeight())) {
    self.gk_navLeftBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"icon_arrow_back_22"] target:self action:@selector(popVCEvent:)];
    self.gk_navBarAlpha = 1;
    self.gk_navTitle = @"详情";
  } else {
    self.gk_navLeftBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"icon_arrow_white_22"] target:self action:@selector(popVCEvent:)];
    self.gk_navBarAlpha = 0;
    self.gk_navTitle = @"";
  }

 
}

#pragma mark - NewDynamiceCellDelegate
//点击头像
- (void)DynamicsCell:(XYDynamicsCell *)cell didClickUser:(NSString *)userId {
  XYDynamicsDetailController *vc = [[XYDynamicsDetailController alloc] init];
  vc.dynamicsModel = cell.layout.model;
  [self cyl_pushViewController:vc animated:YES];
}

- (void)DidClickImageOrVideoInDynamicsCell:(XYDynamicsCell *)cell {
  XYDynamicsDetailController *vc = [[XYDynamicsDetailController alloc] init];
  vc.dynamicsModel = cell.layout.model;
  [self cyl_pushViewController:vc animated:YES];
}

//点击文本
- (void)DidClickTextInDynamicsCell:(XYDynamicsCell *)cell {
  XYDynamicsDetailController *vc = [[XYDynamicsDetailController alloc] init];
  vc.dynamicsModel = cell.layout.model;
  [self cyl_pushViewController:vc animated:YES];
}

//点击收起、全文
- (void)DidClickMoreLessInDynamicsCell:(XYDynamicsCell *)cell {
  XYDynamicsDetailController *vc = [[XYDynamicsDetailController alloc] init];
  vc.dynamicsModel = cell.layout.model;
  [self cyl_pushViewController:vc animated:YES];
}

//关注
- (void)DidClickAttentionInDynamicsCell:(XYDynamicsCell *)cell {
  NSIndexPath *indexPath = [self.listView indexPathForCell:cell];
  [self.dataManager followUserWithIndex:indexPath.row block:^(XYDynamicLayout *layout, XYError *error) {
    if (error) {
      XYToastText(error.msg);
    } else {
      cell.layout = layout;
    }
  }];
}

//取消关注
- (void)DidClickCancelAttentionInDynamicsCell:(XYDynamicsCell *)cell {
  NSIndexPath *indexPath = [self.listView indexPathForCell:cell];
  [self.dataManager followUserWithIndex:indexPath.row block:^(XYDynamicLayout *layout, XYError *error) {
    if (error) {
      XYToastText(error.msg);
    } else {
      cell.layout = layout;
    }
  }];
}

//点击评论
- (void)DidClickCommentInDynamicsCell:(XYDynamicsCell *)cell {
  XYDynamicsDetailController *vc = [[XYDynamicsDetailController alloc] init];
  vc.dynamicsModel = cell.layout.model;
  [self cyl_pushViewController:vc animated:YES];
}

- (void)DynamicsCell:(XYDynamicsCell *)cell didClickUrl:(NSString *)url PhoneNum:(NSString *)phoneNum {
  
}

- (void)DidClickDeleteInDynamicsCell:(XYDynamicsCell *)cell {
  NSIndexPath *indexPath = [self.listView indexPathForCell:cell];
  XYShowLoading;
  @weakify(self);
  [self.dataManager deleteDynamicWithIndex:indexPath.row block:^(XYError *error) {
    XYHiddenLoading;
    if (error) {
      XYToastText(error.msg);
    } else {
      [weak_self.listView beginUpdates];
      [weak_self.listView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
      [weak_self.listView endUpdates];
    }
  }];
}
-(XYTopicDetailTopView *)topView{
  if (!_topView) {
    _topView = [[XYTopicDetailTopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize(300))];
  }
  return _topView;
}
- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _listView.dataSource = self;
        _listView.delegate = self;
      [_listView registerClass:[XYDynamicsCell class] forCellReuseIdentifier:@"dynamicsTableViewCell"];
      UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
      _listView.tableFooterView = footer;
     
        @weakify(self);
        _listView.mj_header = [XYRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self);
          [self fetchNewData];
        }];
        _listView.mj_footer = [XYRefreshFooter footerWithRefreshingBlock:^{
          @strongify(self);
          [self fetchNextData];
        }];
      
      if (@available(iOS 11.0, *)) {
        _listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      } else {
      self.automaticallyAdjustsScrollViewInsets = NO;
      }
    }
    return _listView;
}

-(XYDynamicsListDataManager *)dataManager {
    if (!_dataManager) {
      _dataManager = [[XYDynamicsListDataManager alloc] init];
//      _dataManager.dataType = self.isLocalData ? XYDynamicsViewType_None : XYDynamicsViewType_Mine;
    }
    return _dataManager;
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
