//
//  XYMyWalletViewController.m
//  Xiangyu
//
//  Created by Kang on 2021/6/28.
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
#import "XYMyWalletViewController.h"
#import "XYWalletRecordTableViewCell.h"
#import "XYWalletTopView.h"
#import "XYProfileInfo.h"
#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "XYWalletQueryBillAPI.h"

#import "XYWithdrawViewController.h"
@interface XYMyWalletViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)XYWalletTopView *topView;

@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation XYMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self reshData];
}
#pragma mark - 网络请求
-(void)reshData{
  @weakify(self);
  [[XYUserService service] updateNoNeedPerfectBlock:^(BOOL success, NSDictionary *info) {
    @strongify(self);
    XYProfileInfo* obj = [XYProfileInfo yy_modelWithDictionary:info];
    self.topView.moneyLabel.text =obj.balance.stringValue?:@"0";
  }];
  self.page = 0;
  [self getList];
}
-(void)getList{
  self.page ++;
  XYShowLoading;
  @weakify(self);
  XYWalletQueryBillAPI *api = [[XYWalletQueryBillAPI alloc]initWithPage:self.page];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    @strongify(self);
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (self.page == 1) {
      [self.dataSource removeAllObjects];
    }
    XYWalletItemModelList *model = [XYWalletItemModelList yy_modelWithJSON:data];
    if (model.list.count) {
      [self.dataSource addObjectsFromArray:model.list];
    }
    [self.tableView reloadData];
//    if ([model.page.pageIndex intValue]>=[model.page.pageCount]) {
//      [self.tableView.mj_footer endRefreshing];
//    }
    
    
  };
  [api start];
}
#pragma mark - 界面布局
-(void)newView{
  self.view.backgroundColor = ColorHex(XYThemeColor_F);
  [self.view addSubview:self.topView];
  [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.view);
    make.top.equalTo(self.view).offset(NAVBAR_HEIGHT);
  }];
  
  [self.view addSubview:self.tableView];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.bottom.trailing.equalTo(self.view);
    make.top.equalTo(self.topView.mas_bottom);
  }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  XYWalletRecordTableViewCell *cell =[XYWalletRecordTableViewCell cellWithTableView:tableView indexPath:indexPath];
  cell.model = [self.dataSource objectAtIndex:indexPath.row];
  return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return AutoSize(42);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  UIView *view = [LSHControl viewWithBackgroundColor:ColorHex(XYTextColor_FFFFFF)];
  UILabel *titleLabel=[LSHControl createLabelFromFont:AdaptedFont(18) textColor:ColorHex(XYTextColor_222222) text:@"钱包明细"];
  [view addSubview:titleLabel];
  [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(view);
    make.leading.equalTo(view).offset(AutoSize(24));
  }];
  
  return view;
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
-(XYWalletTopView *)topView{
  if (!_topView) {
    _topView = [[XYWalletTopView alloc]initWithFrame:CGRectNull];
    [_topView.bgView handleTapGestureRecognizerEventWithBlock:^(id sender) {
      
      XYWithdrawViewController *likesVc = [[XYWithdrawViewController alloc] init];
      [self cyl_pushViewController:likesVc animated:YES];
    }];
  //  NSNumber *balance =[XYUserService service].fetchLoginUser. balance;
   
  }
  return _topView;
}
-(NSMutableArray *)dataSource{
  if (!_dataSource) {
    _dataSource = [NSMutableArray new];
  }
  return _dataSource;
}
#pragma mark - 导航
-(void)newNav{
  self.gk_navTitle = @"我的钱包";
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
