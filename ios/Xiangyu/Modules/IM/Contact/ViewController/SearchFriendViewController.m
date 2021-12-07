//
//  ZQSearchViewController.m
//  ZQSearchController
//
//  Created by zzq on 2018/9/20.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "SearchFriendViewController.h"
#import "XYDropDownMenu.h"
#import "XYPlatformService.h"
#import "XYAddressContentView.h"
#import "XYLinkageRecycleView.h"
#import "XYSingleListView.h"
#import "XYRangeSliderView.h"
#import "XYFriendListCell.h"
#import "XYSearchFriendsDataManager.h"
#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "XYTimelineProfileController.h"
#import "FriendRequestViewController.h"
#import "XYFirendRequestViewController.h"

#import "ChatViewController.h"
@interface SearchFriendViewController ()<UITextFieldDelegate, XYDropDownMenuDataSource,XYDropDownMenuDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *naviView;

@property (nonatomic, strong) UITextField *searchBar;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) XYDropDownMenu * menu;

@property (nonatomic, strong) XYSearchFriendsDataManager *dataManager;

@property (strong, nonatomic) UITableView *listView;

@property (nonatomic, assign) BOOL active;

@end

@implementation SearchFriendViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.gk_navigationBar.hidden = YES;
    self.gk_popMaxAllowedDistanceToLeftEdge = 16.0;
  
    [self fetchInitData];
  
    [self setupSubviews];
}

#pragma mark - actions
- (void)cancelBtnClicked:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - UITextFieldActions
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField.text.isNotBlank) {
    self.menu.hidden = NO;
    self.listView.hidden = NO;
    [self fetchNewData];
  } else {
    XYToastText(@"请输入昵称/手机号");
  }
  
  return YES;
}

#pragma mark - ZQSearchChildViewDelegate
- (void)searchChildViewDidScroll {
    if (self.searchBar.isFirstResponder) {
        [self.searchBar resignFirstResponder];
    }
}

#pragma - XYDropDownMenuDataSource & XYDropDownMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(XYDropDownMenu *)menu {
    
    return 5;
}

- (NSString *)menu:(XYDropDownMenu *)menu titleForColumn:(NSInteger)column {
  return self.dataManager.titleArray[column];
}

- (CGFloat)menu:(XYDropDownMenu *)menu viewHeightForColumn:(NSInteger)column {
  switch (column) {
    case 0:
      return 337;
      break;
    case 1:
      return 210;
      break;
    case 2:
    case 3:
    case 4:
      return 340;
      break;
    default:
      break;
  }
  return 0;
}

- (UIView *)menu:(XYDropDownMenu *)menu viewForColumn:(NSInteger)column {
  @weakify(self);
  switch (column) {
    case 0:
    {
      XYAddressContentView *address = [[XYAddressContentView alloc] initWithWithoutTitleView:YES withTown:NO withSure:YES];
      address.backgroundColor = ColorHex(XYThemeColor_B);
      address.chooseFinish = ^(XYFormattedArea *area) {
        [menu packupMenu];
        [weak_self.dataManager switchHomeTownWithProvice:area.provinceCode city:area.cityCode area:area.code WithBlock:^(BOOL needRefresh, XYError *error) {
          if (error) {
            XYToastText(error.msg);
          }
          if (needRefresh) {
            [weak_self.listView reloadData];
          }
        }];
      };
      return address;
    }
      break;
    case 1:
    {
      XYRangeSliderView *sliderView = [[XYRangeSliderView alloc] initWithMinValue:18 maxValue:50 minSelectValue:24 maxSelectValue:38  unit:@"岁"];
      sliderView.dismissBlock = ^{
        [menu packupMenu];
      };
      sliderView.selectedBlock = ^(NSNumber *min, NSNumber *max) {
        [menu packupMenu];
        [weak_self.dataManager switchStartAge:roundf(min.floatValue) endAge:roundf(max.floatValue) block:^(BOOL needRefresh, XYError *error) {
          if (error) {
            XYToastText(error.msg);
          }
          if (needRefresh) {
            [weak_self.listView reloadData];
          }
        }];
      };
      return sliderView;
    }
      break;
    case 2:
    {
      XYLinkageRecycleView *linkageRecycleView = [[XYLinkageRecycleView alloc] init];
      linkageRecycleView.dataSource = self.dataManager.industryDatas;
      linkageRecycleView.selectedBlock = ^(NSNumber *selectedLeftIndex, NSNumber *selectedRightIndex) {
        [menu packupMenu];
        [weak_self.dataManager switchIndustryWithOneIndex:selectedLeftIndex.integerValue secondIndex:selectedRightIndex.integerValue block:^(BOOL needRefresh, XYError *error) {
          if (error) {
            XYToastText(error.msg);
          }
          if (needRefresh) {
            [weak_self.listView reloadData];
          }
        }];
      };
      return linkageRecycleView;
    }
      break;
    case 3:
    {
      XYSingleListView *singleListView = [[XYSingleListView alloc] init];
      singleListView.dataSource = self.dataManager.juniorSchoolNameDatas;
      singleListView.selectedBlock = ^(NSNumber *selectedIndex) {
        [menu packupMenu];
        [weak_self.dataManager switchJuniorSchoolWithIndex:selectedIndex.integerValue block:^(BOOL needRefresh, XYError *error) {
          if (error) {
            XYToastText(error.msg);
          }
          if (needRefresh) {
            [weak_self.listView reloadData];
          }
        }];
      };
      return singleListView;
    }
      break;
    case 4:
    {
      XYSingleListView *singleListView = [[XYSingleListView alloc] init];
      singleListView.dataSource = self.dataManager.seniorSchoolNameDatas;
      singleListView.selectedBlock = ^(NSNumber *selectedIndex) {
        [menu packupMenu];
        [weak_self.dataManager switchSeniorSchoolWithIndex:selectedIndex.integerValue block:^(BOOL needRefresh, XYError *error) {
          if (error) {
            XYToastText(error.msg);
          }
          if (needRefresh) {
            [weak_self.listView reloadData];
          }
        }];
      };
      return singleListView;
    }
      break;
    default:
      break;
  }
  return 0;
}

