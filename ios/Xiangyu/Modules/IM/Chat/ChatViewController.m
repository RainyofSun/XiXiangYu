//
//  ChatViewController.m
//  TUIKitDemo
//
//  Created by kennethmiao on 2018/10/10.
//  Copyright © 2018年 Tencent. All rights reserved.
//
/** 腾讯云IM Demo 聊天视图
 *  本文件实现了聊天视图
 *  在用户需要收发群组、以及其他用户消息时提供UI
 *
 *  本类依赖于腾讯云 TUIKit和IMSDK 实现
 *
 */
#import "ChatViewController.h"
#import "GroupInfoController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TUIVideoMessageCell.h"
#import "TUIFileMessageCell.h"
#import "TUITextMessageCell.h"
#import "TUISystemMessageCell.h"
#import "TUIVoiceMessageCell.h"
#import "TUIImageMessageCell.h"
#import "TUIFaceMessageCell.h"
#import "TUIVideoMessageCell.h"
#import "TUIFileMessageCell.h"
#import "TUIGroupLiveMessageCell.h"
//#import "TUserProfileController.h"
#import "TUIKit.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "MMLayout/UIView+MMLayout.h"
#import "MyCustomCell.h"
#import "THelper.h"
#import "V2TIMManager.h"
#import "Toast.h"
#import "UIViewController+GKCategory.h"
#import "XYAddFriendsResponeAPI.h"
#import "XYTimelineProfileController.h"
#import "XYSuccessViewController.h"
#import "XYFirendTopView.h"
#import "FriendRequestViewController.h"
#import "XYFirendRequestViewController.h"
//#import "XYFirendInfoViewController.h"
#import "XYFirendPrefileViewController.h"
// MLeaksFinder 会对这个类误报，这里需要关闭一下
@implementation UIImagePickerController (Leak)

- (BOOL)willDealloc {
    return NO;
}

@end

@interface ChatViewController () <TUIChatControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate>
@property (nonatomic, strong) TUIChatController *chat;
@property (nonatomic, assign) BOOL netIsDisconnect;

@property(nonatomic,strong)XYFirendTopView *topView;
@end

@implementation ChatViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupNavigator];
  
  [self setupSubviews];

  [self addNotification];

  RAC(self, gk_navTitle) = [RACObserve(_conversationData, title) distinctUntilChanged];
  
  [self fetchChatTitle];

//  [self customMessageViewData];
  
  [self checkIsFriend];

}

-(void)checkIsFriend{
  
  if ([self.conversationData.conversationID containsString:@"c2c_"]) {
    [[V2TIMManager sharedInstance] checkFriend:self.conversationData.userID succ:^(V2TIMFriendCheckResult *result) {
      if (result.relationType == V2TIM_FRIEND_RELATION_TYPE_NONE) {
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(AutoSize(40));
        }];
      }else{
        [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(AutoSize(0));
        }];
      }
      
      
    } fail:nil];
  }
  

  
}


- (void)addNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onRefreshNotification:)
                                               name:TUIKitNotification_TIMRefreshListener_Changed
                                             object:nil];

  //添加未读计数的监听
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(onChangeUnReadCount:)
                                               name:TUIKitNotification_onChangeUnReadCount
                                             object:nil];
}
- (void)setupSubviews {
  self.view.backgroundColor = [UIColor whiteColor];
  _chat = [[TUIChatController alloc] initWithConversation:self.conversationData];
  _chat.delegate = self;
  _chat.view.frame = CGRectMake(0, NAVBAR_HEIGHT, self.view.XY_width, self.view.XY_height - NAVBAR_HEIGHT);
  [self addChildViewController:_chat];
  [self.view addSubview:_chat.view];
  [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.view);
    make.top.equalTo(self.view).offset(NAVBAR_HEIGHT);
    make.height.mas_equalTo(0);
  }];
  
  [_chat.view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.view);
    make.top.equalTo(self.topView.mas_bottom);
    make.bottom.equalTo(self.view);
  }];
  
}

- (void)customMessageViewData {
  NSMutableArray *moreMenus = [NSMutableArray arrayWithArray:_chat.moreMenus];
  [moreMenus addObject:({
      TUIInputMoreCellData *data = [TUIInputMoreCellData new];
      data.image = [UIImage tk_imageNamed:@"more_custom"];
      data.title = NSLocalizedString(@"MoreCustom", nil);
      data;
  })];
  _chat.moreMenus = moreMenus;
}

