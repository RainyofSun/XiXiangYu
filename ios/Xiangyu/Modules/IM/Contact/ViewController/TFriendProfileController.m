//
//  TFriendController.m
//  TUIKit
//
//  Created by annidyfeng on 2019/4/29.
//  Copyright © 2019年 kennethmiao. All rights reserved.
//
/** 腾讯云IM Demo好友信息视图
 *  本文件实现了好友简介视图控制器，只在显示好友时使用该视图控制器
 *  若要显示非好友的用户信息，请查看TUIKitDemo/Chat/TUserProfileController.m
 *
 *  本类依赖于腾讯云 TUIKit和IMSDK 实现
 */
#import "TFriendProfileController.h"
#import "TCommonTextCell.h"
#import "TCommonSwitchCell.h"
#import "MMLayout/UIView+MMLayout.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "THeader.h"
#import "TTextEditController.h"
#import "ChatViewController.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "TUIKit.h"
#import "TUIAvatarViewController.h"
#import "THelper.h"
#import "TCommonTextCell.h"
#import "XYReportView.h"

#import "XYProfileDetailAPI.h"
#import "XYIMHeaderTableViewCell.h"
#import "XYTimelineProfileController.h"
@TCServiceRegister(TUIFriendProfileControllerServiceProtocol, TFriendProfileController)

@interface TFriendProfileController () <UITableViewDelegate, UITableViewDataSource>
@property NSArray<NSArray *> *dataList;
@property BOOL isInBlackList;
@property BOOL modified;
@property V2TIMUserFullInfo *userFullInfo;

@property(nonatomic,strong)XYFirendInfoObject *InfoObject;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) XYReportView * reportView;
@end

@implementation TFriendProfileController
@synthesize friendProfile;

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setupNavBar];
  
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.XY_width, self.view.XY_height - NAVBAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    self.tableView.delaysContentTouches = NO;
    [self.tableView registerClass:[TCommonTextCell class] forCellReuseIdentifier:@"TextCell"];
    [self.tableView registerClass:[TCommonSwitchCell class] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerClass:[TUIProfileCardCell class] forCellReuseIdentifier:@"CardCell"];
    [self.tableView registerClass:[TUIButtonCell class] forCellReuseIdentifier:@"ButtonCell"];
  
  /*适配ios11*/
  if (@available(iOS 11.0, *)) {
      _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
      _tableView.scrollIndicatorInsets = _tableView.contentInset;
      _tableView.estimatedRowHeight = 0;
      _tableView.estimatedSectionHeaderHeight = 0;
      _tableView.estimatedSectionFooterHeight = 0;
  }
  
    [[V2TIMManager sharedInstance] getBlackList:^(NSArray<V2TIMFriendInfo *> *infoList) {
        for (V2TIMFriendInfo *friend in infoList) {
            if ([friend.userID isEqualToString:self.friendProfile.userID])
            {
                self.isInBlackList = true;
                break;
            }
        }
        [self loadData];;
    } fail:nil];

    self.userFullInfo = self.friendProfile.userFullInfo;
  
  [self reshData];;
}
-(void)reshData{
  XYProfileDetailAPI *api = [[XYProfileDetailAPI alloc]initWithUserId:self.userFullInfo.userID.numberValue];
  @weakify(self);
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    @strongify(self);
    self.InfoObject = [[XYFirendInfoObject alloc]initWithType:0 infoObj:data];;
   // obj.infoObj = data;
    [self.tableView reloadData];
  };
  [api start];
}
- (void)setupNavBar {
  self.gk_navTitle = @"聊天详情";
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
}

/**
 *初始化视图显示数据
 */
