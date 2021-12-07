//
//  XYDynamicFabulousViewController.m
//  Xiangyu
//
//  Created by Kang on 2021/7/4.
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
#import "XYDynamicFabulousViewController.h"
#import "XYFabulousTableViewCell.h"
#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "XYDynamicsLikesUserAPI.h"

#import "ChatViewController.h"
#import "FriendRequestViewController.h"
@interface XYDynamicFabulousViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)NSMutableArray *dataSource;

@end

@implementation XYDynamicFabulousViewController

#pragma mark - 网络请求
-(void)reshData{
  self.page = 0;
  [self getList];
}
-(void)getList{
  self.page ++;
  XYDynamicsLikesUserAPI *api = [[XYDynamicsLikesUserAPI alloc]initWithDynamicId:self.dynamicId page:self.page];
  @weakify(self);
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    //XYHiddenLoading;
    @strongify(self);
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (self.page == 1) {
      [self.dataSource removeAllObjects];
    }
    XYLikesUserListModel *model = [XYLikesUserListModel yy_modelWithJSON:data];
    if (model.list.count) {
      [self.dataSource addObjectsFromArray:model.list];
    }
    [self.tableView reloadData];
  };
  [api start];
}
#pragma mark - 界面布局
-(void)newView{
  self.view.backgroundColor = ColorHex(XYThemeColor_F);

  [self.view addSubview:self.tableView];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.bottom.trailing.equalTo(self.view);
    make.top.equalTo(self.view).offset(NAVBAR_HEIGHT);
  }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  XYLikesUserModel *model = [self.dataSource objectAtIndex:indexPath.row];
  
  XYFabulousTableViewCell *cell =[XYFabulousTableViewCell cellWithTableView:tableView indexPath:indexPath];
  cell.model =model;
  @weakify(self);
  [cell.chatBtn handleControlEventWithBlock:^(id sender) {
    @strongify(self);
    [self addFriends:model];
  }];
  return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)addFriends:(XYLikesUserModel*)model {
  //if ([model.isFriend integerValue]) {
    TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
    data.conversationID = [NSString stringWithFormat:@"c2c_%@",model.userId];
    data.userID = model.userId.stringValue;
    data.title = model.nickName;
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.conversationData = data;
    [self cyl_pushViewController:chat animated:YES];
  //} else {
//    XYShowLoading;
//    if (model.userId) {
//      [[V2TIMManager sharedInstance] getUsersInfo:@[model.userId.stringValue] succ:^(NSArray<V2TIMUserFullInfo *> *infoList) {
//        XYHiddenLoading;
//        FriendRequestViewController *frc = [[FriendRequestViewController alloc] init];
//        frc.profile = infoList.firstObject;
//        [self cyl_pushViewController:frc animated:YES];
//      } fail:^(int code, NSString *msg) {
//        XYHiddenLoading;
//        XYToastText(msg);
//      }];
//    }
//  }
}

-(UITableView *)tableView{
  if (!_tableView) {
    _tableView = [LSHControl createTableViewWithFrame:self.view.bounds style:UITableViewStylePlain dataSource:self delegate:self];
    _tableView.estimatedRowHeight = AutoSize(152);
    _tableView.rowHeight = UITableViewAutomaticDimension;
    @weakify(self);
    _tableView.mj_header = [XYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
      [self reshData];
    }];
    _tableView.mj_footer = [XYRefreshFooter footerWithRefreshingBlock:^{
      @strongify(self);
      [self getList];
    }];
  }
  return _tableView;
}

-(NSMutableArray *)dataSource{
  if (!_dataSource) {
    _dataSource = [NSMutableArray new];
  }
  return _dataSource;
}
#pragma mark - 导航
-(void)newNav{
  self.gk_navTitle = @"点赞列表";
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
