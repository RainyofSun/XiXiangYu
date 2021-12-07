//
//  XYHomeViewController.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYHomeViewController.h"
#import "XYHomeBaseCell.h"
#import "XYHomeHeaderReusableView.h"
#import "XYHomeFooterReusableView.h"
#import "XYHomeDataManager.h"
#import "XYHomeViewFlowLayout.h"
#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "XYRNBaseViewController.h"
#import "XYRecommendPopView.h"
#import "UIButton+Extension.h"
#import "XYCitySelector.h"
#import "XYHomeSelectedCityViewController.h"
#import "XYHomeFeaturedContentCell.h"
#import "XYHomeTaskCell.h"
#import "XYIndustryCircleController.h"
#import "WebViewController.h"
#import "XYHomeAwardController.h"
#import "ZQSearchViewController.h"
#import "XYHomeSearchResultController.h"
#import "TUIConversationCellData.h"
#import "ChatViewController.h"
#import "XYNearbyPeopleController.h"
#import "FriendRequestViewController.h"
#import "XYFirendRequestViewController.h"
#import "XYBlindProfileController.h"

#import "XYBlindDateViewController.h"
#import "XYProfessConfManager.h"
#import "XYSendHeartBeatView.h"
#import "XYHeartBeatNumberBuyView.h"
#import "XYPlatformService.h"
#import "XYPerfectInformationPopView.h"
//#import "ReactiveObjC/ReactiveObjC.h"

#import "XYPerfectOneStepViewController.h"
@interface XYHomeViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, ZQSearchViewDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, strong) UIImpactFeedbackGenerator *clickFeedback;

@property (strong, nonatomic) XYHomeViewFlowLayout *flowLayout;

@property (strong, nonatomic) XYHomeDataManager *dataManager;
@property(nonatomic,strong)XYProfessConfManager *manager;
@property (weak, nonatomic) UIButton *leftBtn;
@property (assign, nonatomic) BOOL withWhiteTheme;
@property (weak, nonatomic) UIButton *rightBtn;
@property (weak, nonatomic) UITextField *searchBar;

@end

