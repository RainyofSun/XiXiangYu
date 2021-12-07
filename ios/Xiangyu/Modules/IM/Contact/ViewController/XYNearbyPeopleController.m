//
//  XYNearbyPeopleController.m
//  Xiangyu
//
//  Created by dimon on 01/02/2021.
//

#import "XYNearbyPeopleController.h"
#import "XYDropDownMenu.h"
#import "XYAddressContentView.h"
#import "XYLinkageRecycleView.h"
#import "XYSingleListView.h"
#import "XYFriendListCell.h"
#import "XYNearbyDataManager.h"
#import "TUIConversationCellData.h"
#import "ChatViewController.h"
#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "FriendRequestViewController.h"
#import "XYTimelineProfileController.h"
#import "XYNormalScreeningView.h"
#import "XYFirendRequestViewController.h"

#import "XYNearbyHomeScreenView.h"
@interface XYNearbyPeopleController ()< UITableViewDelegate, UITableViewDataSource>//XYDropDownMenuDataSource,XYDropDownMenuDelegate,

@property (strong, nonatomic) UITableView *listView;

@property (strong, nonatomic) XYDropDownMenu *dropDownMenu;

@property (nonatomic, strong) XYNearbyDataManager * dataManager;

@end

@implementation XYNearbyPeopleController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupNavBar];
  
  [self setupSubviews];
  
  [self fetchInitData];
  
}

