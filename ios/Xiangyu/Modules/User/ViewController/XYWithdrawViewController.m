//
//  XYWithdrawViewController.m
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
#import "XYWithdrawViewController.h"
#import "XYWithdrawTypeTableViewCell.h"
#import "XYWithdrawMoneyTableViewCell.h"
#import "XYRemindPopView.h"
#import "XYRNBaseViewController.h"
#import "JSHAREService.h"
#import "XYWalletQueryBillAPI.h"
#import <AlipaySDK/AlipaySDK.h>

#import "XYWithdrawSuccessViewController.h"
@interface XYWithdrawViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)NSString *currentMoney;

@property(nonatomic,strong)UIButton *releaseButton;
@end

@implementation XYWithdrawViewController

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
  self.view.backgroundColor = ColorHex(XYTextColor_FFFFFF);

  [self.view addSubview:self.releaseButton];
  
  [self.view addSubview:self.tableView];
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.equalTo(self.view);
    make.top.equalTo(self.view).offset(NAVBAR_HEIGHT);
    make.bottom.equalTo(self.releaseButton.mas_top);
  }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if (section == 0) {
    return 2;
  }
  return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.section == 0) {
    XYWithdrawTypeTableViewCell *cell = [XYWithdrawTypeTableViewCell cellWithTableView:tableView indexPath:indexPath];
    cell.selectBtn.selected = (self.indexPath && self.indexPath.row == indexPath.row);
    cell.titleLabel.text =indexPath.row== 0?@"提现至微信钱包":@"提现至支付宝";
    cell.headerImage.image = indexPath.row== 0?[UIImage imageNamed:@"iocn_32_weixin"]:[UIImage imageNamed:@"icon_32_zhifub"];
    return cell;
  }
  XYWithdrawMoneyTableViewCell *cell =[XYWithdrawMoneyTableViewCell cellWithTableView:tableView indexPath:indexPath];
  cell.currentObj = self.currentMoney;
  cell.dataSource = @[@"10元",@"20元",@"30元",@"50元",@"100元",@"500元"];
  
  return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  return AutoSize(60);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  UIView *view = [LSHControl viewWithBackgroundColor:ColorHex(XYTextColor_FFFFFF)];
  UILabel *titleLabel = [LSHControl createLabelFromFont:AdaptedFont(18) textColor:ColorHex(XYTextColor_222222) text:section?@"请选择提现金额":@"提现方式"];
  [view addSubview:titleLabel];
  [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(view.mas_centerY).offset(AutoSize(15));
    make.leading.equalTo(view).offset(AutoSize(38));
  }];
  return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
  if (section) {
    return AutoSize(30);
  }
  return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
  if (section) {
    UIView *view = [LSHControl viewWithBackgroundColor:ColorHex(XYTextColor_FFFFFF)];
    YYLabel *titleLabel = [[YYLabel alloc] init];;
    [view addSubview:titleLabel];
    
    NSMutableAttributedString *all_attr = [NSMutableAttributedString new];

    
    
    NSMutableAttributedString *textt_attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"规则说明"]];
    textt_attr.yy_font = AdaptedFont(14);
    textt_attr.yy_color = ColorHex(@"#6160F0");
    [all_attr appendAttributedString:textt_attr];

      UIImage *image = [UIImage imageNamed: @"remind"];
      NSMutableAttributedString *image_attr = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:AdaptedFont(14) alignment:YYTextVerticalAlignmentCenter];
      [all_attr appendAttributedString:image_attr];
  
    titleLabel.attributedText = all_attr;
    @weakify(self);
    titleLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
      @strongify(self);
      [self remandView];
    };
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(view);
      make.width.mas_equalTo(AutoSize(120));
      make.leading.equalTo(view).offset(AutoSize(38));
    }];
    return view;
  }
  return nil;
}

