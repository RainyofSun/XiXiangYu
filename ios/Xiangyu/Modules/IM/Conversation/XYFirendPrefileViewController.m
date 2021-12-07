//
//  XYFirendPrefileViewController.m
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
#import "XYFirendPrefileViewController.h"
#import "XYImNextTableViewCell.h"
#import "XYIMHeaderTableViewCell.h"
#import "XYIMSwitchTableViewCell.h"

#import "XYProfileDetailAPI.h"
#import "XYTimelineProfileController.h"
#import "XYFirendRequestViewController.h"
#import "XYReportView.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "TTextEditController.h"

#import "TUILocalStorage.h"
@TCServiceRegister(TUIFriendProfileControllerServiceProtocol, XYFirendPrefileViewController)
@interface XYFirendPrefileViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *actionBtn;
@property(nonatomic,strong)NSMutableArray *dataSource;

@property (nonatomic, strong) XYReportView * reportView;
@end

@implementation XYFirendPrefileViewController
@synthesize friendProfile;
- (void)willMoveToParentViewController:(nullable UIViewController *)parent{
    [super willMoveToParentViewController:parent];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  if (self.friendProfile) {
    self.userFullInfo = self.friendProfile.userFullInfo;
  }
  
  
    [self newNav];
    [self newView];
  
  //
    [self reshData];
}
#pragma mark - 网络请求
-(void)reshData{
  XYProfileDetailAPI *api = [[XYProfileDetailAPI alloc]initWithUserId:self.userFullInfo.userID.numberValue];
  @weakify(self);
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    @strongify(self);
    XYFirendInfoObject *obj = self.dataSource.firstObject;
    obj.infoObj = data;
    [self.tableView reloadData];
  };
  [api start];

  //return;
  
  

  
 // if (self.actionType == PCA_ADD_FRIEND) {
    [[V2TIMManager sharedInstance] checkFriend:self.userFullInfo.userID succ:^(V2TIMFriendCheckResult *result) {
        if (result.relationType == V2TIM_FRIEND_RELATION_TYPE_IN_MY_FRIEND_LIST || result.relationType == V2TIM_FRIEND_RELATION_TYPE_BOTH_WAY) {
            //return;
          
          
          [[V2TIMManager sharedInstance] getFriendsInfo:@[self.userFullInfo.userID] succ:^(NSArray<V2TIMFriendInfoResult *> *resultList) {
            self.friendProfile = resultList.firstObject.friendInfo;
            
            [self.dataSource addObject:[[XYFirendInfoObject alloc] initWithType:1 title:@"设置备注" value:self.friendProfile.friendRemark]];
            
            [self.dataSource addObject:[[XYFirendInfoObject alloc] initWithType:2 title:@"举报该用户" value:@""]];
            
            [self.dataSource addObject:[[XYFirendInfoObject alloc] initWithType:3 title:@"置顶聊天" switchOn:NO]];
            
            if ([[[TUILocalStorage sharedInstance] topConversationList] containsObject:[NSString stringWithFormat:@"c2c_%@",self.userFullInfo.userID]]) {
              
              XYFirendInfoObject *obj = [self.dataSource objectAtIndex:3];
              obj.switchOn = YES;
              [self.tableView reloadData];
               // data.on = YES;
            }
            
            [self tableViewFooterView];
            [self.tableView reloadData];
            
            
          } fail:nil];
          
          
        
          
          
     //     [self.dataSource addObject:[[XYFirendInfoObject alloc] initWithType:4 title:@"屏蔽此人" switchOn:NO]];
          
          
         
        }else{
          
          self.actionBtn.hidden = NO;
          
          [self.dataSource addObject:[[XYFirendInfoObject alloc] initWithType:2 title:@"举报该用户" value:@""]];
          
          //[self.dataSource addObject:[[XYFirendInfoObject alloc] initWithType:1 title:@"设置备注" value:@""]];
          
        //  [self.dataSource addObject:[[XYFirendInfoObject alloc] initWithType:4 title:@"屏蔽此人" switchOn:NO]];
          
        }

        [self.tableView reloadData];
                
    } fail:^(int code, NSString *desc) { }];
  
 // }
  
//  [self.dataSource addObject:[[XYFirendInfoObject alloc] initWithType:1 title:@"设置备注" value:@""]];
//
//  [self.dataSource addObject:[[XYFirendInfoObject alloc] initWithType:2 title:@"举报该用户" value:@""]];
//
//  [self.dataSource addObject:[[XYFirendInfoObject alloc] initWithType:3 title:@"置顶聊天" switchOn:NO]];
//
//  [self.dataSource addObject:[[XYFirendInfoObject alloc] initWithType:4 title:@"屏蔽此人" switchOn:NO]];
//
//
//  [self.tableView reloadData];
                
  
  
  
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
  
  //[self tableViewFooterView];
}

