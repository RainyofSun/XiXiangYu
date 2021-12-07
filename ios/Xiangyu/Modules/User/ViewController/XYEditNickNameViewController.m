//
//  XYEditNickNameViewController.m
//  Xiangyu
//
//  Created by Kang on 2021/6/27.
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
#import "XYEditNickNameViewController.h"
#import "TXLimitedTextField.h"
#import "XYDefaultButton.h"
#import "XYProfileInfoAPI.h"
@interface XYEditNickNameViewController ()
@property(nonatomic,strong)TXLimitedTextField *nameTextField;
@property(nonatomic,strong)UILabel *limitLabel;

@property (nonatomic,strong) XYDefaultButton *submitButton;

//@property(nonatomic,strong)XYUpdateDetailAPI *api;
@end

@implementation XYEditNickNameViewController

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
  self.view.backgroundColor = ColorHex(XYThemeColor_F);
  
  [self.view addSubview:self.nameTextField];
  [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.view).offset(NAVBAR_HEIGHT+AutoSize(10));;
    make.left.right.equalTo(self.view);
    make.height.mas_equalTo(AutoSize(60));
  }];
  
  self.limitLabel.text = [NSString stringWithFormat:@"%lu/12",(unsigned long)self.nameTextField.text.length];
  @weakify(self);
  self.nameTextField.editingChangedBlock = ^(NSString *text) {
    @strongify(self);
    self.limitLabel.text = [NSString stringWithFormat:@"%lu/12",(unsigned long)text.length];
  };
  
  
  UILabel *descLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_999999) text:@"昵称每个月只能修改一次"];
  [self.view addSubview:descLabel];
  [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.nameTextField.mas_bottom).offset(AutoSize(4));;
    make.left.equalTo(self.view).offset(AutoSize(16));
    //make.height.mas_equalTo(AutoSize(60));
  }];
  
  [self.view addSubview:self.submitButton];
}
- (TXLimitedTextField *)nameTextField {
    if (!_nameTextField) {
      _nameTextField = [[TXLimitedTextField alloc] init];
      _nameTextField.textColor = ColorHex(XYTextColor_222222);
      _nameTextField.font = AdaptedFont(16);
//      _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
      _nameTextField.backgroundColor = [UIColor whiteColor];
      UIView *left=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AutoSize(16), AutoSize(60))];
      _nameTextField.leftView = left;
      _nameTextField.leftViewMode = UITextFieldViewModeAlways;
      
      UIView *rigth=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AutoSize(52), AutoSize(60))];
      _nameTextField.rightView = rigth;
      _nameTextField.rightViewMode = UITextFieldViewModeAlways;
      
      self.limitLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_999999) text:@"0/12"];
      self.limitLabel.frame = rigth.bounds;
      [rigth addSubview:self.limitLabel];
//      [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(rigth);
//      }];
      
      
      
      
      _nameTextField.text = [self.pram objectForKey:@"nickName"];
      _nameTextField.limitedNumber = 12;
      _nameTextField.placeholder = @"请输入昵称";
    }
    return _nameTextField;
}
- (XYDefaultButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [XYDefaultButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"确认修改" forState:UIControlStateNormal];
      _submitButton.frame = CGRectMake(40, kScreenWidth-100, kScreenWidth-80, 48);
      [_submitButton addTarget:self action:@selector(bindAccount) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
-(void)bindAccount{
  if (!self.nameTextField.text.isNotBlank) {
    XYToastText(@"请输入昵称");
    return;
  }
  NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.pram];
  [dic setValue:self.nameTextField.text forKey:@"nickName"];
  XYUpdateDetailAPI *api = [[XYUpdateDetailAPI alloc]initWithUserId:[XYUserService service].fetchLoginUser.userId data:dic];
  @weakify(self);
  XYShowLoading;
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    @strongify(self);
    XYHiddenLoading;
    if (error) {
      XYToastText(error.msg);
    }else{
      if (self.saveBlock) {
        self.saveBlock(self.nameTextField.text);
      }
      XYToastText(@"修改成功");
      [self.navigationController popViewControllerAnimated:YES];
    }
  };
  [api start];
  
 
}
#pragma mark - 导航
-(void)newNav{
  self.gk_navTitle = @"昵称";
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
