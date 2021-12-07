//
//  XYDynamicsListController.m
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "XYDynamicsListController.h"
#import "XYDynamicsCell.h"
#import "XYDynamicsDetailController.h"
#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "XYTimelineProfileController.h"
#import "SDCycleScrollView.h"
#import "WebViewController.h"
#import "TUIConversationCellData.h"
#import "ChatViewController.h"
#import "WebViewController.h"

#import "XYTopicDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"
@interface XYDynamicsListController ()<UITableViewDelegate, UITableViewDataSource, XYDynamicsCellDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@property (nonatomic, strong) NSArray * friendsData;



@property (nonatomic, strong) UIView * bannerView;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property(nonatomic,assign)BOOL pubScroll;
@end

@implementation XYDynamicsListController
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupSubviews];
  
  [self fetchNewData];
  
  [self fetchBannerData];
}

- (void)fetchBannerData {
  if (self.viewType == XYDynamicsViewType_Recommend) {
    [self.dataManager fetchBannerDataWithBlock:^(NSArray *imageUrls) {
      if (imageUrls && imageUrls.count > 0) {
        self.listView.tableHeaderView = self.bannerView;
        self.cycleScrollView.imageURLStringsGroup = imageUrls;
      }
    }];
  }
}

- (void)fetchNewData {
  if (!self.blendedMode) XYShowLoading;
  [self.dataManager fetchNewDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
    if (!self.blendedMode) XYHiddenLoading;
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

- (void)setupSubviews {
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.listView];
  [self.listView makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
  }];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  XYDynamicLayout * layout = self.dataManager.layoutsArr[indexPath.row];
  return layout.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  if (self.dataManager.layoutsArr.count) {
//    self.vcCanScroll = self.pubScroll;
//  }
    return self.dataManager.layoutsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  XYDynamicsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"dynamicsTableViewCell"];
  cell.layout = self.dataManager.layoutsArr[indexPath.row];
  cell.delegate = self;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.dataManager.layoutsArr[indexPath.row].model.isExt.integerValue == 1) {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.urlStr = self.dataManager.layoutsArr[indexPath.row].model.extUrl;
    [self cyl_pushViewController:vc animated:YES];
  } else {
    XYDynamicsDetailController *vc = [[XYDynamicsDetailController alloc] init];
    vc.dynamicsModel = self.dataManager.layoutsArr[indexPath.row].model;
    [self cyl_pushViewController:vc animated:YES];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (self.blendedMode) {
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        _vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];
    }
    self.listView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
  }
}


#pragma mark - NewDynamiceCellDelegate
//点击头像
- (void)DynamicsCell:(XYDynamicsCell *)cell didClickUser:(NSString *)userId {
  if (cell.layout.model.isExt.integerValue == 1) {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.urlStr = cell.layout.model.extUrl;
    [self cyl_pushViewController:vc animated:YES];
  } else {
    if (self.viewType == XYDynamicsViewType_Mine) {
      XYDynamicsDetailController *vc = [[XYDynamicsDetailController alloc] init];
      vc.dynamicsModel = cell.layout.model;
      [self cyl_pushViewController:vc animated:YES];
    } else {
      XYTimelineProfileController *profile = [[XYTimelineProfileController alloc] init];
      profile.userId = cell.layout.model.userId;
      [self cyl_pushViewController:profile animated:YES];
    }
  }
}

//点击文本
- (void)DidClickTextInDynamicsCell:(XYDynamicsCell *)cell {
  if (cell.layout.model.isExt.integerValue == 1) {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.urlStr = cell.layout.model.extUrl;
    [self cyl_pushViewController:vc animated:YES];
  } else {
    XYDynamicsDetailController *vc = [[XYDynamicsDetailController alloc] init];
    vc.dynamicsModel = cell.layout.model;
    [self cyl_pushViewController:vc animated:YES];
  }
}

//点击收起、全文
- (void)DidClickMoreLessInDynamicsCell:(XYDynamicsCell *)cell {
  if (cell.layout.model.isExt.integerValue == 1) {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.urlStr = cell.layout.model.extUrl;
    [self cyl_pushViewController:vc animated:YES];
  } else {
    XYDynamicsDetailController *vc = [[XYDynamicsDetailController alloc] init];
    vc.dynamicsModel = cell.layout.model;
    [self cyl_pushViewController:vc animated:YES];
  }
}