-(void)tableViewFooterView{
  UIView *footerView = [LSHControl viewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AutoSize(68)) backgroundColor:[UIColor clearColor]];
  self.tableView.tableFooterView = footerView;
  
  
  UIButton *delebtn = [LSHControl createButtonWithFrame:CGRectMake(0, AutoSize(8), SCREEN_WIDTH, AutoSize(60)) buttonTitleFont:AdaptedFont(16) buttonTitle:@"删除好友" buttonTitleColor:ColorHex(@"#F92B5E")];
  delebtn.backgroundColor = ColorHex(XYTextColor_FFFFFF);
  [delebtn addTarget:self action:@selector(onDeleteFriend:) forControlEvents:UIControlEventTouchUpInside];
  [footerView addSubview:delebtn];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  XYFirendInfoObject *model = [self.dataSource objectAtIndex:indexPath.section];
  if (model.type == 0) {
    XYIMHeaderTableViewCell *cell = [XYIMHeaderTableViewCell cellWithTableView:tableView indexPath:indexPath];
    cell.model = model;
    return cell;
  }
  if(model.type == 1){
    XYImNextTableViewCell *cell = [XYImNextTableViewCell cellWithTableView:tableView indexPath:indexPath];
    cell.model = model;
    return cell;
  }else  if(model.type == 2){
    XYImNextTableViewCell *cell = [XYImNextTableViewCell cellWithTableView:tableView indexPath:indexPath];
    cell.model = model;
    return cell;
  }else  if(model.type == 3){
    XYIMSwitchTableViewCell *cell = [XYIMSwitchTableViewCell cellWithTableView:tableView indexPath:indexPath];
    cell.model = model;
    cell.switchBlock = ^(BOOL on) {
      if (on) {
          [[TUILocalStorage sharedInstance] addTopConversation:[NSString stringWithFormat:@"c2c_%@",self.userFullInfo.userID]];
      } else {
          [[TUILocalStorage sharedInstance] removeTopConversation:[NSString stringWithFormat:@"c2c_%@",self.userFullInfo.userID]];
      }
    };
    return cell;
  }else{
    XYIMSwitchTableViewCell *cell = [XYIMSwitchTableViewCell cellWithTableView:tableView indexPath:indexPath];
    cell.model = model;
    cell.switchBlock = ^(BOOL on) {
      
    };
    return cell;
  }
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
    vc.userId = self.userFullInfo.userID.numberValue;
    [self.navigationController pushViewController:vc animated:YES];
  }else if (model.type == 1){
    TTextEditController *vc = [[TTextEditController alloc] initWithText:self.friendProfile.friendRemark];
    vc.title = @"修改备注";
    vc.textValue = self.friendProfile.friendRemark;
    [self cyl_pushViewController:vc animated:YES];

    @weakify(self)
    [[RACObserve(vc, textValue) skip:1] subscribeNext:^(NSString *value) {
        @strongify(self)
       // self.modified = YES;
        self.friendProfile.friendRemark = value;
        [[V2TIMManager sharedInstance] setFriendInfo:self.friendProfile succ:^{
           // [self loadData];;
          
          model.value =  self.friendProfile.friendRemark;
          [tableView reloadData];
          
          
        } fail:nil];
    }];
  }else  if(model.type == 2){
    [[UIApplication sharedApplication].delegate.window addSubview:self.reportView];
    [self.reportView addView];
  }
}
#pragma mark - 导航
-(void)newNav{
  self.gk_navTitle = @"聊天详情";
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
    _actionBtn.hidden = YES;
    [_actionBtn addTarget:self action:@selector(onAddFriend) forControlEvents:UIControlEventTouchUpInside];
  }
  return _actionBtn;
}
- (void)onAddFriend
{
  XYFirendRequestViewController *vc = [XYFirendRequestViewController new];
    vc.profile = self.userFullInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *点击 删除好友 后执行的函数，包括好友信息获取和请求回调
 */
- (void)onDeleteFriend:(id)sender
{
  __weak typeof(self) weakSelf = self;
  UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确认删除" message:@"删除后将不再接受聊天消息" preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
   
    [[V2TIMManager sharedInstance] deleteFromFriendList:@[self.userFullInfo.userID] deleteType:V2TIM_FRIEND_TYPE_BOTH succ:^(NSArray<V2TIMFriendOperationResult *> *resultList) {
       // weakSelf.modified = YES;
        [[TUILocalStorage sharedInstance] removeTopConversation:[NSString stringWithFormat:@"c2c_%@",weakSelf.userFullInfo.userID]];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:nil];
  }];
  [alert addAction:okAction];
  
  UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     
  }];
  [alert addAction:cancelAction];
  [self presentViewController:alert animated:YES completion:nil];
  
  
  
}

- (XYReportView *)reportView {
  if (!_reportView) {
    _reportView = [[XYReportView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
  }
  return _reportView;
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