- (void)fetchChatTitle {
    if (_conversationData.title.length == 0) {
        if (_conversationData.userID.length > 0) {
            _conversationData.title = _conversationData.userID;
             @weakify(self)
            [[V2TIMManager sharedInstance] getFriendsInfo:@[_conversationData.userID] succ:^(NSArray<V2TIMFriendInfoResult *> *resultList) {
                @strongify(self)
                V2TIMFriendInfoResult *result = resultList.firstObject;
                if (result.friendInfo && result.friendInfo.friendRemark.length > 0) {
                    self.conversationData.title = result.friendInfo.friendRemark;
                } else {
                    [[V2TIMManager sharedInstance] getUsersInfo:@[self.conversationData.userID] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
                        V2TIMUserFullInfo *info = infoList.firstObject;
                        if (info && info.nickName.length > 0) {
                            self.conversationData.title = info.nickName;
                        }
                    } fail:nil];
                }
            } fail:nil];
        }
        if (_conversationData.groupID.length > 0) {
            _conversationData.title = _conversationData.groupID;
             @weakify(self)
            [[V2TIMManager sharedInstance] getGroupsInfo:@[_conversationData.groupID] succ:^(NSArray<V2TIMGroupInfoResult *> *groupResultList) {
                @strongify(self)
                V2TIMGroupInfoResult *result = groupResultList.firstObject;
                if (result.info && result.info.groupName.length > 0) {
                    self.conversationData.title = result.info.groupName;
                }
            } fail:nil];
        }
    }
}

- (void)willMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        [_chat saveDraft];
    }
}

// 聊天窗口标题由上层维护，需要自行设置标题
- (void)onRefreshNotification:(NSNotification *)notifi {
    NSArray<V2TIMConversation *> *convs = notifi.object;
    for (V2TIMConversation *conv in convs) {
        if ([conv.conversationID isEqualToString:self.conversationData.conversationID]) {
            self.conversationData.title = conv.showName;
            break;
        }
    }
}

- (void)setupNavigator {
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
    //left
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backBtn addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"icon_arrow_back_22"] forState:UIControlStateNormal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];

    _unRead = [[TUnReadView alloc] init];
    _unRead.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *urItem = [[UIBarButtonItem alloc] initWithCustomView:_unRead];
    self.gk_navLeftBarButtonItems = @[backItem, urItem];
  
    //right，根据当前聊天页类型设置右侧按钮格式
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    if(_conversationData.userID.length > 0){
        [rightButton setImage:[UIImage imageNamed:@"caidan"] forState:UIControlStateNormal];
    }
    else if(_conversationData.groupID.length > 0){
        [rightButton setImage:[UIImage imageNamed:@"caidan"] forState:UIControlStateNormal];
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.gk_navRightBarButtonItems = @[rightItem];
}

- (void)leftBarButtonClick {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBarButtonClick {
  
  
    //当前为用户和用户之间通信时，右侧按钮响应为用户信息视图入口
  XYShowLoading;
    if (_conversationData.userID.length > 0) {
        @weakify(self)
        [[V2TIMManager sharedInstance] getFriendList:^(NSArray<V2TIMFriendInfo *> *infoList) {
            @strongify(self)
            for (V2TIMFriendInfo *firend in infoList) {
                if ([firend.userFullInfo.userID isEqualToString:self.conversationData.userID]) {
                  XYHiddenLoading;
                    id<TUIFriendProfileControllerServiceProtocol> vc = [[TCServiceManager shareInstance] createService:@protocol(TUIFriendProfileControllerServiceProtocol)];
                    if ([vc isKindOfClass:[UIViewController class]]) {
                        vc.friendProfile = firend;
                        [self.navigationController pushViewController:(UIViewController *)vc animated:YES];
                        return;
                    }
                }
            }
            [[V2TIMManager sharedInstance] getUsersInfo:@[self.conversationData.userID] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
              XYHiddenLoading;
              
//              XYFirendPrefileViewController *myProfile = [[XYFirendPrefileViewController alloc] init];
//                              myProfile.firend = infoList.firstObject;
//
//                              [self.navigationController pushViewController:myProfile animated:YES];
              
              XYFirendPrefileViewController *myProfile = [[XYFirendPrefileViewController alloc] init];
                myProfile.userFullInfo = infoList.firstObject;
              //  myProfile.actionType = PCA_ADD_FRIEND;
                [self.navigationController pushViewController:myProfile animated:YES];
            } fail:^(int code, NSString *msg) {
              XYHiddenLoading;
                DLog(@"拉取用户资料失败！");
            }];
        } fail:^(int code, NSString *msg) {
          XYHiddenLoading;
          DLog(@"拉取好友列表失败！");
        }];
    //当前为群组通信时，右侧按钮响应为群组信息入口
    } else {
      XYHiddenLoading;
      GroupInfoController *groupInfo = [[GroupInfoController alloc] init];
      groupInfo.groupId = _conversationData.groupID;
      [self.navigationController pushViewController:groupInfo animated:YES];
    }
}