- (void)DidClickImageOrVideoInDynamicsCell:(XYDynamicsCell *)cell {
  if (cell.layout.model.isExt.integerValue == 1) {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.urlStr = cell.layout.model.extUrl;
    [self cyl_pushViewController:vc animated:YES];
  } else {
    XYDynamicsDetailController *vc = [[XYDynamicsDetailController alloc] init];
    vc.dynamicsModel = cell.layout.model;
    [self cyl_pushViewController:vc animated:YES];
  }
}
//点赞
- (void)DidClickThunmbInDynamicsCell:(XYDynamicsCell *)cell {
  NSIndexPath *indexPath = [self.listView indexPathForCell:cell];
  [self.dataManager thunmbDynamicsWithIndex:indexPath.row block:^(XYDynamicLayout *layout, XYError *error) {
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
//取消点赞
-(void)DidClickCancelThunmbInDynamicsCell:(XYDynamicsCell *)cell {
  NSIndexPath *indexPath = [self.listView indexPathForCell:cell];
  [self.dataManager thunmbDynamicsWithIndex:indexPath.row block:^(XYDynamicLayout *layout, XYError *error) {
    if (error) {
      XYToastText(error.msg);
    } else {
      cell.layout = layout;
    }
  }];
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
  if (cell.layout.model.isExt.integerValue == 1) {
    WebViewController *vc = [[WebViewController alloc] init];
    vc.urlStr = cell.layout.model.extUrl;
    [self cyl_pushViewController:vc animated:YES];
  } else {
    XYDynamicsDetailController *vc = [[XYDynamicsDetailController alloc] init];
    vc.dynamicsModel = cell.layout.model;
    [self cyl_pushViewController:vc animated:YES];
  }
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

- (void)DynamicsCell:(XYDynamicsCell *)cell didClickUrl:(NSString *)url PhoneNum:(NSString *)phoneNum {
  
}
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
  return YES;
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
      _listView.emptyDataSetSource = self;
      _listView.emptyDataSetDelegate = self;
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
    }
    return _listView;
}

-(XYDynamicsListDataManager *)dataManager {
    if (!_dataManager) {
      _dataManager = [[XYDynamicsListDataManager alloc] init];
      _dataManager.dataType = self.viewType;
      _dataManager.hisUserId = self.hisUserId;
    }
    return _dataManager;
}

- (UIView *)bannerView {
  if (!_bannerView) {
    _bannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 16+(kScreenWidth-32)*(100.00/343.00))];
    _bannerView.backgroundColor = ColorHex(XYThemeColor_F);
    [_bannerView addSubview:self.cycleScrollView];
  }
  return _bannerView;
}

- (SDCycleScrollView *)cycleScrollView {
  if (!_cycleScrollView) {
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(16, 8, kScreenWidth-32, (kScreenWidth-32)*(100.00/343.00)) delegate:nil placeholderImage:nil];
    _cycleScrollView.showPageControl = NO;
    @weakify(self);
    _cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
      NSNumber *skipType = weak_self.dataManager.bannerData[currentIndex][@"skipType"];
      if (![skipType toSafeValueOfClass:[NSNumber class]]) return;
      
      NSString *buParam = weak_self.dataManager.bannerData[currentIndex][@"jumpLink"];
      if (skipType.integerValue == 1) {
        WebViewController *web = [[WebViewController alloc] init];
        web.urlStr = buParam;
        [weak_self cyl_pushViewController:web animated:YES];
      } else if (skipType.integerValue == 2) {
        TUIConversationCellData *conversationData = [[TUIConversationCellData alloc] init];
        conversationData.groupID = buParam;
        ChatViewController *chat = [[ChatViewController alloc] init];
        chat.conversationData = conversationData;
        [weak_self cyl_pushViewController:chat animated:YES];
      }
    };
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    _cycleScrollView.layer.cornerRadius = 10;
    _cycleScrollView.layer.masksToBounds = YES;
  }
  return _cycleScrollView;
}

-(void)setVcCanScroll:(BOOL)vcCanScroll{
  _vcCanScroll= vcCanScroll;
  
  self.pubScroll = vcCanScroll;
}
-(void)reshScreollEnabel{
  
//  if (_listView && self.dataManager.layoutsArr.count<1 ) {
//    _vcCanScroll = NO;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];
//    
//    self.listView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
//  }
//  
//  if (!_vcCanScroll) {
//    self.listView.contentOffset = CGPointZero;
//  }
}

@end