@implementation XYHomeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  if (@available(iOS 10.0, *)) {
      self.clickFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
      [self.clickFeedback prepare];
  }
  self.view.backgroundColor = ColorHex(XYThemeColor_F);
  [self.view addSubview:self.collectionView];
  
  [self setupNavBar];
  
  [self displayGoldcoin];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchData) name:@"kNotificationLogin" object:nil];
  
  [self fetchData];
}
-(void)viewDidDisappear:(BOOL)animated{
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self ];
}
#pragma mark - action
- (void)didClickOptions:(NSNumber *)index {
  if (index.integerValue == 0) {
    
  // XYPerfectOneStepViewController *vc = [[XYPerfectOneStepViewController alloc] init];
  // [self cyl_pushViewController:vc animated:YES];
////    return;
  XYBlindDateViewController *vc = [[XYBlindDateViewController alloc] init];
  vc.hidesBottomBarWhenPushed = YES;
   [self cyl_pushViewController:vc animated:YES];
  }else if (index.integerValue == 1) {
    
    [[XYUserService service] getUserInfoWithUserId:[XYUserService service].fetchLoginUser.userId block:^(BOOL success, NSDictionary *info) {
      
      XYPerfectProfileModel *model = [XYPerfectProfileModel yy_modelWithJSON:info];
      if ( model.oneIndustry && model.twoIndustry && model.twoIndustry.length>1) {
        
      
        XYIndustryCircleController *vc = [[XYIndustryCircleController alloc] init];
        [self cyl_pushViewController:vc animated:YES];
        
      }else{
        XYPerfectInformationPopView *popV = [[XYPerfectInformationPopView alloc]initWithFrame:CGRectMake(AutoSize(40), (SCREEN_HEIGHT-AutoSize(336))/2.0, SCREEN_WIDTH-AutoSize(80), AutoSize(336))];
        popV.descLabel.text = @"完善行业后，平台将为您推荐同行业老乡";
        popV.successBlock = ^(id  _Nonnull item) {
          XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"UserInfo"}];
          [self cyl_pushViewController:vc animated:YES];
        };
        [popV show];
      }
      
      
      
      
//         if ([[info objectForKey:@"status"] integerValue]!=2) {
//
//
//           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未实名认证" preferredStyle:UIAlertControllerStyleAlert];
//                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//                    [alert addAction:[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                      XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"Auth"}];
//                      [self cyl_pushViewController:vc animated:YES];
//                      //resolve(@{@"type":@"2"});
//                    }]];
//                        // 弹出对话框
//                        [self  presentViewController:alert animated:true completion:nil];
//
//           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未完善资料" preferredStyle:UIAlertControllerStyleAlert];
//           [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//           [alert addAction:[UIAlertAction actionWithTitle:@"去完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//             resolve(@{@"type":@"2"});
//           }]];
             // 弹出对话框
//               [[weakSelf getCurrentVC] presentViewController:alert animated:true completion:nil];
     //  }else {
//           resolve(@{@"type":@"1"});
         
        
     //  }
    }];
    
  
    //CarNeedSearch
    //CarNeedSearch
  }else if (index.integerValue == 4) {
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"LookDemand",@"type":@"1"}];
    vc.hidesBottomBarWhenPushed = YES;
    [self cyl_pushViewController:vc animated:YES];
  }else if (index.integerValue == 6) {
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"LookDemand",@"type":@"2"}];
    vc.hidesBottomBarWhenPushed = YES;
    [self cyl_pushViewController:vc animated:YES];
  }else if (index.integerValue == 5) {
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"LookDemand",@"type":@"3"}];
    vc.hidesBottomBarWhenPushed = YES;
    [self cyl_pushViewController:vc animated:YES];
  }else if (index.integerValue == 7) {
    
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"LookActivity"}];
    vc.hidesBottomBarWhenPushed = YES;
    [self cyl_pushViewController:vc animated:YES];
  }else if (index.integerValue == 2) {
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"CarNeedSearch",@"type":@"4"}];
    vc.hidesBottomBarWhenPushed = YES;
    [self cyl_pushViewController:vc animated:YES];
  }else if (index.integerValue == 3) {
    XYUserInfo *user = [[XYUserService service] fetchLoginUser];
    
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"Information",@"name":user.city}];
    vc.hidesBottomBarWhenPushed = YES;
    [self cyl_pushViewController:vc animated:YES];
  }
}

