//
//  XYDynamicsDetailController.m
//  Xiangyu
//
//  Created by dimon on 09/02/2021.
//

#import "XYDynamicsDetailController.h"
#import "XYDynamicsDetailDataManager.h"
#import "XYCommentListCell.h"
#import "XYCommentLikeCell.h"
#import "XYDefaultButton.h"
#import "XYDynamicsDetailHeaderView.h"
#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "YZInputView.h"
#import "XYTimelineProfileController.h"
#import "XYBottomCommentView.h"
#import "XYDynamicsFabulousAPI.h"

#import "XYDynamicFabulousViewController.h"
#import "XYTopicDetailViewController.h"
@interface XYDynamicsDetailController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UIView * navBgView;

@property (nonatomic, strong) UIButton * popBtn;

@property (nonatomic, strong) UIImageView * iconView;

@property (nonatomic, strong) UILabel * nameLable;

@property (nonatomic, strong) XYDefaultButton * attentionBtn;

@property (nonatomic, strong) XYDynamicsDetailHeaderView * headerView;

@property (strong, nonatomic) UITableView *listView;

@property(nonatomic,strong)XYDynamicsDetailDataManager * dataManager;


@property(nonatomic,strong)XYBottomCommentView *commentView;

//@property(nonatomic,strong)UIView * commentBgView;
//@property(nonatomic,strong)YZInputView * commentInputTF;

@end

@implementation XYDynamicsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
    [self setupNavBar];
  
    [self fetchViewData];
  
    [self.listView.mj_header beginRefreshing];
}

- (void)iconDidClick {
  XYTimelineProfileController *profileVc = [[XYTimelineProfileController alloc] init];
  profileVc.userId = self.dynamicsModel.userId;
  [self cyl_pushViewController:profileVc animated:YES];
}

- (void)fetchViewData {
  self.dataManager.dynamicsModel = self.dynamicsModel;
  
  [self.dataManager layoutViewData];
  
  [self setupSubviews];
}

- (void)fetchNewData {
  @weakify(self);
  [self.dataManager fetchNewPageDataWithLikesErrorBlock:^(XYError * _Nonnull error) {
    XYToastText(error.msg);
  } commentErrorBlock:^(XYError * _Nonnull error) {
    XYToastText(error.msg);
  } completion:^{
    [weak_self.listView.mj_header endRefreshing];
    [weak_self.listView reloadData];
  }];
}

