//
//  FSBaseViewController.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "XYTimelineProfileController.h"
#import "XYDynamicsListController.h"
#import "XYTimelineVideoController.h"
#import "XYTimelineTableView.h"
#import "XYScrollContentView.h"
#import "XYTimelineProfileHeaderCell.h"
#import "XYTimelineProfileDataManager.h"
#import "TUIConversationCellData.h"
#import "ChatViewController.h"
#import "XYTimelineRemarkController.h"
#import "XYFirendRequestViewController.h"

@interface XYTimelineProfileController ()<UITableViewDelegate,UITableViewDataSource,XYPageContentViewDelegate,XYSegmentTitleViewDelegate>

@property (nonatomic,strong) UIView *navBgView;

@property (nonatomic, strong) UIImageView *navIconView;
@property (nonatomic, strong) UILabel *navNameLable;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *attentionBtn;

@property (nonatomic, strong) UIButton *popBtn;

@property (nonatomic, strong) FSBaseTableView *tableView;
@property (nonatomic, strong) XYTimelineProfileHeaderCell *headerCell;
@property (nonatomic, strong) FSBottomTableViewCell *contentCell;
@property (nonatomic, strong) XYSegmentTitleView *titleView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic,strong) XYTimelineProfileDataManager *dataManager;
@end

@implementation XYTimelineProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
    
    [self setupSubViews];
  
    [self fetchData];
}

#pragma - action
- (void)addFriends {
 // if (self.dataManager.model.isFriends) {
    TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
    data.conversationID = [NSString stringWithFormat:@"c2c_%@",self.dataManager.model.userId];
    data.userID = self.dataManager.model.userId.stringValue;
    data.title = self.dataManager.model.nickName;
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.conversationData = data;
    [self cyl_pushViewController:chat animated:YES];
//  } else {
//    XYShowLoading;
//    if (self.dataManager.model.userId) {
//      [[V2TIMManager sharedInstance] getUsersInfo:@[self.dataManager.model.userId.stringValue] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
//        XYHiddenLoading;
//        FriendRequestViewController *frc = [[FriendRequestViewController alloc] init];
//        frc.profile = infoList.firstObject;
//        [self cyl_pushViewController:frc animated:YES];
//      } fail:^(int code, NSString *msg) {
//        XYHiddenLoading;
//        XYToastText(msg);
//      }];
//    }
//  }
}