- (void)doTask:(NSNumber *)index {
  [self.dataManager receiveTaskWithIndex:index.integerValue block:^(XYError *error) {
    if (error) {
      XYToastText(error.msg);
    } else {
      [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index.integerValue inSection:self.collectionView.numberOfSections - 1]]];
    }
  }];
}
// 首页点击发送表白
-(void)sendHeartWithObj:(NSDictionary *)obj{
  
  [[XYPlatformService shareService] fetchOnlineSwitchWithBlock:^(BOOL status) {
    if (!status) {
      
  @weakify(self);
  [self.manager releaseProfessConfWithBlock:^(XYError * _Nonnull error) {
    if (!error) {
//      if ([weak_self.manager.superHeartCount integerValue]<1) {
//
//        XYHeartBeatNumberBuyView *VC = [[XYHeartBeatNumberBuyView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        VC.conf = weak_self.manager.conf;
//
//        VC.successBlock = ^(id  _Nonnull item) {
//
//          [weak_self sendHeartWithObj:obj];
//        };
//        [VC show];
//
//      }else{
        XYSendHeartBeatView *VC = [[XYSendHeartBeatView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        VC.texts =weak_self.manager.texts;
        VC.heartNum = weak_self.manager.superHeartCount;
        VC.model = [XYBlindDataItemModel yy_modelWithJSON:obj];
        VC.conf = weak_self.manager.conf;
        VC.block = ^(XYError * _Nonnull error) {
          
          UIAlertController *actionVC=[UIAlertController alertControllerWithTitle:@"发送成功" message:@"对方已收到你的心动表白，是否开始和TA畅聊？" preferredStyle:UIAlertControllerStyleAlert];
          
          UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleCancel handler:nil];
          UIAlertAction *chatAction = [UIAlertAction actionWithTitle:@"去聊天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
            data.conversationID = [NSString stringWithFormat:@"c2c_%@",obj[@"userId"]];
            data.userID = [NSString stringWithFormat:@"%@",obj[@"userId"]];
            data.title = obj[@"nickName"];
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
    }else{
      TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
      data.conversationID = [NSString stringWithFormat:@"c2c_%@",obj[@"userId"]];
      data.userID = obj[@"userId"];
      data.title = obj[@"nickName"];
      ChatViewController *chat = [[ChatViewController alloc] init];
      chat.conversationData = data;
      [self cyl_pushViewController:chat animated:YES];
    }
    
  }];
}
- (void)followUserWithId:(NSNumber *)userId {
  [self.dataManager followUserId:userId block:^(NSUInteger index, NSDictionary *info, XYError *error) {
    if (error) {
      XYToastText(error.msg);
    } else {
      XYHomeFeaturedContentCell *cell = (XYHomeFeaturedContentCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:2]];
      [cell reloadIndex:index withItem:info];
    }
  }];
}

- (void)leftBarButtonClick {
  XYHomeSelectedCityViewController *selector = [[XYHomeSelectedCityViewController alloc] init];
  selector.selectedBlock = ^(XYAddressItem *item) {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.titleLabel.font = AdaptedMediumFont(14);
    [leftBtn setImage:[UIImage imageNamed:self.withWhiteTheme ? @"arrow_8_bul" : @"arrow_8_white"] forState:UIControlStateNormal];
    [leftBtn setTitleColor:self.withWhiteTheme ? ColorHex(XYTextColor_222222) : ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    [leftBtn setTitle:item.name ?: @"" forState:UIControlStateNormal];
    CGFloat width = [leftBtn.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 44)].width;
    leftBtn.frame = CGRectMake(0, 0, width+10, 44);
    [leftBtn horizontalCenterTitleAndImage:2];
    self.leftBtn = leftBtn;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.gk_navLeftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)]],leftItem];
    [self switchCityWithItem:item];
  };
  [self cyl_pushViewController:selector animated:YES];
}

- (void)rightBarButtonClick {
  XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"Message"}];
  vc.hidesBottomBarWhenPushed = YES;
  [self cyl_pushViewController:vc animated:YES];
}

- (void)didClickFriends {
  XYNearbyPeopleController *vc = [[XYNearbyPeopleController alloc] init];
  [self cyl_pushViewController:vc animated:YES];
}

- (void)didClickVideos {
  [self.cyl_tabBarController setSelectedIndex:2];
}

- (void)didClickDynamics {
  [self.cyl_tabBarController setSelectedIndex:1];
}

- (void)didClickCycleScrollViewWithParam:(NSDictionary *)param {

  NSNumber *skipType = param[@"skipType"];
  if (![skipType toSafeValueOfClass:[NSNumber class]]) return;
  
  NSString *buParam = param[XYHome_JumpLink];
  if (skipType.integerValue == 1) {
    WebViewController *web = [[WebViewController alloc] init];
    web.urlStr = buParam;
    [self cyl_pushViewController:web animated:YES];
  } else if (skipType.integerValue == 2) {
    TUIConversationCellData *conversationData = [[TUIConversationCellData alloc] init];
    conversationData.groupID = buParam;
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.conversationData = conversationData;
    [self cyl_pushViewController:chat animated:YES];
  }
}