#pragma - TUIChatControllerDelegate
- (void)chatController:(TUIChatController *)controller didSendMessage:(TUIMessageCellData *)msgCellData {
  
  // userid;
  // 判断是否是陌生人聊天
  
  if (!self.conversationData.groupID.isNotBlank) {
    XYAddFriendsResponeAPI *api = [[XYAddFriendsResponeAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId destUserId:@(self.conversationData.userID.integerValue)];
    [api start];
    
    XYBlindDateReachObjAPI *ObjAPI = [[XYBlindDateReachObjAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId destUserId:@(self.conversationData.userID.integerValue)];
    ObjAPI.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
      if ([[data objectForKey:@"isInterest"] intValue] && [[data objectForKey:@"isSuccessful"] intValue]) {
        XYSuccessViewController *toVC = [[XYSuccessViewController alloc] init];
        toVC.titleL = @"奖励到账";
        toVC.decL = @"现金奖励已到账,您可以在钱包里查看";
          [self presentViewController:toVC animated:YES completion:nil];
      }
    };
    [ObjAPI start];
  }
}

- (void)chatController:(TUIChatController *)controller onSelectMessageAvatar:(TUIMessageCell *)cell {
  XYTimelineProfileController *profileVc = [[XYTimelineProfileController alloc] init];
  profileVc.userId = @(cell.messageData.identifier.integerValue);
  [self cyl_pushViewController:profileVc animated:YES];
}

- (void)chatController:(TUIChatController *)chatController onSelectMoreCell:(TUIInputMoreCell *)cell {
    if ([cell.data.title isEqualToString:NSLocalizedString(@"MoreCustom", nil)]) {
        NSString *text = @"欢迎加入腾讯·云通信大家庭！";
        NSString *link = @"https://cloud.tencent.com/document/product/269/3794";
        MyCustomCellData *cellData = [[MyCustomCellData alloc] initWithDirection:MsgDirectionOutgoing];
        cellData.text = text;
        cellData.link = link;
      cellData.innerMessage = [[V2TIMManager sharedInstance] createCustomMessage:[@{@"version": @(TextLink_Version),@"businessID": TextLink,@"text":text,@"link":link} yy_modelToJSONData]];
        [chatController sendMessage:cellData];
    }
}

- (TUIMessageCellData *)chatController:(TUIChatController *)controller onNewMessage:(V2TIMMessage *)msg {
    if (msg.elemType == V2TIM_ELEM_TYPE_CUSTOM) {
        NSDictionary *param = [msg.customElem.data yy_modelToJSONObject];
        if (param != nil) {
            NSInteger version = [param[@"version"] integerValue];
            NSString *businessID = param[@"businessID"];
            NSString *text = param[@"text"];
            NSString *link = param[@"link"];
            if (text.length == 0 || link.length == 0) {
                return nil;
            }
            if ([businessID isEqualToString:TextLink]) {
                if (version <= TextLink_Version) {
                    MyCustomCellData *cellData = [[MyCustomCellData alloc] initWithDirection:msg.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
                    cellData.innerMessage = msg;
                    cellData.msgID = msg.msgID;
                    cellData.text = param[@"text"];
                    cellData.link = param[@"link"];
                    cellData.avatarUrl = [NSURL URLWithString:msg.faceURL];
                    return cellData;
                }
            } else {
                // 兼容下老版本
                MyCustomCellData *cellData = [[MyCustomCellData alloc] initWithDirection:msg.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
                cellData.innerMessage = msg;
                cellData.msgID = msg.msgID;
                cellData.text = param[@"text"];
                cellData.link = param[@"link"];
                cellData.avatarUrl = [NSURL URLWithString:msg.faceURL];
                return cellData;
            }
        }
    }
    return nil;
}

- (TUIMessageCell *)chatController:(TUIChatController *)controller onShowMessageData:(TUIMessageCellData *)data {
    if ([data isKindOfClass:[MyCustomCellData class]]) {
        MyCustomCell *myCell = [[MyCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
        [myCell fillWithData:(MyCustomCellData *)data];
        return myCell;
    }
    return nil;
}

- (void)chatController:(TUIChatController *)controller onSelectMessageContent:(TUIMessageCell *)cell {
    if ([cell isKindOfClass:[MyCustomCell class]]) {
#pragma - 自定义消息
    }
}

- (void) onChangeUnReadCount:(NSNotification *)notifi {
    NSMutableArray *convList = (NSMutableArray *)notifi.object;
    int unReadCount = 0;
    for (V2TIMConversation *conv in convList) {
        // 忽略当前会话的未读数
        if (![conv.conversationID isEqual:self.conversationData.conversationID]) {
            if (NO == [conv.groupType isEqualToString:@"Meeting"]) {
                unReadCount += conv.unreadCount;
            }
        }
    }
    [_unRead setNum:unReadCount];
}

- (void)sendMessage:(TUIMessageCellData*)msg {
    [_chat sendMessage:msg];
  
  
  
  
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(XYFirendTopView *)topView{
  if (!_topView) {
    _topView = [[XYFirendTopView alloc]initWithFrame:CGRectNull];
    [self.view addSubview:_topView];
    [_topView handleTapGestureRecognizerEventWithBlock:^(id sender) {
                    [[V2TIMManager sharedInstance] getUsersInfo:@[self.conversationData.userID] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
                     // XYHiddenLoading;
                      XYFirendRequestViewController *frc = [[XYFirendRequestViewController alloc] init];
                      frc.profile = infoList.firstObject;
                      [self cyl_pushViewController:frc animated:YES];
                    } fail:^(int code, NSString *msg) {
                    //  XYHiddenLoading;
                     // XYToastText(msg);
                    }];
    }];
  }
  return _topView;
}

@end
