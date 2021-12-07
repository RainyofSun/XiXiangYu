//
//  XYIndustryCircleController.m
//  Xiangyu
//
//  Created by dimon on 01/02/2021.
//

#import "XYIndustryCircleController.h"
#import "XYDropDownMenu.h"
#import "XYAddressContentView.h"
#import "XYLinkageRecycleView.h"
#import "XYSingleListView.h"
#import "XYIndustryCircleCell.h"
#import "XYIndustryCircleDataManager.h"
#import "TUIConversationCellData.h"
#import "ChatViewController.h"
#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "FriendRequestViewController.h"
#import "XYTimelineProfileController.h"
#import "XYNormalScreeningView.h"
#import "XYFirendRequestViewController.h"

#import "XYIndustryCircleScreenView.h"
#import "UIScrollView+EmptyDataSet.h"
@import ImSDK;
@interface XYIndustryCircleController ()< UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
//XYDropDownMenuDataSource,XYDropDownMenuDelegate,
@property (strong, nonatomic) UITableView *listView;

@property (nonatomic, strong) XYIndustryCircleDataManager * dataManager;

//@property (nonatomic, strong) XYDropDownMenu * dropDownMenu
@property(nonatomic,strong)NSString *industryName;// 用于回显数据
@end

@implementation XYIndustryCircleController

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
//  return 340;
//}
//
//- (UIView *)menu:(XYDropDownMenu *)menu viewForColumn:(NSInteger)column {
//  @weakify(self);
//  switch (column) {
//    case 0:
//    {
//      XYLinkageRecycleView *linkageRecycleView = [[XYLinkageRecycleView alloc] init];
//      linkageRecycleView.dataSource = self.dataManager.industryDatas;
//      linkageRecycleView.selectedBlock = ^(NSNumber *selectedLeftIndex, NSNumber *selectedRightIndex) {
//        NSString *title = weak_self.dataManager.industryDatas[selectedLeftIndex.integerValue].list[selectedRightIndex.integerValue].name;
//        [menu setTitle:title ?: @"行业" atIndex:0];
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
//    case 1:
//    {
//      XYAddressContentView *address = [[XYAddressContentView alloc] initWithWithoutTitleView:YES withTown:NO withSure:YES];
//      address.backgroundColor = ColorHex(XYThemeColor_B);
//      address.chooseFinish = ^(XYFormattedArea *area) {
//        [menu setTitle:area.cityName ?: @"故乡地址" atIndex:1];
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
//    case 2:
//    {
//      XYAddressContentView *address = [[XYAddressContentView alloc] initWithWithoutTitleView:YES withTown:NO withSure:YES];
//      address.backgroundColor = ColorHex(XYThemeColor_B);
//      address.chooseFinish = ^(XYFormattedArea *area) {
//        [menu setTitle:area.cityName ?: @"现居地" atIndex:2];
//        [menu packupMenu];
//        [weak_self.dataManager switchPresentAddressWithProvice:area.provinceCode city:area.cityCode area:area.code WithBlock:^(BOOL needRefresh, XYError *error) {
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
//    case 3:
//    {
//      XYSingleListView *singleListView = [[XYSingleListView alloc] init];
//      singleListView.dataSource = self.dataManager.juniorSchoolNameDatas;
//      singleListView.selectedBlock = ^(NSNumber *selectedIndex) {
//        NSString *title = self.dataManager.juniorSchoolNameDatas[selectedIndex.integerValue];
//        [menu setTitle:title ?: @"初中学校" atIndex:3];
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
//    case 4:
//    {
//      XYSingleListView *singleListView = [[XYSingleListView alloc] init];
//      singleListView.dataSource = self.dataManager.seniorSchoolNameDatas;
//      singleListView.selectedBlock = ^(NSNumber *selectedIndex) {
//        NSString *title = self.dataManager.seniorSchoolNameDatas[selectedIndex.integerValue];
//        [menu setTitle:title ?: @"高中学校" atIndex:4];
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
//    default:
//      break;
//  }
//  return 0;
//}
//
//- (BOOL)menu:(XYDropDownMenu *)menu shouldSelectMenuAtIndex:(NSUInteger)index {
//  if (index == 0) {
//    if (self.dataManager.industryDatas.count > 0) {
//      return YES;
//    } else {
//      XYToastText(@"获取数据失败,请返回重新加载~");
//      return NO;
//    }
//  }
//  
//  if (index == 3) {
//    if (self.dataManager.juniorSchoolDatas.count > 0) {
//      return YES;
//    } else {
//      XYToastText(@"该地区下暂无初中学校");
//      return NO;
//    }
//  }
//  
//  if (index == 4) {
//    if (self.dataManager.seniorSchoolDatas.count > 0) {
//      return YES;
//    } else {
//      XYToastText(@"该地区下暂无高中学校");
//      return NO;
//    }
//  }
//  return YES;
//}

