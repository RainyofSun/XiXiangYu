//
//  XYHomeRecommendPopController.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import "XYHomeRecommendPopController.h"
#import "XYHomeRecommendCell.h"
#import "XYPresentationController.h"
#import "TUIConversationCellData.h"
#import "ChatViewController.h"

@import ImSDK;

@interface XYHomeRecommendPopController () <UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) UILabel *titleLable;

@property (strong, nonatomic) UIButton *closeBtn;

@property (strong, nonatomic) UITableView *listView;

@end

@implementation XYHomeRecommendPopController
- (instancetype)init {
  if (self = [super init]) {
      self.modalPresentationStyle = UIModalPresentationCustom;
      self.transitioningDelegate = self;
  }
  return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  self.view.backgroundColor = ColorHex(XYThemeColor_B);
  self.view.layer.cornerRadius = 12;
  self.view.layer.masksToBounds = YES;
  [self setupSubviews];
}

- (void)close {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupSubviews {
  [self.view addSubview:self.titleLable];
  [self.view addSubview:self.closeBtn];
  [self.view addSubview:self.listView];
  
  [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(24);
    make.centerX.equalTo(self.view);
  }];
  
  [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.view).offset(-8);
    make.top.equalTo(self.view).offset(8);
  }];
  
  [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.titleLable.mas_bottom).offset(22);
    make.left.right.bottom.equalTo(self.view);
  }];
}
-(CGSize)preferredContentSize {
  return CGSizeMake(kScreenWidth-32, kScreenHeight-280);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reuseID = @"kHomeRecommendCell";
  XYHomeRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[XYHomeRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
  cell.item = self.data[indexPath.row];
  cell.addBlock = ^(XYInterestItem *item) {
    if (item.isGroup) {
      [self addGroupWithGroupId:item.relationId.stringValue];
    } else {
      [self addFriendWithUserId:item.relationId.stringValue index:indexPath.row];
    }
  };
    return cell;
}

- (void)addFriendWithUserId:(NSString *)userId
                      index:(NSUInteger)index {
  XYShowLoading;
    V2TIMFriendAddApplication *application = [[V2TIMFriendAddApplication alloc] init];
    application.userID = userId;
    application.addSource = @"iOS";
    application.addType = V2TIM_FRIEND_TYPE_BOTH;
    
    [[V2TIMManager sharedInstance] addFriend:application succ:^(V2TIMFriendOperationResult *result) {
      XYHiddenLoading;
      XYToastText(@"等待对方验证");
    } fail:^(int code, NSString *desc) {
      XYHiddenLoading;
      XYToastText(desc);
    }];
}

//添加群组
- (void)addGroupWithGroupId:(NSString *)groupId {
  TUIConversationCellData *conversationData = [[TUIConversationCellData alloc] init];
  conversationData.groupID = groupId;
  ChatViewController *chat = [[ChatViewController alloc] init];
  chat.conversationData = conversationData;
  [self cyl_pushViewController:chat animated:YES];
}

#pragma mark - getter
- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.dataSource = self;
        _listView.delegate = self;
    }
    return _listView;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
      _titleLable = [[UILabel alloc] init];
      _titleLable.textColor = ColorHex(XYTextColor_222222);
      _titleLable.font = AdaptedMediumFont(XYFont_G);
      _titleLable.text = @"可能感兴趣的好友和群";
    }
    return _titleLable;
}

- (UIButton *)closeBtn {
  if (!_closeBtn) {
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"icon-pop-Close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
  }
  return _closeBtn;
}
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return [[XYPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
}
@end
