//
//  XYHeartProfessViewController.m
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
#import "XYHeartProfessViewController.h"
#import "XYProfessItemView.h"
#import "XYProfessBottomView.h"
#import "XYProfessGetProfess.h"
@interface XYHeartProfessViewController ()
@property(nonatomic,strong)XYProfessTopView *topView;
@property(nonatomic,strong)XYProfessBottomView *bottomView;

//@property(nonatomic,strong)XYProfessGetProfess *api;
@end

@implementation XYHeartProfessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self reshData];
}
#pragma mark - 网络请求
-(void)reshData{
  XYShowLoading;
  XYProfessGetProfess *api = [XYProfessGetProfess new];
  @weakify(self);
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    @strongify(self);
    XYHiddenLoading;
    self.topView.model = [XYGetProfessModel yy_modelWithJSON:data];
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
  
  [self.view addSubview:self.bottomView];
  [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.view);
    make.top.equalTo(self.topView.mas_bottom);
  }];
}
-(XYProfessBottomView *)bottomView{
  if (!_bottomView) {
    _bottomView = [[XYProfessBottomView alloc]initWithFrame:CGRectZero];
  }
  return _bottomView;
}
-(XYProfessTopView *)topView{
  if (!_topView) {
    _topView = [[XYProfessTopView alloc]initWithFrame:CGRectZero];
  }
  return _topView;
}
#pragma mark - 导航
-(void)newNav{
  self.gk_navTitle = @"心动记录";
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
