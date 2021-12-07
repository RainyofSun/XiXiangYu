//
//  XYWithdrawSuccessViewController.m
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
#import "XYWithdrawSuccessViewController.h"
#import "OrderKeyValueView.h"
@interface XYWithdrawSuccessViewController ()

@end

@implementation XYWithdrawSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];
    [self reshData];
}
#pragma mark - 网络请求
-(void)reshData{
   
}
#pragma mark - 界面布局
-(void)newView{
  UIImageView *imageView = [LSHControl createImageViewWithImageName:@"caozuochenggong"];
  [self.view addSubview:imageView];
  [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.top.equalTo(self.view).offset(NAVBAR_HEIGHT+AutoSize(20));
    make.width.height.mas_equalTo(AutoSize(80));
  }];;
  
  UILabel *titleLabel = [LSHControl createLabelFromFont:AdaptedFont(18) textColor:ColorHex(@"#06C163") text:@"提现成功"];
  [self.view addSubview:titleLabel];
  [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.top.equalTo(imageView.mas_bottom).offset(AutoSize(16));
  }];;
  
  UILabel *subtitleLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_999999) text:@"提现金额将于两个工作日内到账"];
  [self.view addSubview:subtitleLabel];
  [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.top.equalTo(titleLabel.mas_bottom).offset(AutoSize(4));
  }];;
  
  UIView *lineView =[LSHControl viewWithBackgroundColor:ColorHex(XYThemeColor_E)];
  [self.view addSubview:lineView];
  [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.top.equalTo(subtitleLabel.mas_bottom).offset(AutoSize(10));
    make.leading.equalTo(self.view).offset(AutoSize(15));
    make.height.mas_equalTo(1);
  }];;
  
  OrderKeyValueView *moneyView = [OrderKeyValueView initWithTitleLabel:@"提现金额" valueLabel:[NSString stringWithFormat:@"¥%@",self.money]];
  [self.view addSubview:moneyView];
  [moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.top.equalTo(lineView.mas_bottom).offset(AutoSize(18));
    make.leading.equalTo(self.view).offset(AutoSize(15));
    make.height.mas_equalTo(AutoSize(32));
  }];;
  
  OrderKeyValueView *countView = [OrderKeyValueView initWithTitleLabel:@"收款账户" valueLabel:self.type == 2?@"支付宝账户":@"微信账户"];
  [self.view addSubview:countView];
  [countView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.top.equalTo(moneyView.mas_bottom);
    make.leading.equalTo(self.view).offset(AutoSize(15));
    make.height.mas_equalTo(AutoSize(32));
  }];;
  
}
#pragma mark - 导航
-(void)newNav{
  self.gk_navTitle = @"提现";
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