- (void)fetchNextData {
  @weakify(self);
  [self.dataManager fetchNextPageDataWithBlock:^(BOOL needRefresh, XYError * _Nonnull error) {
    [weak_self.listView.mj_footer endRefreshing];
    if (error) {
      XYToastText(error.msg);
    } else {
      [weak_self.listView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }
  }];
}

- (void)back {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)attention {
  @weakify(self);
  XYShowLoading;
  if (self.dynamicsModel.userId.integerValue == [[XYUserService service] fetchLoginUser].userId.integerValue) {
    [self.dataManager deleteDynamicWithBlock:^(XYError * _Nonnull error) {
      XYHiddenLoading;
      if (error) {
        XYToastText(error.msg);
      } else {
        XYToastText(@"删除成功");
        [weak_self.navigationController popViewControllerAnimated:YES];
      }
    }];
  } else {
    [self.dataManager followUserWithBlock:^(XYError * _Nonnull error) {
      XYHiddenLoading;
      if (error) {
        XYToastText(error.msg);
      } else {
        if (weak_self.dynamicsModel.isFollow.integerValue == 1) {
          weak_self.attentionBtn.enabled = NO;
          [weak_self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
          weak_self.attentionBtn.layer.borderWidth = 0.0;
          [weak_self.attentionBtn setBackgroundColor:ColorHex(XYThemeColor_I)];
          [weak_self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
          [weak_self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
        } else {
          weak_self.attentionBtn.enabled = YES;
          weak_self.attentionBtn.layer.borderWidth = 0.0;
          [weak_self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
          [weak_self.attentionBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
          [weak_self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
          [weak_self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
        }
      }
    }];
  }
}

- (void)comment {
  if (!self.commentView.textView.text.isNotBlank) {
    return;
  }
//
  if (self.commentView.textView.text.length > 60) {
    XYToastText(@"评论字数在60字以内");
    return;
  }
//
  @weakify(self);
  XYShowLoading;
  [self.dataManager postCommont:self.commentView.textView.text block:^(XYError * _Nonnull error) {
    XYHiddenLoading;
    if (error) {
      XYToastText(error.msg);
    } else {
      weak_self.commentView.textView.text = @"";
      [weak_self.listView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }
  }];
}

- (void)deleteCommentWithIndexPath:(NSIndexPath *)indexPath {
  @weakify(self);
  XYShowLoading;
  [self.dataManager deleteCommentWithIndex:indexPath.row block:^(XYError * _Nonnull error) {
    XYHiddenLoading;
    if (error) {
      XYToastText(error.msg);
    } else {
      [weak_self.listView beginUpdates];
      [weak_self.listView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
      [weak_self.listView endUpdates];
    }
  }];
}

- (void)setupNavBar {
  self.gk_navigationBar.hidden = YES;
  [self.view addSubview:self.navBgView];
  [self.navBgView addSubview:self.popBtn];
  [self.navBgView addSubview:self.iconView];
  [self.navBgView addSubview:self.nameLable];
  [self.navBgView addSubview:self.attentionBtn];
}

- (void)setupSubviews {
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.commentView];
  self.commentView.dymodel = self.dynamicsModel;
  [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.bottom.trailing.equalTo(self.view);
  }];
  
  
  [self.view addSubview:self.listView];
  [self.listView makeConstraints:^(MASConstraintMaker *make) {
      //make.edges.insets(UIEdgeInsetsMake(NAVBAR_HEIGHT, 0, 60, 0));
    make.leading.trailing.equalTo(self.view);
    make.top.equalTo(self.view).offset(NAVBAR_HEIGHT);
    make.bottom.equalTo(self.commentView.mas_top);
  }];
  
 
 // self.commentBgView.frame = CGRectMake(0, kScreenHeight-60, kScreenWidth, 60);
  
 // [self.commentBgView addSubview:self.commentInputTF];
 // self.commentInputTF.frame = CGRectMake(16, 8, kScreenWidth-32, 44);
  
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  
    return self.dataManager.commentsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//  if (indexPath.section == 0) {
//    XYCommentLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XYCommentLikeCell class]) forIndexPath:indexPath];
//    cell.configData = self.dataManager.likesUserArray;
//    return cell;
//  } else {
    XYCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XYCommentListCell class]) forIndexPath:indexPath];
    cell.model = self.dataManager.commentsArray[indexPath.row];
    cell.isFirstCell = indexPath.row == 0;
    @weakify(self);
    cell.deleteBlock = ^{
      [weak_self deleteCommentWithIndexPath:indexPath];
    };
    return cell;
//  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   // [self.commentInputTF resignFirstResponder];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//
//  if([text isEqualToString:@"\n"]) {
//   // [self.commentInputTF resignFirstResponder];
//    [self comment];
//    return NO;
//  }
//  return YES;
//}

#pragma mark - UI
- (void)keyBoardWillShow:(NSNotification *) note {
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    void (^animation)(void) = ^void(void) {
        //self.commentBgView.XY_bottom = kScreenHeight - keyBoardHeight;
      [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-keyBoardHeight);
      }];
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
    
}

- (void)keyBoardWillHide:(NSNotification *) note {
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    void (^animation)(void) = ^void(void) {
     // self.commentBgView.XY_bottom = kScreenHeight;
      [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
      }];
    };
    
    if (animationTime > 0) {
        [UIView animateWithDuration:animationTime animations:animation];
    } else {
        animation();
    }
}
- (UIView *)navBgView {
  if (!_navBgView) {
    _navBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, NAVBAR_HEIGHT)];
    _navBgView.backgroundColor = ColorHex(XYThemeColor_B);
  }
  return _navBgView;
}

- (UIButton *)popBtn {
  if (!_popBtn) {
    _popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_popBtn setImage:[UIImage imageNamed:@"icon_arrow_back_22"] forState:UIControlStateNormal];
    [_popBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _popBtn.frame = CGRectMake(16, StatusBarHeight()+11, 22, 22);
  }
  return _popBtn;
}

- (XYDefaultButton *)attentionBtn {
  if (!_attentionBtn) {
    _attentionBtn = [XYDefaultButton buttonWithType:UIButtonTypeCustom];
    _attentionBtn.titleLabel.font = AdaptedFont(12);
    if (self.dynamicsModel.userId.integerValue == [[XYUserService service] fetchLoginUser].userId.integerValue) {
        _attentionBtn.enabled = YES;
        [_attentionBtn setTitle:@"删除" forState:UIControlStateNormal];
        _attentionBtn.layer.borderColor = ColorHex(XYThemeColor_A).CGColor;
        _attentionBtn.layer.borderWidth = 0.5;
        [_attentionBtn setBackgroundColor:ColorHex(XYThemeColor_B)];
        [_attentionBtn setTitleColor:ColorHex(XYTextColor_FE2D63) forState:UIControlStateNormal];
        [_attentionBtn setTitleColor:ColorHex(XYTextColor_CCCCCC) forState:UIControlStateDisabled];
      } else {
        if (self.dynamicsModel.isFollow.integerValue == 1) {
          _attentionBtn.enabled = NO;
          [_attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
          _attentionBtn.layer.borderWidth = 0.0;
          [_attentionBtn setBackgroundColor:ColorHex(XYThemeColor_I)];
          [_attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
          [_attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
        } else {
          _attentionBtn.enabled = YES;
          _attentionBtn.layer.borderWidth = 0.0;
          [_attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
          [_attentionBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
          [_attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
          [_attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
        }
      }
    [_attentionBtn addTarget:self action:@selector(attention) forControlEvents:UIControlEventTouchUpInside];
    _attentionBtn.frame = CGRectMake(kScreenWidth-72, StatusBarHeight()+10, 56, 24);
    
  }
  return _attentionBtn;
}

- (UIImageView *)iconView {
  if (!_iconView) {
    _iconView = [[UIImageView alloc] init];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:self.dynamicsModel.headPortrait]];
    _iconView.frame = CGRectMake(54, StatusBarHeight()+7, 30, 30);
    _iconView.layer.cornerRadius = 15;
    _iconView.layer.masksToBounds = YES;
    _iconView.userInteractionEnabled = YES;
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconDidClick)];
    [_iconView addGestureRecognizer:iconTap];
  }
  return _iconView;
}

- (UILabel *)nameLable {
  if (!_nameLable) {
    _nameLable = [[UILabel alloc] init];
    _nameLable.textColor = ColorHex(XYTextColor_333333);
    _nameLable.font = AdaptedMediumFont(16);
    _nameLable.frame = CGRectMake(96, StatusBarHeight()+12, kScreenWidth-96-72, 20);
    _nameLable.text = self.dynamicsModel.nickName;
  }
  return _nameLable;
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _listView.dataSource = self;
        _listView.delegate = self;
      [_listView registerClass:[XYCommentListCell class] forCellReuseIdentifier:NSStringFromClass([XYCommentListCell class])];
      [_listView registerClass:[XYCommentLikeCell class] forCellReuseIdentifier:NSStringFromClass([XYCommentLikeCell class])];
      UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
      _listView.tableFooterView = footer;
      _listView.tableHeaderView = self.headerView;
      @weakify(self);
      _listView.mj_header = [XYRefreshHeader headerWithRefreshingBlock:^{
          @strongify(self);
        [self fetchNewData];
      }];
      _listView.mj_footer = [XYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self fetchNextData];
      }];
    }
    return _listView;
}

- (XYDynamicsDetailHeaderView *)headerView {
  if (!_headerView) {
    _headerView = [[XYDynamicsDetailHeaderView alloc] initWithType:self.dynamicsModel.type.integerValue contentLayout:self.dataManager.detailLayout];
    _headerView.frame = CGRectMake(0, 0, kScreenWidth, self.dataManager.headerHeight);
    _headerView.dynamicsModel = self.dynamicsModel;
    
    @weakify(self);
    _headerView.fabulousLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
      @strongify(self);
      XYDynamicFabulousViewController *likesVc = [[XYDynamicFabulousViewController alloc] init];
      likesVc.dynamicId = self.dynamicsModel.id;
      [self cyl_pushViewController:likesVc animated:YES];
    };
    
    _headerView.topicLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
      @strongify(self);
      XYTopicDetailViewController *vc = [[XYTopicDetailViewController alloc] init];
      vc.subId = self.dynamicsModel.subjectId;
      [self cyl_pushViewController:vc animated:YES];
    };
    
    
//    _headerView.creatTime = self.dynamicsModel.createTime;
//    _headerView.resources = self.dynamicsModel.images;
//    _headerView.coverImageUrl = self.dynamicsModel.coverUrl;
  }
  return _headerView;
}

