//
//  XYSubSearchFriendController.m
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "XYSubSearchFriendController.h"
#import "XYFriendListCell.h"
#import "XYRefreshFooter.h"
#import "TUIConversationCellData.h"
#import "FriendRequestViewController.h"
#import "XYTimelineProfileController.h"
#import "XYFirendRequestViewController.h"

#import "ChatViewController.h"
@interface XYSubSearchFriendController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *listView;

@end

@implementation XYSubSearchFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.gk_navigationBar.hidden = YES;
    self.gk_popMaxAllowedDistanceToLeftEdge = 16.0;
  
    [self setupSubviews];
}

- (void)fetchNewDataWithKeywords:(NSString *)keywords {
  self.dataManager.words = keywords;
  @weakify(self);
  [self.dataManager fetchAuthorNewDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
    [weak_self.listView.mj_header endRefreshing];
    if (error) {
      XYToastText(error.msg);
    } else {
      if (self.dataManager.authors.count == 0) {
        XYToastText(@"没有搜索结果");
      }
      [self.listView reloadData];
    }
  }];
}

- (void)fetchNextData {
 @weakify(self);
  [self.dataManager fetchAuthorNextPageDataWithBlock:^(BOOL isNeedRefresh, XYError *error) {
   [weak_self.listView.mj_footer endRefreshing];
   if (error) {
     XYToastText(error.msg);
   } else {
     [self.listView reloadData];
   }
 }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.authors.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reuseID = @"kSearchFriendCell";
  XYFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[XYFriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
  cell.isFriend = YES;
  cell.item = self.dataManager.authors[indexPath.row];
  @weakify(self);
  cell.actionBlock = ^(XYFriendItem * _Nonnull item) {
    
    TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
    data.conversationID = [NSString stringWithFormat:@"c2c_%@",item.userId];
    data.userID = item.userId.stringValue;
    data.title = item.nickName;
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.conversationData = data;
    [self cyl_pushViewController:chat animated:YES];
    //[weak_self addFriendsWithUserId:item.userId.stringValue];
  };
  cell.centerAction = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  XYTimelineProfileController *profileVc = [[XYTimelineProfileController alloc] init];
  profileVc.userId = self.dataManager.authors[indexPath.row].userId;
  [self cyl_pushViewController:profileVc animated:YES];
}

#pragma - action
- (void)addFriendsWithUserId:(NSString *)userId {
  XYShowLoading;
  if (userId.isNotBlank) {
    [[V2TIMManager sharedInstance] getUsersInfo:@[userId] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
      XYHiddenLoading;
      XYFirendRequestViewController *frc = [[XYFirendRequestViewController alloc] init];
      frc.profile = infoList.firstObject;
      [self cyl_pushViewController:frc animated:YES];
    } fail:^(int code, NSString *msg) {
      XYHiddenLoading;
      XYToastText(msg);
    }];
  }
}
#pragma - UI

- (void)setupSubviews {
  self.gk_navigationBar.hidden = YES;
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self.view addSubview:self.listView];
  [self.listView makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
  }];
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT+50, self.view.XY_width, self.view.XY_height - NAVBAR_HEIGHT-50)];
        _listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _listView.dataSource = self;
        _listView.delegate = self;
      UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
      _listView.tableFooterView = footer;
      _listView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
      if (self.needRefresh) {
        @weakify(self);
        _listView.mj_footer = [XYRefreshFooter footerWithRefreshingBlock:^{
          @strongify(self);
          [self fetchNextData];
        }];
      }
    }
    return _listView;
}

- (XYSearchVideoDataManager *)dataManager {
  if (!_dataManager) {
    _dataManager = [[XYSearchVideoDataManager alloc] init];
  }
  return _dataManager;
}
@end