- (void)clickTipsWithRouter:(NSString *)router {
  if ([router isEqualToString:@"task"]) {
   
    return;
  }
  
  if ([router isEqualToString:@"blind"]) {
//    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"BlindDate"}];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self cyl_pushViewController:vc animated:YES];
    XYBlindDateViewController *vc = [[XYBlindDateViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self cyl_pushViewController:vc animated:YES];
    return;
  }
}

- (void)blindDetailWithItem:(NSDictionary *)item {
  XYBlindProfileController *vc = [[XYBlindProfileController alloc] init];
  vc.blindId = item[@"id"];
  vc.userId = item[@"userId"];
  [self cyl_pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView.contentOffset.y >= 70) {
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navBackgroundColor = ColorHex(XYThemeColor_B);
    self.withWhiteTheme = YES;
    self.view.backgroundColor = ColorHex(XYThemeColor_F);
    self.collectionView.backgroundColor = ColorHex(XYThemeColor_F);
  } else {
    self.gk_navBackgroundColor = ColorHex(XYThemeColor_A);
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.withWhiteTheme = NO;
    self.view.backgroundColor = ColorHex(XYThemeColor_A);
    self.collectionView.backgroundColor = ColorHex(XYThemeColor_A);
  }
  [self.leftBtn setImage:[UIImage imageNamed:self.withWhiteTheme ? @"arrow_8_bul" : @"arrow_8_white"] forState:UIControlStateNormal];
  [self.leftBtn setTitleColor:self.withWhiteTheme ? ColorHex(XYTextColor_222222) : ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
  [self.rightBtn setImage:[UIImage imageNamed:self.withWhiteTheme ? @"icon_22_massage2" : @"icon_22_massage"] forState:UIControlStateNormal];
  self.searchBar.backgroundColor = self.withWhiteTheme ? ColorHex(XYThemeColor_F) : [UIColor colorWithWhite:1.0 alpha:0.9];
  
}
#pragma mark - data

- (void)fetchData {
  @weakify(self);
  

  
  
  [self.dataManager fetchViewDataWithBlock:^(BOOL ret) {}];
  
  [[XYUserService service] updateNoNeedPerfectBlock:^(BOOL success, NSDictionary *info) {
    [self.dataManager sendLocationBatchAPIRequestsWithLocationHandler:^(NSString *cityName) {
      UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [leftBtn addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
      leftBtn.titleLabel.font = AdaptedMediumFont(14);
      [leftBtn setImage:[UIImage imageNamed:self.withWhiteTheme ? @"arrow_8_bul" : @"arrow_8_white"] forState:UIControlStateNormal];
      [leftBtn setTitleColor:self.withWhiteTheme ? ColorHex(XYTextColor_222222) : ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
      [leftBtn setTitle:cityName ?: @"" forState:UIControlStateNormal];
      CGFloat width = [leftBtn.titleLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, 44)].width;
      leftBtn.frame = CGRectMake(0, 0, width+10 ?: 60, 44);
      [leftBtn horizontalCenterTitleAndImage:2];
      UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
      self.leftBtn = leftBtn;
      self.gk_navLeftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)]],leftItem];
    } pageDataBlock:^{
      [weak_self.collectionView reloadData];
    }];
  }];
  
  [self.dataManager fetchTaskListDataWithBlock:^(BOOL needRefresh) {
    if (needRefresh) {
      [weak_self.collectionView reloadData];
    }
  }];
  
  [self.dataManager fetchBannerDataWithBlock:^(BOOL needRefresh) {
    if (needRefresh) {
      [weak_self.collectionView reloadData];
    }
  }];
  
  [self.dataManager updatePushToken];
}

- (void)switchCityWithItem:(XYAddressItem *)item {
  @weakify(self);
  XYShowLoading;
  [self.dataManager switchLocationBatchAPIRequestsWithItem:item pageDataBlock:^{
    XYHiddenLoading;
    [weak_self.collectionView reloadData];
  }];
}