- (void)loadData
{
    NSMutableArray *list = @[].mutableCopy;
    [list addObject:({
        NSMutableArray *inlist = @[].mutableCopy;
        [inlist addObject:({
            TUIProfileCardCellData *personal = [[TUIProfileCardCellData alloc] init];
            personal.identifier = self.userFullInfo.userID;
            personal.avatarImage = DefaultAvatarImage;
            personal.avatarUrl = [NSURL URLWithString:self.userFullInfo.faceURL];
            personal.name = [self.userFullInfo showName];
            personal.genderString = [self.userFullInfo showGender];
            personal.signature = [self.userFullInfo showSignature];
            personal.reuseId = @"CardCell";
            personal;
        })];
        inlist;
    })];

    [list addObject:({
        NSMutableArray *inlist = @[].mutableCopy;
        [inlist addObject:({
            TCommonTextCellData *data = TCommonTextCellData.new;
            data.key = @"设置备注";
            data.value = self.friendProfile.friendRemark;
            if (data.value.length == 0)
            {
                data.value = @"无";
            }
            data.showAccessory = YES;
            data.cselector = @selector(onChangeRemark:);
            data.reuseId = @"TextCell";
            data;
        })];
      inlist;
      })];
      [list addObject:({
          NSMutableArray *inlist = @[].mutableCopy;
          [inlist addObject:({
              TCommonTextCellData *data = TCommonTextCellData.new;
              data.key = @"举报该用户";
              data.value = @"";
          
              data.showAccessory = YES;
              data.cselector = @selector(onReportEvent);
              data.reuseId = @"TextCell";
              data;
          })];
        inlist;
        })];

//        [inlist addObject:({
//            TCommonSwitchCellData *data = TCommonSwitchCellData.new;
//            data.title = @"加入黑名单";
//            data.on = self.isInBlackList;
//            data.cswitchSelector =  @selector(onChangeBlackList:);
//            data.reuseId = @"SwitchCell";
//            data;
//        })];
//        inlist;
//    })];

    [list addObject:({
        NSMutableArray *inlist = @[].mutableCopy;
        [inlist addObject:({
            TCommonSwitchCellData *data = TCommonSwitchCellData.new;
            data.title = @"置顶聊天";
            if ([[[TUILocalStorage sharedInstance] topConversationList] containsObject:[NSString stringWithFormat:@"c2c_%@",self.friendProfile.userID]]) {
                data.on = YES;
            }
            data.cswitchSelector =  @selector(onTopMostChat:);
            data.reuseId = @"SwitchCell";
            data;
        })];
        inlist;
    })];
    [list addObject:({
        NSMutableArray *inlist = @[].mutableCopy;
//        [inlist addObject:({
//            TUIButtonCellData *data = TUIButtonCellData.new;
//            data.title = @"发消息";
//            data.style = ButtonBule;
//            data.cbuttonSelector = @selector(onSendMessage:);
//            data.reuseId = @"ButtonCell";
//            data;
//        })];
        [inlist addObject:({
            TUIButtonCellData *data = TUIButtonCellData.new;
            data.title = @"删除好友";
            data.style = ButtonRedText;
            data.cbuttonSelector =  @selector(onDeleteFriend:);
            data.reuseId = @"ButtonCell";
            data;
        })];
        inlist;
    })];

    self.dataList = list;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (void)onChangeBlackList:(TCommonSwitchCell *)cell
{
    if (cell.switcher.on) {
        [[V2TIMManager sharedInstance] addToBlackList:@[self.friendProfile.userID] succ:nil fail:nil];
    } else {
        [[V2TIMManager sharedInstance] deleteFromBlackList:@[self.friendProfile.userID] succ:nil fail:nil];
    }
}

/**
 *点击 修改备注 按钮后所执行的函数。包含数据的获取与请求回调
 */
- (void)onChangeRemark:(TCommonTextCell *)cell
{
    TTextEditController *vc = [[TTextEditController alloc] initWithText:self.friendProfile.friendRemark];
    vc.title = @"修改备注";
    vc.textValue = self.friendProfile.friendRemark;
    [self cyl_pushViewController:vc animated:YES];

    @weakify(self)
    [[RACObserve(vc, textValue) skip:1] subscribeNext:^(NSString *value) {
        @strongify(self)
        self.modified = YES;
        self.friendProfile.friendRemark = value;
        [[V2TIMManager sharedInstance] setFriendInfo:self.friendProfile succ:^{
            [self loadData];;
        } fail:nil];
    }];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSObject *data = self.dataList[indexPath.section][indexPath.row];
    //原本的写法会使得子类重写的方法无法被调用，所以此处使用了“我”界面的写法。
    if([data isKindOfClass:[TUIProfileCardCellData class]]){
//        TUIProfileCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell" forIndexPath:indexPath];
//        //设置 profileCard 的委托
//        cell.delegate = self;
//        [cell fillWithData:(TUIProfileCardCellData *)data];
      XYIMHeaderTableViewCell *cell = [XYIMHeaderTableViewCell cellWithTableView:tableView indexPath:indexPath];
      cell.model = self.InfoObject;
        return cell;

    }   else if([data isKindOfClass:[TUIButtonCellData class]]){
        TUIButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
        if(!cell){
            cell = [[TUIButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonCell"];
        }
        [cell fillWithData:(TUIButtonCellData *)data];
        return cell;

    }  else if([data isKindOfClass:[TCommonTextCellData class]]) {
        TCommonTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell" forIndexPath:indexPath];
        [cell fillWithData:(TCommonTextCellData *)data];
        return cell;

    }  else if([data isKindOfClass:[TCommonSwitchCellData class]]) {
        TCommonSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
        [cell fillWithData:(TCommonSwitchCellData *)data];
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    TCommonCellData *data = self.dataList[indexPath.section][indexPath.row];
    return [data heightOfWidth:Screen_Width];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  return 0.01;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NSObject *data = self.dataList[indexPath.section][indexPath.row];
  //原本的写法会使得子类重写的方法无法被调用，所以此处使用了“我”界面的写法。
  if([data isKindOfClass:[TUIProfileCardCellData class]]){
    XYTimelineProfileController *vc = [[XYTimelineProfileController alloc]init];
    vc.userId = self.userFullInfo.userID.numberValue;
    [self.navigationController pushViewController:vc animated:YES];
  }
}


/**
 *点击 删除好友 后执行的函数，包括好友信息获取和请求回调
 */
- (void)onDeleteFriend:(id)sender
{
  __weak typeof(self) weakSelf = self;
  UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确认删除" message:@"删除后将不再接受聊天消息" preferredStyle:UIAlertControllerStyleAlert];
  
  UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
   
    [[V2TIMManager sharedInstance] deleteFromFriendList:@[self.friendProfile.userID] deleteType:V2TIM_FRIEND_TYPE_BOTH succ:^(NSArray<V2TIMFriendOperationResult *> *resultList) {
        weakSelf.modified = YES;
        [[TUILocalStorage sharedInstance] removeTopConversation:[NSString stringWithFormat:@"c2c_%@",weakSelf.friendProfile.userID]];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } fail:nil];
  }];
  [alert addAction:okAction];
  
  UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
     
  }];
  [alert addAction:cancelAction];
  [self presentViewController:alert animated:YES completion:nil];
  
  
  
}
/**
 举报
 */