//#pragma - XYDropDownMenuDataSource & XYDropDownMenuDelegate
//
//- (NSInteger)numberOfColumnsInMenu:(XYDropDownMenu *)menu {
//
//    return 5;
//}
//
//- (NSString *)menu:(XYDropDownMenu *)menu titleForColumn:(NSInteger)column {
//  return self.dataManager.titleArray[column];
//}
//
//- (CGFloat)menu:(XYDropDownMenu *)menu viewHeightForColumn:(NSInteger)column {
//  switch (column) {
//    case 0:
//      return 337;
//      break;
//    case 1:
//    case 2:
//      return 340;
//      break;
//    case 3:
//      return 132;
//      break;
//    case 4:
//      return 340;
//      break;
//    default:
//      break;
//  }
//  return 0;
//}
//
//- (UIView *)menu:(XYDropDownMenu *)menu viewForColumn:(NSInteger)column {
//  @weakify(self);
//  switch (column) {
//    case 0:
//    {
//      XYAddressContentView *address = [[XYAddressContentView alloc] initWithWithoutTitleView:YES withTown:NO withSure:YES];
//      address.backgroundColor = ColorHex(XYThemeColor_B);
//      address.chooseFinish = ^(XYFormattedArea *area) {
//        [menu setTitle:area.cityName ?: @"家乡地址" atIndex:0];
//        [menu packupMenu];
//        [weak_self.dataManager switchHomeTownWithProvice:area.provinceCode city:area.cityCode area:area.code WithBlock:^(BOOL needRefresh, XYError *error) {
//          if (error) {
//            XYToastText(error.msg);
//          }
//          if (needRefresh) {
//            [weak_self.listView reloadData];
//          }
//        }];
//      };
//      return address;
//    }
//      break;
//    case 1:
//    {
//      XYSingleListView *singleListView = [[XYSingleListView alloc] init];
//      singleListView.dataSource = self.dataManager.juniorSchoolNameDatas;
//      singleListView.selectedBlock = ^(NSNumber *selectedIndex) {
//        NSString *title = self.dataManager.juniorSchoolNameDatas[selectedIndex.integerValue];
//        [menu setTitle:title ?: @"初中学校" atIndex:1];
//        [menu packupMenu];
//        [weak_self.dataManager switchJuniorSchoolWithIndex:selectedIndex.integerValue block:^(BOOL needRefresh, XYError *error) {
//          if (error) {
//            XYToastText(error.msg);
//          }
//          if (needRefresh) {
//            [weak_self.listView reloadData];
//          }
//        }];
//      };
//      return singleListView;
//    }
//      break;
//    case 2:
//    {
//      XYSingleListView *singleListView = [[XYSingleListView alloc] init];
//      singleListView.dataSource = self.dataManager.seniorSchoolNameDatas;
//      singleListView.selectedBlock = ^(NSNumber *selectedIndex) {
//        NSString *title = self.dataManager.seniorSchoolNameDatas[selectedIndex.integerValue];
//        [menu setTitle:title ?: @"高中学校" atIndex:2];
//        [menu packupMenu];
//        [weak_self.dataManager switchSeniorSchoolWithIndex:selectedIndex.integerValue block:^(BOOL needRefresh, XYError *error) {
//          if (error) {
//            XYToastText(error.msg);
//          }
//          if (needRefresh) {
//            [weak_self.listView reloadData];
//          }
//        }];
//      };
//      return singleListView;
//    }
//      break;
//    case 3:
//    {
//      XYSingleListView *singleListView = [[XYSingleListView alloc] init];
//      singleListView.dataSource = self.dataManager.sexNameDatas;
//      singleListView.selectedBlock = ^(NSNumber *selectedIndex) {
//        [menu setTitle:self.dataManager.sexNameDatas[selectedIndex.integerValue] ?: @"性别" atIndex:3];
//        [menu packupMenu];
//        [weak_self.dataManager switchSexWithIndex:selectedIndex.integerValue block:^(BOOL needRefresh, XYError *error) {
//          if (error) {
//            XYToastText(error.msg);
//          }
//          if (needRefresh) {
//            [weak_self.listView reloadData];
//          }
//        }];
//      };
//      return singleListView;
//    }
//      break;
//    case 4:
//    {
//      XYLinkageRecycleView *linkageRecycleView = [[XYLinkageRecycleView alloc] init];
//      linkageRecycleView.dataSource = self.dataManager.industryDatas;
//      linkageRecycleView.selectedBlock = ^(NSNumber *selectedLeftIndex, NSNumber *selectedRightIndex) {
//        NSString *title = weak_self.dataManager.industryDatas[selectedLeftIndex.integerValue].list[selectedRightIndex.integerValue].name;
//        [menu setTitle:title ?: @"行业" atIndex:4];
//        [menu packupMenu];
//        [weak_self.dataManager switchIndustryWithOneIndex:selectedLeftIndex.integerValue secondIndex:selectedRightIndex.integerValue block:^(BOOL needRefresh, XYError *error) {
//          if (error) {
//            XYToastText(error.msg);
//          }
//          if (needRefresh) {
//            [weak_self.listView reloadData];
//          }
//        }];
//      };
//      return linkageRecycleView;
//    }
//      break;
//    default:
//      break;
//  }
//  return 0;
//}
//
//- (BOOL)menu:(XYDropDownMenu *)menu shouldSelectMenuAtIndex:(NSUInteger)index {
//  if (index == 1) {
//    if (self.dataManager.juniorSchoolDatas.count > 0) {
//      return YES;
//    } else {
//      XYToastText(@"该地区下暂无初中学校");
//      return NO;
//    }
//  }
//
//  if (index == 2) {
//    if (self.dataManager.seniorSchoolDatas.count > 0) {
//      return YES;
//    } else {
//      XYToastText(@"该地区下暂无高中学校");
//      return NO;
//    }
//  }
//
//  if (index == 4) {
//    if (self.dataManager.industryDatas.count > 0) {
//      return YES;
//    } else {
//      XYToastText(@"获取数据失败,请返回重新加载~");
//      return NO;
//    }
//  }
//
//  return YES;
//}

- (void)fetchInitData {
 XYShowLoading;
  @weakify(self);
  [self.dataManager fetchIndustryDataWithBlock:^(BOOL ret) {
    XYHiddenLoading;
    if (ret) {
      XYUserInfo *user = [[XYUserService service] fetchLoginUser];
      //NSString *cityName = [[XYAddressService sharedService] queryAreaNameWithAdcode:user.city];
     // [self.dropDownMenu setTitle:cityName ?: @"家乡地址" atIndex:0];
      [self.dataManager switchHomeTownWithProvice:user.province city:user.city area:nil WithBlock:^(BOOL needRefresh, XYError *error) {
      
       
          if (error) {
            XYToastText(error.msg);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//              XYHiddenLoading;
//              });
          }
          if (needRefresh) {
            [weak_self.listView reloadData];
          }
      }];
    } else {
//      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       XYHiddenLoading;
//        });
      XYToastText(@"请重新加载~");
    }
  }];
//  [self.dataManager fetchJuniorSchoolDataWithBlock:^(BOOL ret) {
//      XYHiddenLoading;
////    if (!ret) {
////      XYToastText(@"请稍后重新加载~");
////    }
//  }];
//  [self.dataManager fetchSeniorSchoolDataWithBlock:^(BOOL ret) {
//      XYHiddenLoading;
////    if (!ret) {
////      XYToastText(@"请稍后重新加载~");
////    }
//  }];
  
}