- (void)displayGoldcoin {
  @weakify(self);
  NSString *preDay = [[NSDate date] stringWithFormat:XYYTDDateFormatterName];
  NSString *currentDay = [[NSUserDefaults standardUserDefaults] valueForKey:XYHomeRecommendFriendsViewKey];
  if ([[XYUserService service] fetchLoginUser].isFirst.integerValue == 1) {
    XYHomeAwardController *toVC = [[XYHomeAwardController alloc] init];
    toVC.gold = [[XYUserService service] fetchLoginUser].goldBalance;
    toVC.exchangeBlock = ^{
      XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"Mall"}];
      [self cyl_pushViewController:vc animated:YES];
    };
    toVC.dismissBlock = ^{
      if (!preDay || !preDay.isNotBlank || ![preDay isEqualToString:currentDay]) {
        [self.dataManager fetchInterestDataWithBlock:^(NSArray<XYInterestItem *> *data) {
          if (data && data.count > 0) {
            [weak_self popRecommendWithData:data];
          }
        }];
      }
    };
    [self presentViewController:toVC animated:YES completion:nil];
  } else {
    if (!preDay || !preDay.isNotBlank || ![preDay isEqualToString:currentDay]) {
      [self.dataManager fetchInterestDataWithBlock:^(NSArray<XYInterestItem *> *data) {
        if (data && data.count > 0) {
          [weak_self popRecommendWithData:data];
        }
      }];
    }
  }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  NSArray *hots = @[@"热门",@"热门热门",@"热门热门热门"];

  
  ZQSearchViewController *vc = [[ZQSearchViewController alloc] initSearchViewWithHotDatas:hots];
  vc.closeFuzzyTable = YES;
  vc.delegate = self;
  vc.placeholder = @"搜索老乡、活动、动态";
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  nav.modalPresentationStyle = UIModalPresentationFullScreen;
  [self presentViewController:nav animated:NO completion:nil];
  return NO;
}

- (void)searchConfirmResultWithKeyString:(NSString *)keyString resultController:(UIViewController *)resultController {
  XYShowLoading;
  [self.dataManager searchWithWords:keyString block:^(XYHomeSearchResultModel *data) {
    XYHiddenLoading;
    XYHomeSearchResultController *resultVc = [[XYHomeSearchResultController alloc] init];
    resultVc.keywords = keyString;
    resultVc.searchData = data;
    [resultController cyl_pushViewController:resultVc animated:YES];
  }];
}

#pragma mark - UI
- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_navBackgroundColor = ColorHex(XYThemeColor_A);
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  self.gk_statusBarStyle = UIStatusBarStyleLightContent;
  //self.gk_navItemLeftSpace = 16;
  
  UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [rightBtn setImage:[UIImage imageNamed:@"icon_22_massage"] forState:UIControlStateNormal];
  [rightBtn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
  self.rightBtn = rightBtn;
  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
  
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
  UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_14_search"]];
  imgView.frame = CGRectMake(12, 8, 14, 14);
  [view addSubview:imgView];
  
  UITextField *searchBar = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 140, 30)];
  searchBar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索老乡、活动、动态" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],NSForegroundColorAttributeName : ColorHex(@"#B4B4B4")}];
  searchBar.layer.cornerRadius = 15.f;
  searchBar.font = [UIFont systemFontOfSize:14];
  searchBar.leftView = view;
  searchBar.leftViewMode = UITextFieldViewModeAlways;
  searchBar.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
  searchBar.delegate = self;
  self.searchBar = searchBar;
  self.gk_navTitleView = searchBar;
}

