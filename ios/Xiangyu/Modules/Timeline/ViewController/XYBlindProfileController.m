//
//  XYBlindProfileController.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "XYBlindProfileController.h"
#import "XYDynamicsListController.h"
#import "XYTimelineVideoController.h"
#import "XYTimelineTableView.h"
#import "XYScrollContentView.h"
#import "XYBlindProfileHeaderCell.h"
#import "XYBlindDataManager.h"
#import "TUIConversationCellData.h"
#import "ChatViewController.h"
#import "XYTimelineRemarkController.h"
#import "XYBlindInfoCell.h"
#import "XYBlindImagesCell.h"
#import "XYBlindGiftListCell.h"
#import "ShareView.h"
#import "XYBlindGiftListViewController.h"
#import "FriendRequestViewController.h"
#import "GKDYGiftView.h"
#import "GKSlidePopupView.h"
#import "XYPlatformService.h"

#import "XYBlindRightMenuView.h"
#import "XYBlindDateHelpMiAPI.h"
#import "XYChatToNoFirendPopView.h"

#import "XYProfessConfManager.h"
#import "XYSendHeartBeatView.h"
#import "XYGiftPaymentController.h"
#import "XYHeartBeatNumberBuyView.h"

#import "UIBarButtonItem+GKNavigationBar.h"
@interface XYBlindProfileController ()<UITableViewDelegate,UITableViewDataSource,XYPageContentViewDelegate,XYSegmentTitleViewDelegate>

//@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic, strong) ShareView * shareView;

//@property (nonatomic, strong) YYLabel *likesLable;
//@property (nonatomic, strong) UIButton *givingGiftBtn;
//@property (nonatomic, strong) UIButton *attentionBtn;
//@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) FSBaseTableView *tableView;
@property (nonatomic, strong) FSBottomTableViewCell *contentCell;
@property (nonatomic, strong) XYSegmentTitleView *titleView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic,strong) XYBlindDataManager *dataManager;
@property (nonatomic, strong) GKSlidePopupView *giftPopupView ;
@property (nonatomic, assign) NSUInteger rowCount;


@property(nonatomic,strong)XYBlindRightMenuView *menuView;

@property(nonatomic,strong)XYProfessConfManager *manager;
@end

@implementation XYBlindProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
  
    [self setupNavBar];
  
    [self setupSubViews];
  
    [self fetchData];
}

#pragma - action
- (void)addFriends {
  
  
  
  [[XYPlatformService shareService] fetchOnlineSwitchWithBlock:^(BOOL status) {
    if (!status) {
      XYChatToNoFirendPopView *popView = [[XYChatToNoFirendPopView alloc]initWithFrame:[UIScreen mainScreen].bounds];
      popView.actionChatBlock = ^(NSInteger index) {
        if (index == 0) { // 陌生人聊天
              XYShowLoading;
              if (self.dataManager.model.userId) {
                
                TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
                data.conversationID = [NSString stringWithFormat:@"c2c_%@",self.dataManager.model.userId];
                data.userID = self.dataManager.model.userId.stringValue;
                data.title = self.dataManager.model.nickName;
                ChatViewController *chat = [[ChatViewController alloc] init];
                chat.conversationData = data;
                [self cyl_pushViewController:chat animated:YES];
                

              }
        }else if(index == 1){ // 这个是表白
          XYBlindDataItemModel *model = [[XYBlindDataItemModel alloc]init];
          model.id = self.dataManager.model.id;
          model.userId = self.dataManager.model.userId;
          model.nickName = self.dataManager.model.nickName;
          
          [self sendHeartBeat:model];
        }else{
          // 送礼物
          [self givingGift];
        }
      };
      
      
      [popView show];
    }else{
      if (self.dataManager.model.userId) {
        
        TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
        data.conversationID = [NSString stringWithFormat:@"c2c_%@",self.dataManager.model.userId];
        data.userID = self.dataManager.model.userId.stringValue;
        data.title = self.dataManager.model.nickName;
        ChatViewController *chat = [[ChatViewController alloc] init];
        chat.conversationData = data;
        [self cyl_pushViewController:chat animated:YES];
        

      }
    }
    
    
  }];
  
  
  
  
//if (self.dataManager.model.isFriend.integerValue == 1) {
//    TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
//    data.conversationID = [NSString stringWithFormat:@"c2c_%@",self.dataManager.model.userId];
//    data.userID = self.dataManager.model.userId.stringValue;
//    data.title = self.dataManager.model.nickName;
//    ChatViewController *chat = [[ChatViewController alloc] init];
//    chat.conversationData = data;
//    [self cyl_pushViewController:chat animated:YES];
//  } else {
    
  
    
    
    
    

// }
}

