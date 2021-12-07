//
//  ContactsController.m
//  TUIKitDemo
//
//  Created by annidyfeng on 2019/3/25.
//  Copyright © 2019年 kennethmiao. All rights reserved.
//

#import "ContactsController.h"
#import "TUIContactController.h"
#import "THeader.h"
#import "XYAddFriendViewController.h"
#import "MMLayout/UIView+MMLayout.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "Toast/Toast.h"
#import "TFriendProfileController.h"
#import "TUIConversationCell.h"
#import "TUIConversationListController.h"
#import "TUIBlackListController.h"
#import "TUINewFriendViewController.h"
#import "ChatViewController.h"
#import "TUIContactSelectController.h"
#import "XYIMGroupLIstController.h"
#import "TIMUserProfile+DataProvider.h"
#import <ImSDK/ImSDK.h>
#import "XYNearbyPeopleController.h"
#import "XYTimelineProfileController.h"
@interface ContactsController ()

@property (nonatomic, weak) TUIContactController *contactController;

@end

@implementation ContactsController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = ColorHex(XYThemeColor_B);
  TUIContactController *conv = [[TUIContactController alloc] init];
  conv.firstGroupData = [self buildViewData];
  conv.tableView.delaysContentTouches = NO;
  [self addChildViewController:conv];
  self.contactController = conv;
  
  conv.actionBlock = ^(TCommonContactCellData * obj) {
    XYTimelineProfileController *vc = [XYTimelineProfileController new];
    vc.userId = obj.identifier.numberValue;
    [self cyl_pushViewController:vc animated:YES];
  };
  
  conv.view.frame = CGRectMake(0, NAVBAR_HEIGHT, self.view.XY_width, self.view.XY_height - NAVBAR_HEIGHT);
  [self.view addSubview:conv.view];

  [self setupNavBar];
}
#pragma - action
- (void)onAddNewFriend:(TCommonTableViewCell *)cell {
    TUINewFriendViewController *vc = [TUINewFriendViewController new];
    [self cyl_pushViewController:vc animated:YES];
    [self.contactController.viewModel clearApplicationCnt];
}

- (void)onGroupConversation:(TCommonTableViewCell *)cell {
  XYIMGroupLIstController *vc = [XYIMGroupLIstController new];
  [self cyl_pushViewController:vc animated:YES];
}

- (void)nearbyFellow:(TCommonContactCell *)cell {
  XYNearbyPeopleController *vc = [[XYNearbyPeopleController alloc] init];
  [self cyl_pushViewController:vc animated:YES];
}

- (void)rightBarButtonClick {
  UIViewController *add = [[XYAddFriendViewController alloc] init];
  [self cyl_pushViewController:add animated:YES];
  
}
#pragma - UI
- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
  UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [moreButton setImage:[UIImage imageNamed:@"icon_22_jiahaoyou"] forState:UIControlStateNormal];
  [moreButton addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
  self.gk_navTitle = @"通讯录";
}

- (NSArray *)buildViewData {
  NSMutableArray *list = @[].mutableCopy;
  [list addObject:({
      TUIContactActionCellData *data = [[TUIContactActionCellData alloc] init];
      data.icon = [UIImage imageNamed:@"icon_44_jiahaoyou"];
      data.title = @"新的朋友";
      data.cselector = @selector(onAddNewFriend:);
      data;
  })];
  [list addObject:({
      TUIContactActionCellData *data = [[TUIContactActionCellData alloc] init];
      data.icon = [UIImage imageNamed:@"icon_44_dingwe"];
      data.title = @"附近老乡";
      data.cselector = @selector(nearbyFellow:);
      data;
  })];
  [list addObject:({
      TUIContactActionCellData *data = [[TUIContactActionCellData alloc] init];
      data.icon = [UIImage imageNamed:@"icon_44_qunliao"];
      data.title = @"群聊";
      data.cselector = @selector(onGroupConversation:);
      data;
  })];
  
  return list.copy;
}


@end