- (void)popRecommendWithData:(NSArray<XYInterestItem *> *)data {
  if (!data || data.count == 0) return;
  
  NSString *currentDay = [[NSDate date] stringWithFormat:XYYTDDateFormatterName];
  [[NSUserDefaults standardUserDefaults] setValue:currentDay forKey:XYHomeRecommendFriendsViewKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  XYRecommendPopView *popView = [[XYRecommendPopView alloc] init];
  popView.addBlock = ^(XYInterestItem *item, BOOL group) {
    if (group) {
      TUIConversationCellData *conversationData = [[TUIConversationCellData alloc] init];
      conversationData.groupID = item.relationId;
      ChatViewController *chat = [[ChatViewController alloc] init];
      chat.conversationData = conversationData;
      [self cyl_pushViewController:chat animated:YES];
    } else {
//      XYShowLoading;
//      if (relationId.isNotBlank) {
//        // 聊天
//        [[V2TIMManager sharedInstance] getUsersInfo:@[relationId] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
//          XYHiddenLoading;
          
          
          
          TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
          data.conversationID = [NSString stringWithFormat:@"c2c_%@",item.relationId];
          data.userID = [NSString stringWithFormat:@"%@",item.relationId];
          data.title = item.name;
          ChatViewController *chat = [[ChatViewController alloc] init];
          chat.conversationData = data;
          [self cyl_pushViewController:chat animated:YES];
          
          
          
         // XYFirendRequestViewController *frc = [[XYFirendRequestViewController alloc] init];
         // frc.profile = infoList.firstObject;
         // [self cyl_pushViewController:frc animated:YES];
//        } fail:^(int code, NSString *msg) {
//          XYHiddenLoading;
//          XYToastText(msg);
//        }];
     // }
    }
  };
  popView.data = data;
  [popView showOnView:self.view];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return self.dataManager.models.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataManager.models[section].rowInfo.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    XYHomeRowInfo *info = self.dataManager.models[indexPath.section].rowInfo;
    if (!info.cellClass.isNotBlank) {
        return nil;
    }
    XYHomeBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:info.cellClass forIndexPath:indexPath];
    cell.item = info.data[indexPath.row];
    return cell;

}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
      XYHomeSectionInfo *info = self.dataManager.models[indexPath.section];
      if (!info.headerClass.isNotBlank) {
          return nil;
      }
      XYHomeHeaderReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:info.headerClass forIndexPath:indexPath];
      reusableView.imageName = info.picURL;
      reusableView.title = info.title;
      reusableView.message = info.subtitle;
      reusableView.router = info.router;
      @weakify(self);
      reusableView.tipsClickBlock = ^(NSString *router) {
        [weak_self clickTipsWithRouter:router];
      };
      return reusableView;
  } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
      XYHomeSectionInfo *info = self.dataManager.models[indexPath.section];
      if (!info.footerHeight.isNotBlank) {
          return nil;
      }
      XYHomeFooterReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:info.footerClass forIndexPath:indexPath];
      return reusableView;
      
  } else {
      return nil;
  }

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    [self didClickFriends];
    return;
  }
  
   if (indexPath.section == self.collectionView.numberOfSections - 1) {
    @weakify(self);
    [self.dataManager receiveTaskWithIndex:indexPath.row block:^(XYError *error) {
      if (error) {
        XYToastText(error.msg);
      } else {
        [weak_self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
      }
    }];
  }
}
#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSNumber *cellHeight = self.dataManager.models[indexPath.section].rowInfo.cellHeight;
  NSString *cellClass = self.dataManager.models[indexPath.section].rowInfo.cellClass;
  if (indexPath.section == 0) {
      return CGSizeMake(kScreenWidth, cellHeight.floatValue);
    } else if (indexPath.section == 1) {
//      CGFloat width = [self fixSlitWithColCount:4 index:indexPath.row];
      return CGSizeMake(kScreenWidth, cellHeight.floatValue);
    } else if (indexPath.section == 2) {
      if ([cellClass isEqualToString:@"XYHomeTaskCell"]) {
        NSDictionary *info = self.dataManager.models[indexPath.section].rowInfo.data[indexPath.item];
        NSNumber *expandHeight = info[@"expandHeight"];
        return CGSizeMake(kScreenWidth, cellHeight.floatValue + expandHeight.floatValue);
      }
      return CGSizeMake(kScreenWidth, cellHeight.floatValue);
    } else if (indexPath.section == 3) {
      if ([cellClass isEqualToString:@"XYHomeTaskCell"]) {
        NSDictionary *info = self.dataManager.models[indexPath.section].rowInfo.data[indexPath.item];
        NSNumber *expandHeight = info[@"expandHeight"];
        return CGSizeMake(kScreenWidth, cellHeight.floatValue + expandHeight.floatValue);
      }
        return CGSizeMake(kScreenWidth, cellHeight.floatValue);
    } else {
      if ([cellClass isEqualToString:@"XYHomeTaskCell"]) {
        NSDictionary *info = self.dataManager.models[indexPath.section].rowInfo.data[indexPath.item];
        NSNumber *expandHeight = info[@"expandHeight"];
        return CGSizeMake(kScreenWidth, cellHeight.floatValue + expandHeight.floatValue);
      }
      return CGSizeMake(kScreenWidth, cellHeight.floatValue);
    }
}

