//
//  ConversationViewController.m
//  TUIKitDemo
//
//  Created by kennethmiao on 2018/10/10.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "ConversationController.h"
#import "TUIConversationListController.h"
#import "ChatViewController.h"
#import "THeader.h"
#import "Toast/Toast.h"
#import "TUIContactSelectController.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "TIMUserProfile+DataProvider.h"
#import "TNaviBarIndicatorView.h"
#import "TUIKit.h"
#import "THelper.h"
#import "TIMUserProfile+DataProvider.h"
#import <ImSDK/ImSDK.h>
#import "ContactsController.h"
#import "XYAddFriendViewController.h"
#import "PopoverView.h"
#import "UIScrollView+EmptyDataSet.h"
@interface ConversationController () <TUIConversationListControllerDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) TNaviBarIndicatorView *titleView;
@end

@implementation ConversationController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    TUIConversationListController *conv = [[TUIConversationListController alloc] init];
    conv.tableView.delaysContentTouches = NO;
    conv.delegate = self;
  //conv.tableView.backgroundColor = [UIColor redColor];
  conv.tableView.emptyDataSetDelegate=self;
  conv.tableView.emptyDataSetSource=self;
    [self addChildViewController:conv];
    conv.view.frame = self.view.bounds;
    [self.view addSubview:conv.view];
    [self setupNavBar];
}

- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
  UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [leftBtn setImage:[UIImage imageNamed:@"icon_22_toxunl"] forState:UIControlStateNormal];
  [leftBtn addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
  self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
  
  UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [rightBtn setImage:[UIImage imageNamed:@"icon_22_jiahaoyou"] forState:UIControlStateNormal];
  [rightBtn addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
  _titleView = [[TNaviBarIndicatorView alloc] init];
  [_titleView setTitle:@"好友"];
  self.gk_navigationItem.titleView = _titleView;

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkChanged:) name:TUIKitNotification_TIMConnListener object:nil];
}

/**
 *推送默认跳转
 */
- (void)pushToChatViewController:(NSString *)groupID userID:(NSString *)userID {
    ChatViewController *chat = [[ChatViewController alloc] init];
    TUIConversationCellData *conversationData = [[TUIConversationCellData alloc] init];
    conversationData.groupID = groupID;
    conversationData.userID = userID;
    chat.conversationData = conversationData;
    [self.navigationController pushViewController:chat animated:YES];
}

#pragma - action
- (void)leftBarButtonClick {
  ContactsController *contactsVc = [[ContactsController alloc] init];
  [self cyl_pushViewController:contactsVc animated:YES];
}

- (void)rightBarButtonClick:(UIButton *)rightBarButton {
//  PopoverAction *friend = [PopoverAction actionWithImage:[UIImage imageNamed:@"icon_22_jiahaoyou"] title:@"添加好友" handler:^(PopoverAction *action) {
//    UIViewController *add = [[XYAddFriendViewController alloc] init];
//    [self cyl_pushViewController:add animated:YES];
//  }];
//
//  PopoverAction *group = [PopoverAction actionWithImage:[UIImage imageNamed:@"icon_22_jiahaoyou"] title:@"创建群聊" handler:^(PopoverAction *action) {
//    //创建群聊
//    TUIContactSelectController *vc = [TUIContactSelectController new];
//    [self cyl_pushViewController:vc animated:YES];
//    @weakify(self);
//    vc.finishBlock = ^(NSArray<TCommonContactSelectCellData *> *array) {
//        @strongify(self)
//        [self addGroup:GroupType_Public addOption:V2TIM_GROUP_ADD_ANY withContacts:array];
//    };
//  }];
//
//  PopoverView *popoverView = [PopoverView popoverView];
//  popoverView.showShade = YES;
//  popoverView.arrowStyle = PopoverViewArrowStyleRound;
//  [popoverView showToView:rightBarButton withActions:@[friend,group]];
  UIViewController *add = [[XYAddFriendViewController alloc] init];
  [self cyl_pushViewController:add animated:YES];
}