- (void)fetchNewData {
  @weakify(self);
 // XYShowLoading;
  [self.dataManager fetchNewDataWithBlock:^(BOOL needRefresh, XYError *error) {
    [weak_self.listView.mj_header endRefreshing];
  //  XYHiddenLoading;
    if (error) {
      XYToastText(error.msg);
    }
    if (needRefresh) {
      [weak_self.listView reloadData];
    }
  }];
}

- (void)fetchNextData {
  @weakify(self);
  //XYShowLoading;
  [self.dataManager fetchNextDataWithBlock:^(BOOL needRefresh, XYError *error) {
    [weak_self.listView.mj_footer endRefreshing];
   // XYHiddenLoading;
    if (error) {
      XYToastText(error.msg);
    }
    if (needRefresh) {
      [weak_self.listView reloadData];
    }
  }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataManager.friendsData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reuseID = @"kHomeRecommendCell";
  XYFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[XYFriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
  cell.isFriend = YES; //self.dataManager.friendsData[indexPath.row].isFriend ? self.dataManager.friendsData[indexPath.row].isFriend.integerValue == 1 : YES;
  cell.item = self.dataManager.friendsData[indexPath.row];
 // @weakify(self);
  cell.actionBlock = ^(XYFriendItem * _Nonnull item) {
  //  if (item.isFriend.integerValue == 1) {
      TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
      data.conversationID = [NSString stringWithFormat:@"c2c_%@",item.userId];
      data.userID = item.userId.stringValue;
      data.title = item.nickName;
      ChatViewController *chat = [[ChatViewController alloc] init];
      chat.conversationData = data;
      [self cyl_pushViewController:chat animated:YES];
  //  } else {
    //  [weak_self addFriendsWithUserId:item.userId.stringValue];
   // }
  };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  XYFriendItem *itme = self.dataManager.friendsData[indexPath.row];
  XYTimelineProfileController *vc = [XYTimelineProfileController new];
  vc.userId = itme.userId;
  [self cyl_pushViewController:vc animated:YES];
}
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
- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
  self.gk_navTitle = @"附近老乡";
  UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [moreButton setImage:[UIImage imageNamed:@"icon_22_xiangqinsx"] forState:UIControlStateNormal];
  [moreButton addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
  //
  //
}
-(void)rightBarButtonClick{
  XYNearbyHomeScreenView *view = [[XYNearbyHomeScreenView alloc]initWithFrame:CGRectMake(AutoSize(75), 0, SCREEN_WIDTH-AutoSize(75), SCREEN_HEIGHT)];
  view.reqParams = self.dataManager.reqParams;
  @weakify(self);
  view.selectedBlock = ^(NSDictionary * _Nonnull item) {
    @strongify(self);
    [self fetchNewData];
  };
  [view show];
}

- (void)setupSubviews {
  self.view.backgroundColor = [UIColor whiteColor];
//  XYDropDownMenu *menu = [[XYDropDownMenu alloc] initWithOrigin:CGPointMake(0, NAVBAR_HEIGHT) andHeight:50];
//  menu.indicatorColor = ColorHex(XYTextColor_999999);
//  menu.textColor = ColorHex(XYTextColor_999999);
//  menu.dataSource = self;
//  menu.delegate = self;
//  self.dropDownMenu = menu;
//  [self.view addSubview:menu];
  
  self.listView.frame = CGRectMake(0, NAVBAR_HEIGHT, kScreenWidth, kScreenHeight - NAVBAR_HEIGHT);
  [self.view addSubview:self.listView];
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _listView.dataSource = self;
        _listView.delegate = self;
      UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
      _listView.tableFooterView = footer;
      if (@available(iOS 11.0, *)) {
        _listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      }else {
      self.automaticallyAdjustsScrollViewInsets = NO;
      }
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

- (XYNearbyDataManager *)dataManager {
  if (!_dataManager) {
    _dataManager = [[XYNearbyDataManager alloc] init];
  }
  return _dataManager;
}
@end
