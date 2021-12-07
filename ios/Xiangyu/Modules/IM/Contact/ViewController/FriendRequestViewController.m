//
//  FriendRequestViewController.m
//  TUIKitDemo
//
//  Created by annidyfeng on 2019/4/18.
//  Copyright © 2019年 kennethmiao. All rights reserved.
//
/** 腾讯云IM Demo 添加好友视图
 *  本文件实现了添加好友时的视图，在您想要添加其他用户为好友时提供UI
 *
 *  本类依赖于腾讯云 TUIKit和IMSDK 实现
 */
#import "FriendRequestViewController.h"
#import "MMLayout/UIView+MMLayout.h"
#import "TUIProfileCardCell.h"
#import "THeader.h"
#import "TIMUserProfile+DataProvider.h"
#import "Toast/Toast.h"
#import <ReactiveObjC.h>
#import "UIImage+TUIKIT.h"
#import "TUIKit.h"
#import "TCommonSwitchCell.h"
#import "THelper.h"
#import "TUIAvatarViewController.h"
#import "XYAddFriendsReqAPI.h"
#import "XYPaymentController.h"
#import "ChatViewController.h"

@interface FriendRequestViewController () <UITableViewDataSource, UITableViewDelegate>
@property UITableView *tableView;
@property UITextView  *addWordTextView;
@property UITextField *nickTextField;
@property UILabel *groupNameLabel;
@property BOOL keyboardShown;
@property TUIProfileCardCellData *cardCellData;
@end

@implementation FriendRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化视图内的组件
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.frame;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
  if (@available(iOS 11.0, *)) {
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
  }
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.bottom.equalTo(self.view);
    make.top.equalTo(self.view).offset(GK_STATUSBAR_NAVBAR_HEIGHT);
  }];


    self.addWordTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.addWordTextView.font = [UIFont systemFontOfSize:14];

    NSString * selfUserID = [[V2TIMManager sharedInstance] getLoginUser];
    [[V2TIMManager sharedInstance] getUsersInfo:@[selfUserID] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
            if (infoList && infoList.count > 0) {
                V2TIMUserFullInfo * userInfo = [infoList firstObject];
                if (userInfo) {
                    self.addWordTextView.text = [NSString stringWithFormat:@"我是%@", userInfo.nickName ? userInfo.nickName : userInfo.userID];
                }
            }
        } fail:^(int code, NSString *desc) {
            
        }];

    self.nickTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.nickTextField.textAlignment = NSTextAlignmentRight;
  
    [self setupNavBar];

    TUIProfileCardCellData *data = [TUIProfileCardCellData new];
    data.name = [self.profile showName];
    data.genderString = [self.profile showGender];
    data.identifier = self.profile.userID;
    data.signature =  [self.profile showSignature];
    data.avatarImage = DefaultAvatarImage;
    data.avatarUrl = [NSURL URLWithString:self.profile.faceURL];
    self.cardCellData = data;

    @weakify(self)
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]
      filter:^BOOL(NSNotification *value) {
          @strongify(self);
          return !self.keyboardShown;
      }]
     subscribeNext:^(NSNotification *x) {
         @strongify(self);
         self.keyboardShown = YES;
         [self adjustContentOffsetDuringKeyboardAppear:YES withNotification:x];
     }];

    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillHideNotification object:nil]
      filter:^BOOL(NSNotification *value) {
          @strongify(self);
          return self.keyboardShown;
      }]
     subscribeNext:^(NSNotification *x) {
         @strongify(self);
         self.keyboardShown = NO;
         [self adjustContentOffsetDuringKeyboardAppear:NO withNotification:x];
     }];
}

- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
  self.gk_navTitle = @"填写信息";
  
  UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [moreButton setTitleColor:ColorHex(XYTextColor_FE2D63) forState:UIControlStateNormal];
  moreButton.titleLabel.font = AdaptedFont(15);
  [moreButton setTitle:@"添加" forState:UIControlStateNormal];
  [moreButton addTarget:self action:@selector(onSend) forControlEvents:UIControlEventTouchUpInside];
  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
  
}

#pragma mark - Keyboard
/**
 *根据键盘的上浮与下沉，使组件一起浮动，保证视图不被键盘遮挡
 */
- (void)adjustContentOffsetDuringKeyboardAppear:(BOOL)appear withNotification:(NSNotification *)notification {
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

    CGRect keyboardEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(keyboardEndFrame);


    CGSize contentSize = self.tableView.contentSize;
    contentSize.height += appear? -keyboardHeight : keyboardHeight;

    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | curve animations:^{
        self.tableView.contentSize = contentSize;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self.cardCellData heightOfWidth:Screen_Width];
    }
    if (indexPath.section == 1) {
        return 120;
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 3;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
        return NSLocalizedString(@"请填写验证信息", nil);
    if (section == 2)
        return NSLocalizedString(@"请填写备注", nil);
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

/**
 *初始化tableView的信息单元
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        TUIProfileCardCell *cell = [[TUIProfileCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TPersonalCommonCell_ReuseId"];
        //设置 profileCard 的委托
        cell.delegate = self;
        [cell fillWithData:self.cardCellData];
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddWord"];
        [cell.contentView addSubview:self.addWordTextView];
        self.addWordTextView.mm_width(Screen_Width).mm_height(120);
        return cell;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NickName"];
            cell.textLabel.text = NSLocalizedString(@"备注", nil);
            [cell.contentView addSubview:self.nickTextField];
            self.nickTextField.mm_width(cell.contentView.mm_w/2).mm_height(cell.contentView.mm_h).mm_right(20);
            self.nickTextField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GroupName"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = NSLocalizedString(@"分组", nil);
            cell.detailTextLabel.text = NSLocalizedString(@"我的好友", nil);
            self.groupNameLabel = cell.detailTextLabel;
            return cell;
        }
    }

    return nil;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
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
  application.addWording = self.addWordTextView.text;
  application.friendRemark = self.nickTextField.text;
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


/**
 *  点击头像查看大图的委托实现。
 */
-(void)didTapOnAvatar:(TUIProfileCardCell *)cell {
    TUIAvatarViewController *image = [[TUIAvatarViewController alloc] init];
    image.avatarData = cell.cardData;
    [self.navigationController pushViewController:image animated:YES];
}

@end
