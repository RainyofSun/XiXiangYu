//
//  XYFirendRequestViewController.m
//  Xiangyu
//
//  Created by Kang on 2021/7/15.
//
//------made in china-------
/**   The code comes frome breakfly
 *
 *       ┏┓　　 ┏┓
 *     ┏━┛┻━━━━┛┻┓
 * 　　┃　  　━　 ┃
 * 　　┃ 　 ^    ^ ┃
 * 　　┃　　　 ┻　 ┃
 * 　　┗━━━━━━━━━┛
 *
 * --------萌萌哒-------
 */
#import "XYFirendRequestViewController.h"
#import "XYIMHeaderTableViewCell.h"
#import "XYFirendTextView.h"
#import <ImSDK/ImSDK.h>
#import "XYProfileDetailAPI.h"
#import "XYTimelineProfileController.h"
#import "XYAddFriendsReqAPI.h"
#import "XYPaymentController.h"
#import "ChatViewController.h"
@interface XYFirendRequestViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *actionBtn;
@property(nonatomic,strong)NSMutableArray *dataSource;

@property(nonatomic,strong)XYFirendTextView *markView;
@property(nonatomic,strong)XYFirendTextView *textView;
@end

@implementation XYFirendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self reshData];
}
#pragma mark - 网络请求
-(void)reshData{
  XYProfileDetailAPI *api = [[XYProfileDetailAPI alloc]initWithUserId:self.profile.userID.numberValue];
  @weakify(self);
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    @strongify(self);
    XYFirendInfoObject *obj = self.dataSource.firstObject;
    obj.infoObj = data;
    [self.tableView reloadData];
  };
  [api start];
  
  
  NSString * selfUserID = [[V2TIMManager sharedInstance] getLoginUser];
  [[V2TIMManager sharedInstance] getUsersInfo:@[selfUserID] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
          if (infoList && infoList.count > 0) {
              V2TIMUserFullInfo * userInfo = [infoList firstObject];
              if (userInfo) {
                  self.textView.textField.text = [NSString stringWithFormat:@"我是%@", userInfo.nickName ? userInfo.nickName : userInfo.userID];
              }
          }
      } fail:^(int code, NSString *desc) {
          
      }];

}
#pragma mark - 界面布局
-(void)newView{
  [self.view addSubview:self.actionBtn];
  [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(self.view).offset(-GK_SAFEAREA_BTM-AutoSize(30));
    make.left.equalTo(self.view).offset(AutoSize(24));
    make.height.mas_equalTo(AutoSize(44));
  }];
  
  
  
  self.view.backgroundColor = ColorHex(XYTextColor_EEEEEE);
  self.tableView = [LSHControl createTableViewWithFrame:CGRectZero style:UITableViewStyleGrouped dataSource:self delegate:self];
  self.tableView.estimatedRowHeight = AutoSize(152);
  [self.view addSubview:self.tableView];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.view);
    make.top.equalTo(self.view).offset(NAVBAR_HEIGHT);
    make.bottom.equalTo(self.actionBtn.mas_top);
  }];
  [self tableViewFooterView];
}
-(void)tableViewFooterView{
  UIView *footerView = [LSHControl viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize(194)) backgroundColor:[UIColor clearColor]];
  self.tableView.tableFooterView = footerView;
  self.textView = [[XYFirendTextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize(97))];
  self.textView.titleLabel.text = @"请填写验证信息";
  [footerView addSubview:self.textView];
  
  self.markView = [[XYFirendTextView alloc]initWithFrame:CGRectMake(0, AutoSize(97), SCREEN_WIDTH, AutoSize(97))];
  self.markView.titleLabel.text = @"请填写备注";
  [footerView addSubview:self.markView];
  

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  XYFirendInfoObject *model = [self.dataSource objectAtIndex:indexPath.section];
    XYIMHeaderTableViewCell *cell = [XYIMHeaderTableViewCell cellWithTableView:tableView indexPath:indexPath];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return AutoSize(8);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.01;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  XYFirendInfoObject *model = [self.dataSource objectAtIndex:indexPath.section];
  if (model.type == 0) {
    XYTimelineProfileController *vc = [[XYTimelineProfileController alloc]init];
    vc.userId = self.profile.userID.numberValue;
    [self.navigationController pushViewController:vc animated:YES];
  }
}

