//
//  XYMyDynamicsListController.m
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "XYMyDynamicsListController.h"
#import "XYDynamicsCell.h"
#import "XYDynamicsDetailController.h"
#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "XYTimelineProfileController.h"
#import "XYTopicDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"
@interface XYMyDynamicsListController ()<UITableViewDelegate, UITableViewDataSource, XYDynamicsCellDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,strong) UITableView *listView;

@end

@implementation XYMyDynamicsListController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupNavBar];
  
  [self setupSubviews];
  
  if (!self.isLocalData) {
    [self fetchNewData];
  }
}

- (void)fetchNewData {
  XYShowLoading;
  [self.dataManager fetchNewDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
    XYHiddenLoading;
    if ([self.listView.mj_header isRefreshing]) {
        [self.listView.mj_header endRefreshing];
    }
    if (error) {
      XYToastText(error.msg);
    } else {
      isNeedRefresh ? [self.listView reloadData] : nil;
    }
  }];
}

- (void)fetchNextData {
  [self.dataManager fetchNextPageDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
    if ([self.listView.mj_footer isRefreshing]) {
        [self.listView.mj_footer endRefreshing];
    }
    if (error) {
      XYToastText(error.msg);
    } else {
      isNeedRefresh ? [self.listView reloadData] : nil;
    }
  }];
}

- (void)setupNavBar {
  if (self.isLocalData) {
    self.gk_navigationBar.hidden = YES;
  } else {
    self.gk_navLineHidden = YES;
    self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
    self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
    self.gk_navigationBar.layer.shadowOpacity = 0.06;
    self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
    self.gk_navTitle = @"我的动态";
  }
}

- (void)setupSubviews {
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.listView];
  [self.listView makeConstraints:^(MASConstraintMaker *make) {
    make.edges.insets(UIEdgeInsetsMake(self.isLocalData ? 0 : NAVBAR_HEIGHT, 0, 0, 0));
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

// 话题
-(void)DidClickTopicInDynamicsCell:(XYDynamicsCell *)cell{
  XYTopicDetailViewController *vc = [[XYTopicDetailViewController alloc] init];
  vc.subId = cell.layout.model.subjectId;
  [self cyl_pushViewController:vc animated:YES];
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

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无数据";

    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: AdaptedFont(14),
                                 NSForegroundColorAttributeName:ColorHex(XYTextColor_666666),
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _listView.dataSource = self;
        _listView.delegate = self;
      _listView.emptyDataSetDelegate=self;
      _listView.emptyDataSetSource=self;
      [_listView registerClass:[XYDynamicsCell class] forCellReuseIdentifier:@"dynamicsTableViewCell"];
      UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
      _listView.tableFooterView = footer;
      if (self.needRefresh) {
        @weakify(self);
        _listView.mj_header = [XYRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self);
          [self fetchNewData];
        }];
        _listView.mj_footer = [XYRefreshFooter footerWithRefreshingBlock:^{
          @strongify(self);
          [self fetchNextData];
        }];
      }
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
      _dataManager.dataType = self.isLocalData ? XYDynamicsViewType_None : XYDynamicsViewType_Mine;
    }
    return _dataManager;
}
@end
