//
//  XYNewsCommentViewController.m
//  Xiangyu
//
//  Created by Kang on 2021/7/10.
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
#import "XYNewsCommentViewController.h"
#import "XYBottomCommentView.h"
#import "XYConsultAPI.h"
#import "XYCommentListCell.h"

#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
@interface XYNewsCommentViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)XYBottomCommentView *commentView;

@property (strong, nonatomic) UITableView *listView;
@property (nonatomic, assign) NSUInteger page;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation XYNewsCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self newNav];
    [self newView];
    [self fetchNewData];
}
#pragma mark - 网络请求
-(void)fetchNewData{
  self.page = 0;
  [self fetchNextData];
}
-(void)fetchNextData{
  self.page ++;
  XYGetConsultCommentListAPI *api = [[XYGetConsultCommentListAPI alloc]initWithConsultId:self.commentView.model.id page:self.page];
  @weakify(self);
  XYShowLoading;
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    @strongify(self);
    [self.listView.mj_header endRefreshing];
    [self.listView.mj_footer endRefreshing];
    if (!error) {
      if (self.page == 1) {
        [self.dataSource removeAllObjects];
      }
      NSArray *arr = data[@"commentResp"];
      [self.dataSource addObjectsFromArray:[NSArray yy_modelArrayWithClass:[XYCommentModel class] json:arr]];
      if (!arr || arr.count == 0) {
      //  self.page --;
      }
    } else {
     // self.page --;
     // if (commentErrorBlock) commentErrorBlock(error);
    }
    [self.listView reloadData];
  };
  [api start];
}
#pragma mark - 界面布局
-(void)newView{
//  [self.view addSubview:self.commentView];
//  [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.leading.trailing.bottom.equalTo(self.view);
//  }];
  
  [self.view addSubview:self.listView];
  self.listView.backgroundColor = ColorHex(XYTextColor_FFFFFF);
  [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.view);
    make.top.equalTo(self.view).offset(GK_STATUSBAR_NAVBAR_HEIGHT);
    make.bottom.equalTo(self.view);
  }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  //if (section == 0) return 1;
  
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    XYCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XYCommentListCell class]) forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    cell.isFirstCell = indexPath.row == 0;
  cell.deleteBtn.alpha = 0;
   // @weakify(self);
//    cell.deleteBlock = ^{
//     [weak_self deleteCommentWithIndexPath:indexPath];
//    };
    return cell;
  
}
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
-(NSMutableArray *)dataSource{
  if (!_dataSource) {
    _dataSource = [NSMutableArray new];
  }
  return _dataSource;
}
- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _listView.dataSource = self;
        _listView.delegate = self;
      [_listView registerClass:[XYCommentListCell class] forCellReuseIdentifier:NSStringFromClass([XYCommentListCell class])];
      //[_listView registerClass:[XYCommentLikeCell class] forCellReuseIdentifier:NSStringFromClass([XYCommentLikeCell class])];
      UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
      _listView.tableFooterView = footer;
     // _listView.tableHeaderView = self.headerView;
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
-(XYBottomCommentView *)commentView{
  if (!_commentView) {
    _commentView = [[XYBottomCommentView alloc] initWithFrame:CGRectZero];
    _commentView.model = [XYConsultDetailModel yy_modelWithJSON:self.params];
//    @weakify(self);
//    _commentView.block = ^(NSInteger index, XYConsultDetailModel *obj) {
//      @strongify(self);
//      if (index == 0) { // 评论按钮
//       // [self comment];
//        //
//
//       // XYNewsCommentViewController *vc = [[XYNewsCommentViewController alloc] init];
//       // vc.params = self.params;
//       // [self cyl_pushViewController:vc animated:YES];
//      }else if (index == 5) { // 点赞
//       // [self comment];
//      }else{
//       // [self praiseEvent:obj];
//      }
//    };
  }
  return _commentView;
}
#pragma mark - 导航
-(void)newNav{
  self.gk_navTitle = @"评论";
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