- (void)attention {
  @weakify(self);
  [self.dataManager followUserWithBlock:^(XYError * _Nonnull error) {
    if (error) {
      XYToastText(error.msg);
    } else {
      if (weak_self.dataManager.model.isFollow.integerValue == 1) {
        weak_self.attentionBtn.selected = YES;
        [weak_self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        weak_self.attentionBtn.layer.borderWidth = 0.0;
        [weak_self.attentionBtn setBackgroundColor:ColorHex(XYThemeColor_I)];
        [weak_self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
        [weak_self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
        
        weak_self.headerCell.attentionBtn.selected = YES;
        [weak_self.headerCell.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        weak_self.headerCell.attentionBtn.layer.borderWidth = 0.0;
        [weak_self.headerCell.attentionBtn setBackgroundColor:ColorHex(XYThemeColor_I)];
        [weak_self.headerCell.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
        [weak_self.headerCell.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
      } else {
        weak_self.attentionBtn.selected = NO;
        weak_self.attentionBtn.layer.borderWidth = 0.0;
        [weak_self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [weak_self.attentionBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
        [weak_self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
        [weak_self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
        
        weak_self.headerCell.attentionBtn.selected = NO;
        weak_self.headerCell.attentionBtn.layer.borderWidth = 0.0;
        [weak_self.headerCell.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
        [weak_self.headerCell.attentionBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
        [weak_self.headerCell.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
        [weak_self.headerCell.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
      }
    }
  }];
}

- (void)remark {
  XYTimelineRemarkController *remarkVc = [[XYTimelineRemarkController alloc] init];
  [self cyl_pushViewController:remarkVc animated:YES];
}

- (void)back {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - data
- (void)fetchData {
  @weakify(self);
  [self.dataManager fetchUserInfoWithBlock:^(XYError *error) {
    if (error) {
      XYToastText(error.msg);
    } else {
      [weak_self.navIconView sd_setImageWithURL:[NSURL URLWithString:weak_self.dataManager.model.headPortrait]];
      if (self.userId.integerValue != [[XYUserService service] fetchLoginUser].userId.integerValue) {
        [weak_self.addBtn setTitle:@"聊天" forState:UIControlStateNormal];
        weak_self.navNameLable.text = self.dataManager.model.nickName;
        if (weak_self.dataManager.model.isFollow.integerValue == 1) {
          weak_self.attentionBtn.enabled = NO;
          [weak_self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
          weak_self.attentionBtn.layer.borderWidth = 0.0;
          [weak_self.attentionBtn setBackgroundColor:ColorHex(XYThemeColor_I)];
          [weak_self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
          [weak_self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
        } else {
          weak_self.attentionBtn.enabled = YES;
          weak_self.attentionBtn.layer.borderWidth = 0.0;
          [weak_self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
          [weak_self.attentionBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
          [weak_self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
          [weak_self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
        }
      }
      [weak_self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    }
  }];
}

#pragma mark delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
      return 363;
    }
    return CGRectGetHeight(self.view.bounds);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 1) {
    return 44;
  }
  return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
  self.titleView = [[XYSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, 140, 44) titles:@[@"短视频",@"动态"] delegate:self indicatorType:XYIndicatorTypeEqualTitle];
  self.titleView.indicatorColor = ColorHex(XYTextColor_635FF0);
  self.titleView.titleFont = AdaptedFont(16);
  self.titleView.titleSelectFont = AdaptedMediumFont(20);
  self.titleView.titleNormalColor = ColorHex(XYTextColor_999999);
  self.titleView.titleSelectColor = ColorHex(XYTextColor_222222);
  self.titleView.itemMargin = 14;
  self.titleView.selectIndex = 0;
  [view addSubview:self.titleView];
  return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        _contentCell = [tableView dequeueReusableCellWithIdentifier:@"FSBottomTableViewCell"];
        if (!_contentCell) {
            _contentCell = [[FSBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FSBottomTableViewCell"];
          
          XYTimelineVideoController *video = [[XYTimelineVideoController alloc] init];
          video.userId = self.userId;
          video.blendedMode = YES;
          
          XYDynamicsListController *scVc = [[XYDynamicsListController alloc] init];
          scVc.hisUserId = self.userId;
          scVc.viewType = XYDynamicsViewType_Others;
          scVc.blendedMode = YES;
          
          NSArray *vcArray = @[video, scVc];
          
          _contentCell.viewControllers = vcArray;
          _contentCell.pageContentView = [[XYPageContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - NAVBAR_HEIGHT - 44) childVCs:vcArray parentVC:self delegate:self];
          [_contentCell.contentView addSubview:_contentCell.pageContentView];
        }
        return _contentCell;
    }
  
    if (indexPath.row == 0) {
      XYTimelineProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYTimelineProfileHeaderCell"];
        if (!cell) {
            cell = [[XYTimelineProfileHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XYTimelineProfileHeaderCell"];
        }
      cell.model = self.dataManager.model;
      @weakify(self);
      cell.addFriendsBlock = ^{
        [weak_self addFriends];
      };
      cell.attentionBlock = ^{
        [weak_self attention];
      };
      cell.remarkBlock = ^{
        [weak_self remark];
      };
      self.headerCell = cell;
      return cell;
      
    }
  
    return nil;
}

#pragma mark XYSegmentTitleViewDelegate
- (void)XYContenViewDidEndDecelerating:(XYPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
    _tableView.scrollEnabled = YES;
}

- (void)XYSegmentTitleView:(XYSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.contentCell.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)XYContentViewDidScroll:(XYPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress {
    _tableView.scrollEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGFloat bottomCellOffset = [_tableView rectForSection:1].origin.y - NAVBAR_HEIGHT;
  if (scrollView.contentOffset.y >= bottomCellOffset) {
      scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
      if (self.canScroll) {
          self.canScroll = NO;
          self.contentCell.cellCanScroll = YES;
      }
  }else{
      if (!self.canScroll) {
          scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
      }
  }
  self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
  [self scrollWithOffset:scrollView.contentOffset.y];
  
}

- (void)scrollWithOffset:(CGFloat)offsetY {
  
  if (offsetY >= (148-StatusBarHeight())) {
    self.navNameLable.hidden = NO;
    self.navIconView.hidden = NO;
    if (self.userId.integerValue != [[XYUserService service] fetchLoginUser].userId.integerValue) {
      self.addBtn.hidden = NO;
      self.attentionBtn.hidden = NO;
    }
    [self.popBtn setImage:[UIImage imageNamed:@"icon_arrow_back_22"] forState:UIControlStateNormal];
  } else {
    self.navNameLable.hidden = YES;
    self.navIconView.hidden = YES;
    if (self.userId.integerValue != [[XYUserService service] fetchLoginUser].userId.integerValue) {
      self.addBtn.hidden = YES;
      self.attentionBtn.hidden = YES;
    }
    [self.popBtn setImage:[UIImage imageNamed:@"icon_arrow_white_22"] forState:UIControlStateNormal];
  }

  CGFloat iconSizeValue = 0.0;
  CGFloat iconTopValue = 0.0;
  CGFloat iconLeftValue = 0.0;
  if (offsetY < 0) {
    iconSizeValue = 80.0;
    iconTopValue = 120;
    iconLeftValue = 24;
    self.navBgView.alpha = 0;
  } else {
    if (offsetY >= 148 - StatusBarHeight()) {
      iconSizeValue = 30.0;
      iconTopValue = 147;
      iconLeftValue = 54;
      self.navBgView.alpha = 1;
    } else {
      iconSizeValue = 80 - ((offsetY * 50)/(148 - StatusBarHeight()));
      iconTopValue = 120 + ((offsetY * 27)/(148 - StatusBarHeight()));
      iconLeftValue = 24 + ((offsetY * 30)/(148 - StatusBarHeight()));;
      self.navBgView.alpha = offsetY/(148 - StatusBarHeight());
    }
}

  self.headerCell.iconView.XY_width = iconSizeValue;
  self.headerCell.iconView.XY_height = iconSizeValue;
  self.headerCell.iconView.XY_top = iconTopValue;
  self.headerCell.iconView.XY_left = iconLeftValue;
  self.headerCell.iconView.layer.cornerRadius = iconSizeValue/2;
}

- (void)changeScrollStatus {
    self.canScroll = YES;
    self.contentCell.cellCanScroll = NO;
}

#pragma mark UI
- (void)setupSubViews {
  self.view.backgroundColor = [UIColor whiteColor];
  self.canScroll = YES;
  self.gk_navigationBar.hidden = YES;
  self.gk_statusBarStyle = UIStatusBarStyleLightContent;
  
  [self.view addSubview:self.tableView];
  [self.tableView makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
  }];
  
  [self.view addSubview:self.navBgView];
  
  UIButton *popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [popBtn setImage:[UIImage imageNamed:@"icon_arrow_white_22"] forState:UIControlStateNormal];
  [popBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
  popBtn.frame = CGRectMake(16, StatusBarHeight()+11, 22, 22);
  self.popBtn = popBtn;
  [self.view addSubview:popBtn];
}

- (UIView *)navBgView {
  if (!_navBgView) {
    _navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NAVBAR_HEIGHT)];
    _navBgView.backgroundColor = ColorHex(XYThemeColor_B);
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.frame = CGRectMake(54, StatusBarHeight()+7, 30, 30);
    iconView.hidden = YES;
    iconView.layer.cornerRadius = 15;
    iconView.layer.masksToBounds = YES;
    self.navIconView = iconView;
    [_navBgView addSubview:iconView];
    
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.textColor = ColorHex(XYTextColor_333333);
    nameLable.font = AdaptedMediumFont(16);
    nameLable.frame = CGRectMake(96, StatusBarHeight()+12, kScreenWidth-96-72, 20);
    nameLable.hidden = YES;
    self.navNameLable = nameLable;
    [_navBgView addSubview:nameLable];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundColor:ColorHex(XYTextColor_635FF0)];
    [addBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    addBtn.titleLabel.font = AdaptedFont(12);
    addBtn.layer.cornerRadius = 14;
    addBtn.layer.masksToBounds = YES;
    [addBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    addBtn.frame = CGRectMake(kScreenWidth-86, StatusBarHeight()+8, 68, 28);
    addBtn.hidden = YES;
    self.addBtn = addBtn;
    [_navBgView addSubview:addBtn];
    
    UIButton *attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [attentionBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
    [attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    attentionBtn.titleLabel.font = AdaptedFont(12);
    attentionBtn.layer.cornerRadius = 14;
    attentionBtn.layer.masksToBounds = YES;
    [attentionBtn addTarget:self action:@selector(attention) forControlEvents:UIControlEventTouchUpInside];
    attentionBtn.frame = CGRectMake(kScreenWidth-86-8-68, StatusBarHeight()+8, 68, 28);
    attentionBtn.hidden = YES;
    self.attentionBtn = attentionBtn;
    [_navBgView addSubview:attentionBtn];
    
    _navBgView.alpha = 0.0;
  }
  return _navBgView;
}

- (FSBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[FSBaseTableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
          _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (XYTimelineProfileDataManager *)dataManager {
  if (!_dataManager) {
    _dataManager = [[XYTimelineProfileDataManager alloc] init];
    _dataManager.userId = self.userId;
  }
  return _dataManager;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