- (CGFloat)fixSlitWithColCount:(NSUInteger)colCount index:(NSUInteger)index {
  NSUInteger screen_W = kScreenWidth - 44;
  NSUInteger ceilWidth = screen_W / colCount;
  NSUInteger remainder = screen_W % colCount;
  if (remainder == 0) {
    return ceilWidth;
  } else {
    if (index % colCount < remainder) {
      return ceilWidth + 1;
    } else {
      return ceilWidth;
    }
  }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    XYHomeSectionInfo *info = self.dataManager.models[section];
    if (!info.headerClass.isNotBlank) {
        return CGSizeZero;
    }
    
    return CGSizeMake(kScreenWidth, info.headerHeight.floatValue);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    XYHomeSectionInfo *info = self.dataManager.models[section];
    if (!info.footerClass.isNotBlank) {
        return CGSizeZero;
    }
    
    return CGSizeMake(kScreenWidth, info.footerHeight.floatValue);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    XYHomeRowInfo *info = self.dataManager.models[section].rowInfo;
    if (!info.cellClass.isNotBlank) {
        return 0;
    }
    
    return info.minHSpacing.floatValue;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    XYHomeRowInfo *info = self.dataManager.models[section].rowInfo;
    if (!info.cellClass.isNotBlank) {
        return 0;
    }
    
    return info.minVSpacing.floatValue;
}

- (XYHomeViewFlowLayout *)flowLayout {
  if (!_flowLayout) {
    _flowLayout = [[XYHomeViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
  }
  return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
      _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, kScreenWidth, self.view.XY_height - TABBAR_HEIGHT - NAVBAR_HEIGHT) collectionViewLayout:self.flowLayout];
      _collectionView.showsVerticalScrollIndicator = NO;
      _collectionView.backgroundColor = ColorHex(XYThemeColor_F);
      _collectionView.dataSource = self;
      _collectionView.delegate = self;
      [_collectionView registerClass:NSClassFromString(@"XYHomeHeaderReusableView") forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"XYHomeHeaderReusableView"];
        [_collectionView registerClass:NSClassFromString(@"XYHomeFooterReusableView") forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"XYHomeFooterReusableView"];
      [_collectionView registerClass:NSClassFromString(@"XYHomeFeaturedContentCell") forCellWithReuseIdentifier:@"XYHomeFeaturedContentCell"];
      [_collectionView registerClass:NSClassFromString(@"XYHomeHeaderCell") forCellWithReuseIdentifier:@"XYHomeHeaderCell"];
      [_collectionView registerClass:NSClassFromString(@"XYHomeOptionCell") forCellWithReuseIdentifier:@"XYHomeOptionCell"];
      [_collectionView registerClass:NSClassFromString(@"XYHomeSlideshowCell") forCellWithReuseIdentifier:@"XYHomeSlideshowCell"];
      [_collectionView registerClass:NSClassFromString(@"XYHomeTaskCell") forCellWithReuseIdentifier:@"XYHomeTaskCell"];
    }
    return _collectionView;
}

- (XYHomeDataManager *)dataManager {
  if (!_dataManager) {
    _dataManager = [[XYHomeDataManager alloc] init];
    _dataManager.target = self;
  }
  return _dataManager;
}
-(XYProfessConfManager *)manager{
  if (!_manager) {
    _manager = [[XYProfessConfManager alloc] init];
  }
  return _manager;
}
@end