- (void)fetchInitData {
  @weakify(self);
  XYShowLoading;
  [self.dataManager fetchIndustryDataWithBlock:^(BOOL ret) {
    if (ret) {
      XYUserInfo *user = [[XYUserService service] fetchLoginUser];
     // NSString *cityName = [[XYAddressService sharedService] queryAreaNameWithAdcode:user.city];
     // [self.dropDownMenu setTitle:cityName ?: @"故乡地址" atIndex:1];
      [self.dataManager switchHomeTownWithProvice:user.province city:user.city area:nil WithBlock:^(BOOL needRefresh, XYError *error) {
        XYHiddenLoading;
        if (error) {
          XYToastText(error.msg);
        }
        if (needRefresh) {
          [weak_self.listView reloadData];
        }
      }];
    } else {
      XYHiddenLoading;
      XYToastText(@"请重新加载~");
    }
  }];
//  [self.dataManager fetchJuniorSchoolDataWithBlock:^(BOOL ret) {
//    XYHiddenLoading;
////    if (!ret) {
////      XYToastText(@"请稍后重新加载~");
////    }
//  }];
//  [self.dataManager fetchSeniorSchoolDataWithBlock:^(BOOL ret) {
//    XYHiddenLoading;
////    if (!ret) {
////      XYToastText(@"请稍后重新加载~");
////    }
//  }];
}

- (void)fetchNewData {
  @weakify(self);
  [self.dataManager fetchNewDataWithBlock:^(BOOL needRefresh, XYError *error) {
    [weak_self.listView.mj_header endRefreshing];
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
  [self.dataManager fetchNextDataWithBlock:^(BOOL needRefresh, XYError *error) {
    [weak_self.listView.mj_footer endRefreshing];
    if (error) {
      XYToastText(error.msg);
    }
    if (needRefresh) {
      [weak_self.listView reloadData];
    }
  }];
}

- (void)addFriendWithItem:(XYInterestItem *)item {
  //if (item.isAdded) {
    TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
    data.conversationID = [NSString stringWithFormat:@"c2c_%@",item.relationId];
    data.userID = item.relationId;
    data.title = item.name;
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.conversationData = data;
    [self cyl_pushViewController:chat animated:YES];
//  } else {
//    if (item.relationId) {
//      [[V2TIMManager sharedInstance] getUsersInfo:@[item.relationId] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
//        XYFirendRequestViewController *frc = [[XYFirendRequestViewController alloc] init];
//        frc.profile = infoList.firstObject;
//        [self cyl_pushViewController:frc animated:YES];
//      } fail:^(int code, NSString *msg) {
//        XYToastText(msg);
//      }];
//    }
//  }
}

//添加群组
- (void)addGroupWithGroupId:(NSString *)groupId {
  TUIConversationCellData *conversationData = [[TUIConversationCellData alloc] init];
  conversationData.groupID = groupId;
  ChatViewController *chat = [[ChatViewController alloc] init];
  chat.conversationData = conversationData;
  [self cyl_pushViewController:chat animated:YES];
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
  static NSString *reuseID = @"kIndustryCircleCell";
  XYIndustryCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[XYIndustryCircleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
  cell.item = self.dataManager.friendsData[indexPath.row];
  cell.addBlock = ^(XYInterestItem *item) {
    if (item.isGroup) {
      [self addGroupWithGroupId:item.relationId];
    } else {
      [self addFriendWithItem:item];
    }
  };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  XYInterestItem *item = self.dataManager.friendsData[indexPath.row];
  if (!item.isGroup) {
    XYTimelineProfileController *vc = [XYTimelineProfileController new];
    vc.userId = item.relationId.numberValue;
    [self cyl_pushViewController:vc animated:YES];
  }
  
}
#pragma - UI
- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
  self.gk_navTitle = @"行业圈";
  UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [moreButton setImage:[UIImage imageNamed:@"icon_22_xiangqinsx"] forState:UIControlStateNormal];
  [moreButton addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
  //
  //
}
-(void)rightBarButtonClick{
  XYIndustryCircleScreenView *view = [[XYIndustryCircleScreenView alloc]initWithFrame:CGRectMake(AutoSize(75), 0, SCREEN_WIDTH-AutoSize(75), SCREEN_HEIGHT)];
  view.reqParams = self.dataManager.reqParams;
  @weakify(self);
  view.selectedBlock = ^(NSDictionary * _Nonnull item) {
    @strongify(self);
    [self fetchNewData];
  };
  view.attachedView = self.view;
  view.industryName = self.industryName;
  view.targetVc = self;
  [view showWithStateBlock:^(FWPopupBaseView *popupBaseView, FWPopupState popupState) {
    if (popupState == FWPopupStateDidAppear) {
      self.gk_navigationBar.userInteractionEnabled = NO;
    }else if (popupState == FWPopupStateDidDisappear){
      self.gk_navigationBar.userInteractionEnabled = YES;
    }
    self.industryName =view.industryName;
    
    
    
  }];
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
      _listView.emptyDataSetDelegate = self;
      _listView.emptyDataSetSource = self;
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

- (XYIndustryCircleDataManager *)dataManager {
  if (!_dataManager) {
    _dataManager = [[XYIndustryCircleDataManager alloc] init];
  }
  return _dataManager;
}
@end