- (void)attention {
  @weakify(self);
  XYShowLoading;
  [self.dataManager followUserWithBlock:^(XYError * _Nonnull error) {
    XYHiddenLoading;
    if (error) {
      XYToastText(error.msg);
    } else {
      //[weak_self.attentionBtn setTitle:weak_self.dataManager.model.isFollow.integerValue == 1 ? @"取消关注" : @"关注" forState:UIControlStateNormal];
      weak_self.menuView.praiseBtn.selected = weak_self.dataManager.model.isFollow.integerValue == 1;// ? @"取消关注" : @"关注TA";
    }
  }];
}
-(void)zhuLiAction{
  XYShowLoading;
  XYBlindDateHelpMiAPI *api = [[XYBlindDateHelpMiAPI alloc]initWithId:self.dataManager.model.id];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    if (error) {
      XYToastText(error.msg);
    } else {
      XYToastText(@"助力成功，TA的相亲信息排名将会靠前");
      [self.menuView.player startAnimation];
      //[weak_self.attentionBtn setTitle:weak_self.dataManager.model.isFollow.integerValue == 1 ? @"取消关注" : @"关注" forState:UIControlStateNormal];
     // weak_self.menuView.praiseBtn.title = weak_self.dataManager.model.isFollow.integerValue == 1 ? @"取消关注" : @"关注TA";
    }
  };
  [api start];
  
}
- (void)clickGiftCloseBtn {
  [_giftPopupView dismiss];
}
- (void)givingGift {
  
    GKDYGiftView *commentView = [GKDYGiftView new];
  commentView.type = @(2);
    MJWeakSelf
    commentView.closePage = ^{
      [weakSelf clickGiftCloseBtn];
    };
//  [commentView.closeBtn handleControlEventWithBlock:^(id sender) {
//    [weakSelf clickGiftCloseBtn];
//  }];
  commentView.payWithSuccessGift = ^{
    [weakSelf clickGiftCloseBtn];
    
    if (self.dataManager.model.isFriend.integerValue == 1) {
      TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
      data.conversationID = [NSString stringWithFormat:@"c2c_%@",self.dataManager.model.userId];
      data.userID = self.dataManager.model.userId.stringValue;
      data.title = self.dataManager.model.nickName;
      ChatViewController *chat = [[ChatViewController alloc] init];
      chat.conversationData = data;
      [self cyl_pushViewController:chat animated:YES];
    }else{
      UIAlertController *actionVC=[UIAlertController alertControllerWithTitle:@"发送成功" message:@"对方已收到你的礼物，是否开始和TA畅聊？" preferredStyle:UIAlertControllerStyleAlert];
      
      UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleCancel handler:nil];
      UIAlertAction *chatAction = [UIAlertAction actionWithTitle:@"去聊天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
        data.conversationID = [NSString stringWithFormat:@"c2c_%@",self.dataManager.model.userId];
        data.userID = self.dataManager.model.userId.stringValue;
        data.title = self.dataManager.model.nickName;
        ChatViewController *chat = [[ChatViewController alloc] init];
        chat.conversationData = data;
        [self cyl_pushViewController:chat animated:YES];
        
      }];
      [chatAction setValue:ColorHex(@"#F92B5E") forKey:@"titleTextColor"];
      [actionVC addAction:chatAction];
     [actionVC addAction:cancelAction];
      [weakSelf presentViewController:actionVC animated:YES completion:nil];
    }
    
   
    
    
  };
    [commentView.closeBtn addTarget:self action:@selector(clickGiftCloseBtn) forControlEvents:UIControlEventTouchUpInside];
      commentView.frame = CGRectMake(0, 0, GK_SCREEN_WIDTH, ADAPTATIONRATIO * 780.0f);
  commentView.user_id = [_userId stringValue];
      _giftPopupView = [GKSlidePopupView popupViewWithFrame:[UIScreen mainScreen].bounds contentView:commentView];
      [_giftPopupView showFrom:[UIApplication sharedApplication].keyWindow completion:^{
        [commentView requestData];
      }];
}

- (void)remark {
  XYTimelineRemarkController *remarkVc = [[XYTimelineRemarkController alloc] init];
  [self cyl_pushViewController:remarkVc animated:YES];
}