-(void)remandView{
  
  XYRemindPopView *popView=[[XYRemindPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/0.85)];
  popView.titleLabel.text = @"提现规则说明";
  popView.textView.text = @"提现渠道：\n喜乡遇平台“我的钱包”余额支持现金提现，目前支持微信提现和支付宝提现2种提现方式；实名认证：用户进行现金提现前，务必先将个人账号完成实名认证，且保证认证信息与微信、支付宝个人信息一致，否则将导致现金提现失败。\n\n提现金额：\n平台目前仅支持10元、20元、50元、100元、500元数额的提现金额，若您提现后仍有部分余额未能提现，请累积至已有提现金额选项数额后继续提现；\n\n到账时间：\n用户申请现金提现后，提现金额将于2个工作日内成功到账，请耐心等待；\n\n异常情况：\n若账号因恶意违规被";
  [popView show];
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.section == 0) {
    self.indexPath = indexPath;
    [tableView reloadData];
  }
}
-(UITableView *)tableView{
  if (!_tableView) {
    _tableView = [LSHControl createTableViewWithFrame:self.view.bounds style:UITableViewStylePlain dataSource:self delegate:self];
    _tableView.estimatedRowHeight = AutoSize(152);
    _tableView.rowHeight = UITableViewAutomaticDimension;
  }
  return _tableView;
}
- (UIButton *)releaseButton {
  if (!_releaseButton) {
    _releaseButton = [[UIButton alloc] initWithFrame:CGRectMake(ADAPTATIONRATIO * 30, SCREEN_HEIGHT-ADAPTATIONRATIO * 140-SafeAreaBottom(), SCREEN_WIDTH - ADAPTATIONRATIO * 60, ADAPTATIONRATIO * 88)];
    [_releaseButton setBackgroundColor:ColorHex(@"#F92B5E")];
    [_releaseButton setTitle:@"提现" forState:UIControlStateNormal];
    [_releaseButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    _releaseButton.layer.cornerRadius = ADAPTATIONRATIO * 44;
    _releaseButton.layer.masksToBounds = YES;
    [_releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_releaseButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
  }
  return _releaseButton;
}

-(void)submit{
  [[XYUserService service] updateNoNeedPerfectBlock:^(BOOL success, NSDictionary *info) {
     if ([[info objectForKey:@"status"] integerValue]!=2) {
       
       
       UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未实名认证" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                  XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"Auth"}];
                  [self cyl_pushViewController:vc animated:YES];
                  //resolve(@{@"type":@"2"});
                }]];
                    // 弹出对话框
                    [self  presentViewController:alert animated:true completion:nil];

     }else {
        
       if (!self.indexPath) {
         XYToastText(@"请选择提现方式");
         return;
       }
       
       if (!self.currentMoney) {
         XYToastText(@"请选择提现金额");
         return;
       }
       
       NSString *modey = [self.currentMoney stringByReplacingOccurrencesOfString:@"元" withString:@""];
       
       
       
       
       XYUserInfo *newInfo = [XYUserInfo yy_modelWithJSON:info];
       if ([modey doubleValue]>[newInfo.balance doubleValue]) {
         XYToastText(@"余额不足");
         return;
       }
       
       if (self.indexPath.row == 0) {
         [self wxchat];
       }else{
         [self zhifubao];
       }
       
       
     }
   }];
}

-(void)wxchat{
  [JSHAREService cancelAuthWithPlatform:JSHAREPlatformWechatSession];
  [JSHAREService getSocialUserInfo:JSHAREPlatformWechatSession handler:^(JSHARESocialUserInfo *userInfo, NSError *error) {
    if (!error) {
      [ self withdrawWithType:1 openId:userInfo.openid];
    }
  }];
}
-(void)zhifubao{
  XYWalletOAuth2UrlAPI *api =[[XYWalletOAuth2UrlAPI alloc] init];
  XYShowLoading;
  @weakify(self);
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    @strongify(self);
    if (error) {
      XYToastText(error.msg);
    }else{
      
      
      
      [[AlipaySDK defaultService] auth_V2WithInfo:[data objectForKey:@"data"] fromScheme:@"XiXiangYu" callback:^(NSDictionary *resultDic) {

       if (resultDic && [resultDic objectForKey:@"result"] ) {
          NSDictionary *dic =[ self jiexiUrl:[resultDic objectForKey:@"result"]];
           if (dic) {
             [ self withdrawWithType:2 openId:[dic objectForKey:@"openid"]];
          }
      }
        
         }];
    }
    
    
    
  };
  [api start];
  
}
-(NSDictionary *)jiexiUrl:(NSString *)codeUrlvaule{
    
    NSArray * array = [codeUrlvaule componentsSeparatedByString:@"?"];
    NSString *str1=[array lastObject];
    NSArray *array1=[str1 componentsSeparatedByString:@"&"];
   // NSString *auth_code=[self getUrlValue:@"auth_code" withArray:array1];//取url参数id的值
    NSString *user_id=[self getUrlValue:@"user_id" withArray:array1];//取url参数name的值
     if (user_id && user_id.length>0)  {
         return @{@"openid":user_id,@"type":@"2"};
    }else{
        return nil;
    }
   
}
- (NSString *)getUrlValue:(NSString *) nst withArray:(NSArray *)array{
    NSString *strValue=@"";
    for (NSString *str in array) {
        NSRange range1 = [str rangeOfString:nst];
        if (range1.location!=NSNotFound) {
            strValue=[str substringFromIndex:range1.length+1];
            NSLog(@"strvalue=%@",strValue);
        }
    }
    return strValue;
}
-(void)withdrawWithType:(NSInteger)type openId:(NSString *)openid{
  
  NSString *modey = [self.currentMoney stringByReplacingOccurrencesOfString:@"元" withString:@""];
  XYShowLoading;
  @weakify(self);
  XYWalletApplyCashAPI *api = [[XYWalletApplyCashAPI alloc] initWithAmt:modey.numberValue openId:openid payChannel:@(type)];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    XYHiddenLoading;
    @strongify(self);
    if (error) {
      XYToastText(error.msg);
    }else{
      XYWithdrawSuccessViewController *VC = [[XYWithdrawSuccessViewController alloc]init];
      VC.money = modey;
      VC.type = type;
      [self cyl_pushViewController:VC animated:YES];
     // if (self.saveBlock) {
        //self.saveBlock(self.nameTextField.text);
     // }
//      XYToastText(@"提现成功");
//      [self.navigationController popViewControllerAnimated:YES];
    }
  };
  [api start];
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
