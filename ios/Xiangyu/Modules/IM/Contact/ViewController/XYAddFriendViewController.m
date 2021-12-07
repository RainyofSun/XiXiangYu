//
//  XYAddFriendViewController.m
//  Xiangyu
//
//  Created by dimon on 07/02/2021.
//

#import "XYAddFriendViewController.h"
#import "XYFriendListCell.h"
#import "FriendRequestViewController.h"
#import "SearchFriendViewController.h"
#import "XYGetInterestAPI.h"
#import "XYFriendItem.h"
#import "XYFirendRequestViewController.h"
#import "XYTimelineProfileController.h"
#import "ChatViewController.h"
@import ImSDK;
@interface XYAddFriendViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) NSArray <XYFriendItem *> * friendsData;

@property (strong, nonatomic) UIView * searchBgView;

@property (strong, nonatomic) UITextField * searchTextField;

@property (strong, nonatomic) UIButton * addressBookBtn;

@property (strong, nonatomic) UIView * titleView;
@property (strong, nonatomic) UILabel * titleLable;

@property (strong, nonatomic) UITableView *listView;

@end

@implementation XYAddFriendViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupNavBar];
  
  [self setupSubviews];
  
  [self fetchData];
}

- (void)fetchData {
  XYShowLoading;
  XYUserInfo *userInfo = [[XYUserService service] fetchLoginUser];
  XYGetInterestAPI *api = [[XYGetInterestAPI alloc] initWithUserId:userInfo.userId];
  api.filterCompletionHandler = ^(NSDictionary *_Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    if (error || !data) {
      XYToastText(error.msg);
      return;
    }
    NSArray *users = data[@"users"];
    self.friendsData = [NSArray yy_modelArrayWithClass:[XYFriendItem class] json:users];
    [self.listView reloadData];
  };
  [api start];

}

#pragma - action
- (void)addFriendsWithUserId:(NSString *)userId {
  XYShowLoading;
  if (userId.isNotBlank) {
    [[V2TIMManager sharedInstance] getUsersInfo:@[userId] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
      XYHiddenLoading;
      XYFirendRequestViewController *frc = [[XYFirendRequestViewController alloc] init];
      frc.profile = infoList.firstObject;
      [self cyl_pushViewController:frc animated:YES];
    } fail:^(int code, NSString *msg) {
      XYHiddenLoading;
      XYToastText(msg);
    }];
  }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reuseID = @"kAddFriendCell";
  XYFriendListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[XYFriendListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
  cell.isFriend = self.friendsData[indexPath.row].isFriend ? self.friendsData[indexPath.row].isFriend.integerValue == 1 : NO;
  cell.item = self.friendsData[indexPath.row];
  @weakify(self);
  cell.actionBlock = ^(XYFriendItem * _Nonnull item) {
   // [weak_self addFriendsWithUserId:item.userId.stringValue];
    TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
    data.conversationID = [NSString stringWithFormat:@"c2c_%@",item.userId];
    data.userID = item.userId.stringValue;
    data.title = item.nickName;
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.conversationData = data;
    [self cyl_pushViewController:chat animated:YES];
  };
  cell.centerAction = YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  XYFriendItem *itme = self.friendsData[indexPath.row];
  XYTimelineProfileController *vc = [XYTimelineProfileController new];
  vc.userId = itme.userId;
  [self cyl_pushViewController:vc animated:YES];
}
#pragma - UI
- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
  self.gk_navTitle = @"添加好友";
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  SearchFriendViewController *vc = [[SearchFriendViewController alloc] init];
  [self cyl_pushViewController:vc animated:NO];
  return NO;
}

- (void)setupSubviews {
  self.view.backgroundColor = ColorHex(XYThemeColor_F);

  [self.view addSubview:self.searchBgView];
  [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(self.view);
    make.top.equalTo(self.gk_navigationBar.mas_bottom);
    make.height.mas_equalTo(54);
  }];

//  [self.searchBgView addSubview:self.addressBookBtn];
//  [self.addressBookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.right.equalTo(self.searchBgView).offset(-16);
//    make.centerY.equalTo(self.searchBgView);
//    make.width.height.mas_equalTo(22);
//  }];
  
  [self.searchBgView addSubview:self.searchTextField];
  [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.searchBgView).offset(16);
    make.centerY.equalTo(self.searchBgView);
    make.height.mas_equalTo(38);
    make.right.equalTo(self.searchBgView).offset(-16);
  }];
  
  [self.view addSubview:self.titleView];
  [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.searchBgView.mas_bottom).offset(8);
    make.left.right.equalTo(self.view);
    make.height.mas_equalTo(44);
  }];
  
  [self.titleView addSubview:self.titleLable];
  [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.insets(UIEdgeInsetsMake(0, 16, 0, 16));
  }];
  
  [self.view addSubview:self.listView];
  [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.bottom.equalTo(self.view);
    make.top.equalTo(self.titleView.mas_bottom);
  }];
}

- (UIView *)searchBgView {
    if (!_searchBgView) {
      _searchBgView = [[UIView alloc] init];
      _searchBgView.backgroundColor = [UIColor whiteColor];
    }
    return _searchBgView;
}

- (UITextField *)searchTextField {
    if (!_searchTextField) {
      _searchTextField = [[UITextField alloc] init];
      _searchTextField.placeholder = @"输入昵称/手机号";
      _searchTextField.layer.cornerRadius = 2.f;
      _searchTextField.font = [UIFont systemFontOfSize:14];
      _searchTextField.leftView = [self leftView];
      _searchTextField.leftViewMode = UITextFieldViewModeAlways;
      _searchTextField.backgroundColor = ColorHex(XYThemeColor_F);
      _searchTextField.delegate = self;
      _searchTextField.layer.cornerRadius = 19;
      _searchTextField.layer.masksToBounds = YES;
    }
    return _searchTextField;
}

- (UIView *)leftView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38, 38)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_14_search"]];
    imgView.frame = CGRectMake(12, 12, 14, 14);
    [view addSubview:imgView];
    return view;
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _listView.dataSource = self;
        _listView.delegate = self;
      UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
      _listView.tableFooterView = footer;
    }
    return _listView;
}

- (UIButton *)addressBookBtn {
  if (!_addressBookBtn) {
    _addressBookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addressBookBtn setImage:[UIImage imageNamed:@"icon_22_maillist"] forState:UIControlStateNormal];
  }
  return _addressBookBtn;
}

- (UIView *)titleView {
  if (!_titleView) {
    _titleView = [[UIView alloc] init];
    _titleView.backgroundColor = ColorHex(XYThemeColor_B);
  }
    return _titleView;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
      _titleLable = [[UILabel alloc] init];
      _titleLable.textColor = ColorHex(XYTextColor_222222);
      _titleLable.font = AdaptedMediumFont(16);
      _titleLable.text = @"感兴趣的人";
    }
    return _titleLable;
}

@end