/**
 *发送好友请求，包含请求后的回调
 */
- (void)onSend {
  [self.view endEditing:YES];
  XYShowLoading;
  XYAddFriendsReqAPI *api = [[XYAddFriendsReqAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId destUserId:@(self.profile.userID.integerValue)];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    XYHiddenLoading;
    XYAddFriendsResModel *res = [XYAddFriendsResModel yy_modelWithJSON:data];
    if (res.type.integerValue == 1 && res.price.doubleValue > 0) {
      XYPaymentController *toVC = [[XYPaymentController alloc] init];
      toVC.desc = @"此用户是平台优质相亲会员须支付后方可聊天";
      toVC.money = res.price.stringValue;
      toVC.buyType = @"4";
      toVC.merchantOrderNo = res.orderNo;
      toVC.payWithSuccess = ^{
        [self onAdd];
      };
      [self presentViewController:toVC animated:YES completion:nil];
    } else {
      [self onAdd];
    }
  };
  [api start];
  
}

- (void)onAdd {
  XYShowLoading;
  V2TIMFriendAddApplication *application = [[V2TIMFriendAddApplication alloc] init];
  application.addWording = self.textView.textField.text;
  application.friendRemark = self.markView.textField.text;
  application.userID = self.profile.userID;
  application.addSource = @"iOS";
  application.addType = V2TIM_FRIEND_TYPE_BOTH;
  [[V2TIMManager sharedInstance] addFriend:application succ:^(V2TIMFriendOperationResult *result) {
      NSString *msg = [NSString stringWithFormat:@"%ld", (long)result.resultCode];
      //根据回调类型向用户展示添加结果
      if (result.resultCode == ERR_SVR_FRIENDSHIP_ALLOW_TYPE_NEED_CONFIRM) {
          msg = NSLocalizedString(@"发送成功,等待对方验证", nil);
        [self.navigationController popViewControllerAnimated:YES];
      }
      if (result.resultCode == ERR_SVR_FRIENDSHIP_ALLOW_TYPE_DENY_ANY) {
          msg = NSLocalizedString(@"对方禁止添加", nil);
      }
      if (result.resultCode == 0) {
          msg = NSLocalizedString(@"已添加到好友列表", nil);
        TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
        data.conversationID = [NSString stringWithFormat:@"c2c_%@",self.profile.userID];
        data.userID = self.profile.userID;
        data.title = self.profile.nickName;
        ChatViewController *chat = [[ChatViewController alloc] init];
        chat.conversationData = data;
        [self cyl_pushViewController:chat animated:YES];
      }
      if (result.resultCode == ERR_SVR_FRIENDSHIP_INVALID_PARAMETERS) {
          msg = NSLocalizedString(@"好友已存在", nil);
        TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
        data.conversationID = [NSString stringWithFormat:@"c2c_%@",self.profile.userID];
        data.userID = self.profile.userID;
        data.title = self.profile.nickName;
        ChatViewController *chat = [[ChatViewController alloc] init];
        chat.conversationData = data;
        [self cyl_pushViewController:chat animated:YES];
      }

    XYHiddenLoading;
    XYToastText(msg);
  } fail:^(int code, NSString *desc) {
    XYHiddenLoading;
    XYToastText(desc);
  }];
}

#pragma mark - 导航
-(void)newNav{
  self.gk_navTitle = @"添加好友";
}
-(NSMutableArray *)dataSource{
  if (!_dataSource) {
    _dataSource = [NSMutableArray new];
    [_dataSource addObject:[[XYFirendInfoObject alloc] initWithType:0 infoObj:@{}]];
  }
  return _dataSource;
}
-(UIButton *)actionBtn{
  if (!_actionBtn) {
    _actionBtn = [LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(16) buttonTitle:@"添加好友" buttonTitleColor:ColorHex(XYTextColor_FFFFFF)];
    [_actionBtn roundSize:AutoSize(22)];
    _actionBtn.backgroundColor = ColorHex(@"#F92B5E");
    //_actionBtn.hidden = YES;
    [_actionBtn addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
  }
  return _actionBtn;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