#pragma mark - data
- (void)fetchData {
  @weakify(self);
  XYShowLoading;
  [[XYPlatformService shareService] fetchOnlineSwitchWithBlock:^(BOOL status) {
    [self.menuView layoutResult:status];
    self.rowCount = status ? 4 : 5;
    [self.dataManager fetchUserInfoWithBlock:^(XYError *error) {
      XYHiddenLoading;
      if (error) {
        XYToastText(error.msg);
      } else {
        weak_self.menuView.praiseBtn.selected = weak_self.dataManager.model.isFollow.integerValue == 1;// ? @"取消关注" : @"关注TA";
        
        
        
       // [weak_self.attentionBtn setTitle:weak_self.dataManager.model.isFollow.integerValue == 1 ? @"取消关注" : @"关注" forState:UIControlStateNormal];
       // [weak_self.addBtn setTitle:weak_self.dataManager.model.isFriend.integerValue == 1 ? @"聊天" : @"加好友" forState:UIControlStateNormal];
  //      weak_self.likesLable.attributedText = self.dataManager.likesAttrString;
        [weak_self.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
      }
    }];
  }];
}

#pragma mark delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return self.rowCount;
  }
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
      if (indexPath.row == 0) {
        return kScreenWidth;
      }
      if (indexPath.row == 1) {
        return 80 + self.dataManager.model.remarkHeight;
      }
      if (indexPath.row == 2) {
        return 60 + self.dataManager.profileLayout.textBoundingSize.height;
      }
      if (indexPath.row == 3) {
        return 60 + self.dataManager.introductionLayout.textBoundingSize.height;
      }
      if (indexPath.row == 4) {
        return 158;
      }
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
          _contentCell.pageContentView = [[XYPageContentView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44-NAVBAR_HEIGHT) childVCs:vcArray parentVC:self delegate:self];
         //- 44-TABBAR_HEIGHT
          [_contentCell.contentView addSubview:_contentCell.pageContentView];
        }
        return _contentCell;
    }
  
  if (indexPath.row == 0) {
    XYBlindImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYBlindImagesCell"];
      if (!cell) {
          cell = [[XYBlindImagesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XYBlindImagesCell"];
      }
    cell.resources = self.dataManager.model.images;
    return cell;
    
  }
  
    if (indexPath.row == 1) {
      XYBlindProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYBlindProfileHeaderCell"];
        if (!cell) {
            cell = [[XYBlindProfileHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XYBlindProfileHeaderCell"];
        }
      cell.model = self.dataManager.model;
      return cell;
      
    }
  
  if (indexPath.row == 2) {
    XYBlindInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYBlindInfoCell"];
      if (!cell) {
          cell = [[XYBlindInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XYBlindInfoCell"];
      }
    cell.titleLabel.text = @"对另一半的要求"; //self.dataManager.model.sex.integerValue == 2 ? //@"TA的资料" : @"TA的资料";
    cell.textLayout = self.dataManager.profileLayout;
    return cell;
    
  }
  
  if (indexPath.row == 3) {
    XYBlindInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYBlindInfoCell"];
      if (!cell) {
          cell = [[XYBlindInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XYBlindInfoCell"];
      }
    cell.titleLabel.text = self.dataManager.model.sex.integerValue == 2 ? @"TA的介绍" : @"TA的介绍";
    cell.textLayout = self.dataManager.introductionLayout;
    return cell;
    
  }
  
  if (indexPath.row == 4) {
    XYBlindGiftListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XYBlindGiftListCell"];
      if (!cell) {
          cell = [[XYBlindGiftListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XYBlindGiftListCell"];
      }
    cell.titleLabel.text = self.dataManager.model.sex.integerValue == 2 ? @"TA收到的礼物" : @"TA收到的礼物";
    cell.data = self.dataManager.giftList;
    MJWeakSelf
    cell.giftListClickToPage = ^{
      XYBlindGiftListViewController *vc = [[XYBlindGiftListViewController alloc] init];
      [weakSelf cyl_pushViewController:vc animated:YES];
      
    };
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
  CGFloat bottomCellOffset = [_tableView rectForSection:1].origin.y-NAVBAR_HEIGHT;
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
  
  if (offsetY >= (SCREEN_WIDTH-NAVBAR_HEIGHT)) {
    self.gk_navLeftBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"icon_arrow_back_22"] target:self action:@selector(popVCEvent:)];
    self.gk_navRightBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"icon_22_fenxiang"] target:self action:@selector(rightBarButtonClick)];
    self.gk_navBarAlpha = 1;
    self.gk_navTitle = @"个人详情";
  } else {
    self.gk_navLeftBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"icon_arrow_white_22"] target:self action:@selector(popVCEvent:)];
    self.gk_navRightBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage gk_changeImage:[UIImage imageNamed:@"icon_22_fenxiang"] color:[UIColor whiteColor]] target:self action:@selector(rightBarButtonClick)];
    self.gk_navBarAlpha = 0;
    self.gk_navTitle = @"";
  }

 
  

 
}
- (void)changeScrollStatus {
    self.canScroll = YES;
    self.contentCell.cellCanScroll = NO;
}

#pragma mark UI
- (void)setupSubViews {
  self.view.backgroundColor = [UIColor whiteColor];
  self.canScroll = YES;
  
//  [self.view addSubview:self.bottomView];
//  [self.bottomView makeConstraints:^(MASConstraintMaker *make) {
//      make.left.right.bottom.equalTo(self.view);
//    make.height.mas_equalTo(TABBAR_HEIGHT);
//  }];
  
  [self.view addSubview:self.tableView];
  [self.tableView makeConstraints:^(MASConstraintMaker *make) {
      make.edges.insets(UIEdgeInsetsMake(0, 0, 0, 0));
  }];

  [self.view addSubview:self.menuView];
  [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self.view).offset(-AutoSize(10));
    make.bottom.equalTo(self.view).offset(-GK_SAFEAREA_BTM-AutoSize(28));
    make.size.mas_equalTo(CGSizeMake(AutoSize(120), AutoSize(280)));
  }];
  
  
  
//  [self.view addSubview:self.givingGiftBtn];
//  [self.givingGiftBtn makeConstraints:^(MASConstraintMaker *make) {
//    make.size.mas_equalTo(CGSizeMake(52, 52));
//    make.right.mas_equalTo(self.view).offset(-12);
//    make.bottom.mas_equalTo(self.view).offset(-100);
//  }];
}