-(XYDynamicsDetailDataManager *)dataManager {
  if (!_dataManager) {
    _dataManager = [[XYDynamicsDetailDataManager alloc] init];
  }
  return _dataManager;
}

- (void)dealloc {
  if (self.dynamicsModel.type.integerValue == 3) {
    [_headerView releasePlayer];
  }
}
-(XYBottomCommentView *)commentView{
  if (!_commentView) {
    _commentView = [[XYBottomCommentView alloc] initWithFrame:CGRectZero];
    @weakify(self);
    _commentView.block = ^(NSInteger index, XYDynamicsModel *obj) {
      @strongify(self);
      if (index == 0) { // 评论按钮
        [self comment];
      }else if (index == 5) { // 点赞
        [self comment];
      }else{
        [self praiseEvent:obj];
      }
    };
   // _commentView.model = [XYConsultDetailModel yy_modelWithJSON:self.params];
  }
  return _commentView;
}

// 点赞
-(void)praiseEvent:(XYDynamicsModel *)model{
 // XYDynamicsModel *model = self.layoutsArr[index].model;
  XYDynamicsFabulousAPI *api = [[XYDynamicsFabulousAPI alloc] initWithDynamicId:model.id];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      BOOL isFabulous = model.isFabulous.integerValue == 1;
      model.isFabulous = isFabulous ? @(0) : @(1);
      model.fabulous = isFabulous ? @(model.fabulous.integerValue-1) : @(model.fabulous.integerValue+1);
     // XYDynamicLayout *layout = [[XYDynamicLayout alloc] initWithModel:model];
     // [self.layoutsArr replaceObjectAtIndex:index withObject:layout];
      //if (block) block(layout, error);
    } else {
     // if (block) block(nil, error);
    }
    self.commentView.dymodel = model;
  };
  [api start];
}


//- (UIView *)commentBgView {
//  if (!_commentBgView) {
//    _commentBgView = [[UIView alloc] init];
//    _commentBgView.backgroundColor = ColorHex(@"ECECEC");
//  }
//  return _commentBgView;
//}
//
//-(YZInputView *)commentInputTF {
//    if (!_commentInputTF) {
//        _commentInputTF = [[YZInputView alloc] init];
//        _commentInputTF.backgroundColor = [UIColor whiteColor];
//        _commentInputTF.delegate = self;
//      _commentInputTF.placeholder = @"输入评论内容...";
//      _commentInputTF.placeholderColor = [UIColor grayColor];
//        _commentInputTF.returnKeyType = UIReturnKeySend;
//        _commentInputTF.cornerRadius = 4;
//        _commentInputTF.maxNumberOfLines = 5;
//        _commentInputTF.font = AdaptedFont(16);
//    }
//    return _commentInputTF;
//}
@end
