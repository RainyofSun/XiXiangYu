//
//  XYMyReleaseVC.m
//  Xiangyu
//
//  Created by GQLEE on 2021/2/25.
//

#import "XYMyReleaseVC.h"
#import "XYMyReleaseTBCell.h"
#import "XYRNBaseViewController.h"
#import "XYBlindDateViewController.h"
@interface XYMyReleaseVC ()<UITableViewDelegate,UITableViewDataSource>{
  NSArray *_titleArr;
  NSArray *_imgArr;
}

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XYMyReleaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  _titleArr = @[@"相亲需求",@"拼车需求"];//,@"资源需求",@"工作需求",@"商家展示",@"活动需求"
  _imgArr = @[@"icon_44_xiangqin",@"icon_44_pinche"];//,@"icon_44_xuqiu",@"icon_44_gongzuo",@"icon_44_shangjia",@"icon_44_huodong"
  
  [self configUI];
  
  self.view.backgroundColor = ColorHex(@"#F5F5F5");
  [self setupNavBar];
}

- (void)setupNavBar {
  self.gk_navTitle = @"我发布的";
  self.gk_navLineHidden = YES;
  self.gk_statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)configUI {
  [self.view addSubview:self.tableView];
  [self.tableView makeConstraints:^(MASConstraintMaker *make) {      make.edges.insets(UIEdgeInsetsMake(NAVBAR_HEIGHT, 0, 0, 0));
  }];
  
}
#pragma mark ---UITableViewDelegate--UITableViewDataSource---
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellstr = @"XYMyReleaseTBCell";
  XYMyReleaseTBCell *cell = (XYMyReleaseTBCell*)[tableView dequeueReusableCellWithIdentifier:cellstr];
    if (cell == nil) {
        cell = [[XYMyReleaseTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellstr];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.titleLabel.text =_titleArr[indexPath.row];
  cell.iconView.image = [UIImage imageNamed:_imgArr[indexPath.row]];
  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
      
      
      XYBlindDateViewController *vc = [[XYBlindDateViewController alloc] init];
      vc.hidesBottomBarWhenPushed = YES;
      vc.isMy = 1;
      [self cyl_pushViewController:vc animated:YES];
      
//        XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"BlindDate",@"isMy":@"1"}];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self cyl_pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
      XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"LookDemand",@"type":@"4",@"isMy":@"1"}];
      vc.hidesBottomBarWhenPushed = YES;
      [self cyl_pushViewController:vc animated:YES];
//        XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"LookDemand",@"type":@"1",@"isMy":@"1"}];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self cyl_pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
      XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"LookDemand",@"type":@"2",@"isMy":@"1"}];
      vc.hidesBottomBarWhenPushed = YES;
      [self cyl_pushViewController:vc animated:YES];
    }else if (indexPath.row == 3) {
      XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"LookDemand",@"type":@"3",@"isMy":@"1"}];
      vc.hidesBottomBarWhenPushed = YES;
      [self cyl_pushViewController:vc animated:YES];
    }else if (indexPath.row == 4) {
      XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"LookActivity",@"isMy":@"1"}];
      vc.hidesBottomBarWhenPushed = YES;
      [self cyl_pushViewController:vc animated:YES];
    }else if (indexPath.row == 5) {
      XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"LookDemand",@"type":@"4",@"isMy":@"1"}];
      vc.hidesBottomBarWhenPushed = YES;
      [self cyl_pushViewController:vc animated:YES];
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArr count];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return ADAPTATIONRATIO * 180.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma mark ------初始化------
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
      _tableView.backgroundColor = ColorHex(@"#F5F5F5");
    }
    return _tableView;
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
