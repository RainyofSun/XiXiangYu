//
//  XYProfileViewController.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/6/3.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYProfileViewController.h"
#import "XYBaseTableView.h"
#import "XYProfileDataManager.h"
#import "XYProfileHeaderView.h"
#import "XYRNBaseViewController.h"
#import "XYUserService.h"
#import "XYLoginMobileViewController.h"
#import "ContactsController.h"
#import "XYMyReleaseVC.h"
#import "XYMyDynamicsListController.h"
#import "XYTimelineVideoController.h"
#import "XYLikesVideoController.h"
#import "XYMyVideosContainer.h"
#import "WebViewController.h"
#import "XYSearchVideoContainer.h"
#import "XYHeartProfessViewController.h"
#import "XYMyWalletViewController.h"

#import "XYMainViewController.h"
#import "XYBlindProfileController.h"

@interface XYProfileViewController () <XYBaseTableViewDelegate>

@property (nonatomic,strong) XYBaseTableView *tableView;

@property (nonatomic,strong) XYProfileDataManager *dataManager;

@end

@implementation XYProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = ColorHex(XYThemeColor_B);
  
  [self setupSubViews];
  
  [self setupNavBar];
  
  [self.dataManager fetchDataWithBlock:^(BOOL ret) {
    [self.tableView reloadData];
  }];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self pullDownToRefreshAction];
}

- (void)setupNavBar {
  self.gk_navBarAlpha = 0;
  self.gk_navLineHidden = YES;
  self.gk_statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setupSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.right.equalTo(self.view);
      make.bottom.equalTo(self.view).offset(-SafeAreaTabbarBottom());
    }];
}

#pragma - action
//好友
-(void)checkGift{
  [self giftAction];
}
//心动
-(void)checkHeart{
  XYHeartProfessViewController *likesVc = [[XYHeartProfessViewController alloc] init];
  [self cyl_pushViewController:likesVc animated:YES];
  //
}
/*- (void)checkFriends {
  if ([[XYUserService service] isLogin]) {

    ContactsController *contactsVc = [[ContactsController alloc] init];
    [self cyl_pushViewController:contactsVc animated:YES];
  }else {

      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:nav animated:YES completion:nil];
  }
//  XYMainViewController *vc = [[XYMainViewController alloc] init];
//  [self cyl_pushViewController:vc animated:YES];
}*/

//关注
- (void)checkAttention {
  
  if ([[XYUserService service] isLogin]) {
    
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"Fans",@"type":@"2"}];
    [self cyl_pushViewController:vc animated:YES];
  }else {
    
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:nav animated:YES completion:nil];
  }
}

//粉丝
- (void)checkFans {
  
  if ([[XYUserService service] isLogin]) {
    
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"Fans",@"type":@"1"}];
    [self cyl_pushViewController:vc animated:YES];
  }else {
    
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:nav animated:YES completion:nil];
  }
}

//点赞
- (void)checkLikes {
  XYLikesVideoController *likesVc = [[XYLikesVideoController alloc] init];
  [self cyl_pushViewController:likesVc animated:YES];
}

//实名认证
- (void)certification {
  if ([[XYUserService service] isLogin]) {
    
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"Auth"}];
    [self cyl_pushViewController:vc animated:YES];
  }else {
    
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:nav animated:YES completion:nil];
  }
}

//我的短视频
- (void)shortVideo {
  XYMyVideosContainer *video = [[XYMyVideosContainer alloc] init];
  [self cyl_pushViewController:video animated:YES];
}

//我的动态
- (void)myTidings {
  XYMyDynamicsListController *attentionVc = [[XYMyDynamicsListController alloc] init];
  attentionVc.needRefresh = YES;
  [self cyl_pushViewController:attentionVc animated:YES];
}
 
//待发货
- (void)waitDeliverAction {
  
  if ([[XYUserService service] isLogin]) {
    
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"MyOrder",@"type" : @"1"}];
    [self cyl_pushViewController:vc animated:YES];
  }else {
    
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:nav animated:YES completion:nil];
  }
}

//待收货
- (void)waitReceivingAction {
  if ([[XYUserService service] isLogin]) {
    
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"MyOrder",@"type" : @"2"}];
    [self cyl_pushViewController:vc animated:YES];
  }else {
    
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:nav animated:YES completion:nil];
  }
}