-(void)onReportEvent{
  
  [[UIApplication sharedApplication].delegate.window addSubview:self.reportView];
  [self.reportView addView];
  
}
/**
 *点击 发送消息 后执行的函数，默认跳转到对应好友的聊天界面
 */
- (void)onSendMessage:(id)sender
{
    TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
    data.conversationID = [NSString stringWithFormat:@"c2c_%@",self.userFullInfo.userID];
    data.userID = self.friendProfile.userID;
    data.title = [self.friendProfile.userFullInfo showName];
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.conversationData = data;
    [self.navigationController pushViewController:chat animated:YES];
}

/**
 *操作 置顶 开关后执行的函数，将对应好友添加/移除置顶队列
 */
- (void)onTopMostChat:(TCommonSwitchCell *)cell
{
    if (cell.switcher.on) {
        [[TUILocalStorage sharedInstance] addTopConversation:[NSString stringWithFormat:@"c2c_%@",self.friendProfile.userID]];
    } else {
        [[TUILocalStorage sharedInstance] removeTopConversation:[NSString stringWithFormat:@"c2c_%@",self.friendProfile.userID]];
    }
}

/**
 *  点击头像查看大图的委托实现
 */
-(void)didTapOnAvatar:(TUIProfileCardCell *)cell{
    TUIAvatarViewController *image = [[TUIAvatarViewController alloc] init];
    image.avatarData = cell.cardData;
    [self.navigationController pushViewController:image animated:YES];
}
- (XYReportView *)reportView {
  if (!_reportView) {
    _reportView = [[XYReportView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
  }
  return _reportView;
}
@end