- (BOOL)menu:(XYDropDownMenu *)menu shouldSelectMenuAtIndex:(NSUInteger)index {
  
  if (index == 2) {
    if (self.dataManager.industryDatas.count > 0) {
      return YES;
    } else {
      XYToastText(@"获取数据失败,请返回重新加载~");
      return YES;
    }
  }
  
  if (index == 3) {
    if (self.dataManager.juniorSchoolDatas.count > 0) {
      return YES;
    } else {
      XYToastText(@"该地区下暂无初中学校");
      return NO;
    }
  }
  
  if (index == 4) {
    if (self.dataManager.seniorSchoolDatas.count > 0) {
      return YES;
    } else {
      XYToastText(@"该地区下暂无高中学校");
      return NO;
    }
  }
  
  return YES;
}

- (void)fetchInitData {
  XYShowLoading;
  [self.dataManager fetchIndustryDataWithBlock:^(BOOL ret) {
    XYHiddenLoading;
    if (!ret) {
      XYToastText(@"请稍后重新加载~");
    }
  }];
  [self.dataManager fetchJuniorSchoolDataWithBlock:^(BOOL ret) {
    XYHiddenLoading;
//    if (!ret) {
//      XYToastText(@"请稍后重新加载~");
//    }
  }];
  [self.dataManager fetchSeniorSchoolDataWithBlock:^(BOOL ret) {
      XYHiddenLoading;
//    if (!ret) {
//      XYToastText(@"请稍后重新加载~");
//    }
  }];
  
  
  
}

- (void)fetchNewData {
  @weakify(self);
  XYShowLoading;
  [self.searchBar resignFirstResponder];
  self.dataManager.reqParams.keyword = self.searchBar.text;
  [self.dataManager fetchNewDataWithBlock:^(BOOL needRefresh, XYError *error) {
    XYHiddenLoading;
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
  XYShowLoading;
  [self.searchBar resignFirstResponder];
  [self.dataManager fetchNextDataWithBlock:^(BOOL needRefresh, XYError *error) {
    [weak_self.listView.mj_footer endRefreshing];
    XYHiddenLoading;
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
  static NSString *reuseID = @"kSearchFriendCell";
  XYFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[XYFriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
  cell.isFriend = YES; //self.dataManager.friendsData[indexPath.row].isFriend ? self.dataManager.friendsData[indexPath.row].isFriend.integerValue == 1 : NO;
  
  cell.item = self.dataManager.friendsData[indexPath.row];
  //@weakify(self);
  cell.actionBlock = ^(XYFriendItem * _Nonnull item) {
    TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
    data.conversationID = [NSString stringWithFormat:@"c2c_%@",item.userId];
    data.userID = item.userId.stringValue;
    data.title = item.nickName;
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.conversationData = data;
    [self cyl_pushViewController:chat animated:YES];
    
   // [weak_self addFriendsWithUserId:item.userId.stringValue];
  };
  cell.centerAction = YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  XYFriendItem *itme = self.dataManager.friendsData[indexPath.row];
  XYTimelineProfileController *vc = [XYTimelineProfileController new];
  vc.userId = itme.userId;
  [self cyl_pushViewController:vc animated:YES];
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
  self.view.backgroundColor = ColorHex(XYThemeColor_F);
  [self.view addSubview:self.naviView];
  [self.naviView addSubview:self.cancelBtn];
  [self.naviView addSubview:self.searchBar];
  [self.view addSubview:self.menu];
  [self.view addSubview:self.listView];
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT+50, self.view.XY_width, self.view.XY_height - NAVBAR_HEIGHT-50)];
        _listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _listView.dataSource = self;
        _listView.delegate = self;
     // _listView.backgroundColor = [UIColor redColor];
      UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
      _listView.tableFooterView = footer;
      _listView.hidden = YES;
      @weakify(self);
      _listView.mj_footer = [XYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self fetchNextData];
      }];
    }
    return _listView;
}

- (UITextField *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UITextField alloc] initWithFrame:CGRectMake(16, NAVBAR_HEIGHT - 30 - 7, kScreenWidth - 84, 30)];
        _searchBar.placeholder = @"输入昵称/手机号";
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

- (XYDropDownMenu *)menu {
    if (!_menu) {
      _menu = [[XYDropDownMenu alloc] initWithOrigin:CGPointMake(0, NAVBAR_HEIGHT) andHeight:50];
      _menu.indicatorColor = ColorHex(XYTextColor_999999);
      _menu.textColor = ColorHex(XYTextColor_999999);
      _menu.dataSource = self;
      _menu.delegate = self;
      _menu.hidden = YES;
    }
    return _menu;
}

- (XYSearchFriendsDataManager *)dataManager {
  if (!_dataManager) {
    _dataManager = [[XYSearchFriendsDataManager alloc] init];
  }
  return _dataManager;
}
@end