//已完成
- (void)completedAction {
  if ([[XYUserService service] isLogin]) {
    
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"MyOrder",@"type" : @"3"}];
    [self cyl_pushViewController:vc animated:YES];
  }else {
    
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:nav animated:YES completion:nil];
  }
}

//乡币
- (void)xiangbiAction {
  if ([[XYUserService service] isLogin]) {
    
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"CountryBill"}];
    [self cyl_pushViewController:vc animated:YES];
  } else {
    
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:nav animated:YES completion:nil];
  }
}

//商城
- (void)storeAction {
  
  if ([[XYUserService service] isLogin]) {
    
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"Mall"}];
    [self cyl_pushViewController:vc animated:YES];
  }else {
    
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:nav animated:YES completion:nil];
  }
}
// 钱包
-(void)blanceAction{
  //
  XYMyWalletViewController *vc = [[XYMyWalletViewController alloc] init];
  [self cyl_pushViewController:vc animated:YES];
}
//礼物
- (void)giftAction {
  if ([[XYUserService service] isLogin]) {
    
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"Gift"}];
    [self cyl_pushViewController:vc animated:YES];
  }else {
    
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:nav animated:YES completion:nil];
  }
  
}

//个人资料
- (void)checkProfile {
  if ([[XYUserService service] isLogin]) {
    
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"UserInfo"}];
    [self cyl_pushViewController:vc animated:YES];
  }else {
    
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:nav animated:YES completion:nil];
  }
}

#pragma mark - XYBaseTableViewDelegate
- (void)pullDownToRefreshAction {
  @weakify(self);
  [self.dataManager fetchUserInfoWithBlock:^(BOOL needRefresh, XYError *error) {
    @strongify(self);
    [self.tableView stopRefreshingAnimation];
    if (error) {
      XYToastText(error.msg);
    }
    
    if (needRefresh) {
        [self.tableView reloadData];
    }
  }];
}

- (UIView *)footerViewForSectionObject:(XYBaseTableViewSectionObject *)sectionObject atSection:(NSInteger)section {
  return [UIView new];
}

- (CGFloat)footerHeightForSectionObject:(XYBaseTableViewSectionObject *)sectionObject atSection:(NSInteger)section {
  return 8;
}


#pragma mark - getter
- (XYBaseTableView *)tableView {
    if (!_tableView) {
      _tableView = [[XYBaseTableView alloc] init];
      _tableView.backgroundColor = ColorHex(XYThemeColor_F);
      _tableView.isNeedPullDownToRefreshAction = YES;
      _tableView.XYDelegate = self;
      _tableView.XYDataSource = self.dataManager;
      if (@available(iOS 11.0, *)) {
      _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      }else {
      self.automaticallyAdjustsScrollViewInsets = NO;
      }
      _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (XYProfileDataManager *)dataManager {
    if (!_dataManager) {
      _dataManager = [[XYProfileDataManager alloc] init];
      _dataManager.target = self;
    }
    return _dataManager;
}

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
   
  if (![[XYUserService service] isLogin]) {
      UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
      [self presentViewController:nav animated:YES completion:nil];
    return;
  }
  
  NSUInteger section = self.dataManager.isAddedDynamicModule ? 3 : 1;
  
  if (indexPath.section == section && indexPath.row == 5) {
      
      XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"MySet"}];
      [self cyl_pushViewController:vc animated:YES];
  }else if (indexPath.section == section && indexPath.row == 3) {
    
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"Feedback"}];
    [self cyl_pushViewController:vc animated:YES];
  }else if (indexPath.section == section && indexPath.row == 2) {
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"ADRelease"}];
    [self cyl_pushViewController:vc animated:YES];
  }else if (indexPath.section == section && indexPath.row == 0) {
    
    XYMyReleaseVC *vc = [[XYMyReleaseVC alloc] init];
    [self cyl_pushViewController:vc animated:YES];
  }else if (indexPath.section == section && indexPath.row == 1) {
    XYUserInfo *user = [[XYUserService service] fetchLoginUser];

    WebViewController *vc = [[WebViewController alloc] init];
    vc.urlStr = [NSString stringWithFormat:@"%@/h5/invite.html?userid=%@",XY_SERVICE_HOST,user.userId];
    vc.title = @"我的邀请";
    [self cyl_pushViewController:vc animated:YES];
  }else if (indexPath.section == section && indexPath.row == 4) {
    XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"QAList" ,@"type":@"1"}];
    [self cyl_pushViewController:vc animated:YES];
  }
}
@end