- (void)setupNavBar {
//  self.gk_navLineHidden = YES;
//  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
//  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
//  self.gk_navigationBar.layer.shadowOpacity = 0.06;
//  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
  self.gk_navBarAlpha = 0;
  self.gk_navTintColor = ColorHex(XYTextColor_FFFFFF);
  
  self.gk_navLeftBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"icon_arrow_white_22"] target:self action:@selector(popVCEvent:)];
  
  
  self.gk_navRightBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage gk_changeImage:[UIImage imageNamed:@"icon_22_fenxiang"] color:[UIColor whiteColor]] target:self action:@selector(rightBarButtonClick)];
  
 // self.gk_navRightBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"icon_22_fenxiang"] target:self action:@selector(rightBarButtonClick)];
  
  //self.gk_navTitle = @"个人详情";
}
-(void)popVCEvent:(id)sender{
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBarButtonClick {
  [self.shareView showWithContentType:JSHARELink shareType:@{@"type":@"5",@"id":_blindId,@"userId":_userId,@"title":self.dataManager.model.nickName,@"remark":self.dataManager.model.remark,@"iconUrl":self.dataManager.model.images.count > 0 ? self.dataManager.model.images[0] : @""}];

}
- (ShareView *)shareView {
    if (!_shareView) {
      _shareView = [[ShareView alloc] init];
      [_shareView getFactoryShareViewWithCallBack:^(JSHAREPlatform platform, JSHAREMediaType type) {
              
      }];
        [self.view addSubview:self.shareView];
    }
    return _shareView;
}


//
//- (UIView *)bottomView {
//  if (!_bottomView) {
//    _bottomView = [[UIView alloc] init];
//    _bottomView.backgroundColor = ColorHex(XYThemeColor_B);
//
//    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [addBtn setBackgroundColor:ColorHex(XYTextColor_635FF0)];
//    [addBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
//    addBtn.titleLabel.font = AdaptedFont(15);
//    addBtn.layer.cornerRadius = 18;
//    addBtn.layer.masksToBounds = YES;
//    [addBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
//    addBtn.frame = CGRectMake(kScreenWidth-116, 7, 100, 36);
//    self.addBtn = addBtn;
//    [_bottomView addSubview:addBtn];
//
//    UIButton *attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [attentionBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
//    [attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
//    attentionBtn.titleLabel.font = AdaptedFont(15);
//    attentionBtn.layer.cornerRadius = 18;
//    attentionBtn.layer.masksToBounds = YES;
//    [attentionBtn addTarget:self action:@selector(attention) forControlEvents:UIControlEventTouchUpInside];
//    attentionBtn.frame = CGRectMake(kScreenWidth-232, 7, 100, 36);
//    self.attentionBtn = attentionBtn;
//    [_bottomView addSubview:attentionBtn];
//
////    YYLabel *likesLable = [[YYLabel alloc] init];
////    likesLable.textColor = ColorHex(XYTextColor_333333);
////    likesLable.font = AdaptedMediumFont(16);
////    likesLable.frame = CGRectMake(16, 14, CGRectGetMinX(attentionBtn.frame)-32, 22);
////    self.likesLable = likesLable;
////    [_bottomView addSubview:likesLable];
//  }
//  return _bottomView;
//}

- (FSBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[FSBaseTableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
      _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
          _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (XYBlindDataManager *)dataManager {
  if (!_dataManager) {
    _dataManager = [[XYBlindDataManager alloc] init];
    _dataManager.userId = self.userId;
    _dataManager.blindId = self.blindId;
  }
  return _dataManager;
}

//- (UIButton *)givingGiftBtn {
//  if (!_givingGiftBtn) {
//    _givingGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_givingGiftBtn setImage:[UIImage imageNamed:@"icon_songtaliwu"] forState:UIControlStateNormal];
//    [_givingGiftBtn addTarget:self action:@selector(givingGift) forControlEvents:UIControlEventTouchUpInside];
//    _givingGiftBtn.hidden = YES;
//  }
//  return _givingGiftBtn;
//}
-(XYBlindRightMenuView *)menuView{
  if (!_menuView) {
    _menuView = [[XYBlindRightMenuView alloc]initWithFrame:CGRectMake(0, 0, AutoSize(120), AutoSize(280))];
    [_menuView.zhuBtn addTarget:self action:@selector(zhuLiAction) forControlEvents:UIControlEventTouchUpInside];
    [_menuView.giftBtn addTarget:self action:@selector(givingGift) forControlEvents:UIControlEventTouchUpInside];
    [_menuView.praiseBtn addTarget:self action:@selector(attention) forControlEvents:UIControlEventTouchUpInside];//
    [_menuView.chatBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
  }
  return _menuView;
}
-(XYProfessConfManager *)manager{
  if (!_manager) {
    _manager = [[XYProfessConfManager alloc] init];
  }
  return _manager;
}
-(void)sendHeartBeat:(XYBlindDataItemModel*)model{
 // XYWalletSuperHeartCountAPI *api = [[XYWalletSuperHeartCountAPI alloc]init];
  //api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
  
  
  
  
  
  
  @weakify(self);
  [self.manager releaseProfessConfWithBlock:^(XYError * _Nonnull error) {
    if (!error) {
      
//      if ([self.manager.superHeartCount integerValue]<1) {
//
//        XYHeartBeatNumberBuyView *VC = [[XYHeartBeatNumberBuyView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//
//        @weakify(self);
//        VC.successBlock = ^(id  _Nonnull item) {
//          @strongify(self);
//          [self sendHeartBeat:model];
//        };
//        [VC show];
//
//      }else{
        XYSendHeartBeatView *VC = [[XYSendHeartBeatView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        VC.texts =self.manager.texts;
        VC.heartNum = self.manager.superHeartCount;
        VC.conf = self.manager.conf;
        VC.model = model;
        VC.block = ^(XYError * _Nonnull error) {
          
          UIAlertController *actionVC=[UIAlertController alertControllerWithTitle:@"发送成功" message:@"对方已收到你的心动表白，是否开始和TA畅聊？" preferredStyle:UIAlertControllerStyleAlert];
          
          UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleCancel handler:nil];
          UIAlertAction *chatAction = [UIAlertAction actionWithTitle:@"去聊天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
            data.conversationID = [NSString stringWithFormat:@"c2c_%@",model.userId];
            data.userID = model.userId.stringValue;
            data.title = model.nickName;
            ChatViewController *chat = [[ChatViewController alloc] init];
            chat.conversationData = data;
            [self cyl_pushViewController:chat animated:YES];
          }];
          [chatAction setValue:ColorHex(@"#F92B5E") forKey:@"titleTextColor"];
          [actionVC addAction:chatAction];
         [actionVC addAction:cancelAction];
          [weak_self presentViewController:actionVC animated:YES completion:nil];
        };
        [VC show];
      }
      
 
//    }
    
  }];
  
  
   
 // };
 // [api start];
  
  
  
  
 
  
  
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