#pragma - TUIConversationListControllerDelegate
- (void)conversationListController:(TUIConversationListController *)conversationController didSelectConversation:(TUIConversationCell *)conversation {
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.conversationData = conversation.convData;
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)addGroup:(NSString *)groupType addOption:(V2TIMGroupAddOpt)addOption withContacts:(NSArray<TCommonContactSelectCellData *>  *)contacts
{
    NSString *loginUser = [[V2TIMManager sharedInstance] getLoginUser];
    [[V2TIMManager sharedInstance] getUsersInfo:@[loginUser] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
        NSString *showName = loginUser;
        if (infoList.firstObject.nickName.length > 0) {
            showName = infoList.firstObject.nickName;
        }
        NSMutableString *groupName = [NSMutableString stringWithString:showName];
        NSMutableArray *members = [NSMutableArray array];
        //遍历contacts，初始化群组成员信息、群组名称信息
        for (TCommonContactSelectCellData *item in contacts) {
            V2TIMCreateGroupMemberInfo *member = [[V2TIMCreateGroupMemberInfo alloc] init];
            member.userID = item.identifier;
            member.role = V2TIM_GROUP_MEMBER_ROLE_MEMBER;
            [groupName appendFormat:@"、%@", item.title];
            [members addObject:member];
        }

        //群组名称默认长度不超过10，如有需求可在此更改，但可能会出现UI上的显示bug
        if ([groupName length] > 10) {
            groupName = [groupName substringToIndex:10].mutableCopy;
        }

        V2TIMGroupInfo *info = [[V2TIMGroupInfo alloc] init];
        info.groupName = groupName;
        info.groupType = groupType;
        if(![info.groupType isEqualToString:GroupType_Work]){
            info.groupAddOpt = addOption;
        }

        //发送创建请求后的回调函数
        @weakify(self)
        [[V2TIMManager sharedInstance] createGroup:info memberList:members succ:^(NSString *groupID) {
            //创建成功后，在群内推送创建成功的信息
            @strongify(self)
            NSDictionary *dic = @{@"version": @(GroupCreate_Version),@"businessID": GroupCreate,@"opUser":showName,@"content":@"创建群聊"};
            NSData *data= [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            V2TIMMessage *msg = [[V2TIMManager sharedInstance] createCustomMessage:data];
            [[V2TIMManager sharedInstance] sendMessage:msg receiver:nil groupID:groupID priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:nil progress:nil succ:nil fail:nil];

            //创建成功后，默认跳转到群组对应的聊天界面
            TUIConversationCellData *cellData = [[TUIConversationCellData alloc] init];
            cellData.groupID = groupID;
            cellData.title = groupName;
            ChatViewController *chat = [[ChatViewController alloc] init];
            chat.conversationData = cellData;
            [self.navigationController pushViewController:chat animated:YES];

            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [tempArray removeObjectAtIndex:tempArray.count-2];
            self.navigationController.viewControllers = tempArray;
        } fail:^(int code, NSString *msg) {
            [THelper makeToastError:code msg:msg];
        }];
    } fail:^(int code, NSString *msg) {
        // to do
    }];
}


- (void)onNetworkChanged:(NSNotification *)notification {
    TUINetStatus status = (TUINetStatus)[notification.object intValue];
    switch (status) {
        case TNet_Status_Succ:
            [_titleView setTitle:@"好友"];
            [_titleView stopAnimating];
            break;
        case TNet_Status_Connecting:
            [_titleView setTitle:@"连接中..."];
            [_titleView startAnimating];
            break;
        case TNet_Status_Disconnect:
            [_titleView setTitle:@"未连接"];
            [_titleView stopAnimating];
            break;
        case TNet_Status_ConnFailed:
            [_titleView setTitle:@"未连接"];
            [_titleView stopAnimating];
            break;

        default:
            break;
    }
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
@end
