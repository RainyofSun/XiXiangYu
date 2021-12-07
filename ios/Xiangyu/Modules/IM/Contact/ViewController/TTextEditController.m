//
//  EditInfoViewController.m
//  TUIKit
//
//  Created by annidyfeng on 2019/3/11.
//  Copyright © 2019年 annidyfeng. All rights reserved.
//

#import "TTextEditController.h"
#import "THeader.h"
#import "UIColor+TUIDarkMode.h"
#import "NSBundle+TUIKIT.h"
#import "TCContext.h"
#import "UIBarButtonItem+GKNavigationBar.h"
#import "ReactiveObjC/ReactiveObjC.h"


@interface TTextField : UITextField
@property int margin;
@end


@implementation TTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    int margin = self.margin;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    int margin = self.margin;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - margin, bounds.size.height);
    return inset;
}

@end

@interface TTextEditController ()
//@property(nonatomic,strong)TXLimitedTextField *nameTextField;
@property(nonatomic,strong)UILabel *limitLabel;
@end

@implementation TTextEditController

// MLeaksFinder 会对这个类误报，这里需要关闭一下

- (BOOL)willDealloc {
    return NO;
}

- (instancetype)initWithText:(NSString *)text;
{
    if (self = [super init]) {
        _textValue = text;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gk_navTitle=@"备注";
    
  
  
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
  self.gk_navRightBarButtonItem = [UIBarButtonItem gk_itemWithTitle:@"保存" color:ColorHex(XYTextColor_FE2D63) font:[UIFont systemFontOfSize:15] target:self action:@selector(onSave)];
  
  
  //[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(onSave)];
  
    self.view.backgroundColor = [UIColor d_colorWithColorLight:TController_Background_Color dark:TController_Background_Color_Dark];

  
  
  _nameTextField = [[TXLimitedTextField alloc] init];
  _nameTextField.textColor = ColorHex(XYTextColor_222222);
  _nameTextField.font = AdaptedFont(16);
//      _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _nameTextField.backgroundColor = [UIColor whiteColor];
  UIView *left=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AutoSize(16), AutoSize(54))];
  _nameTextField.leftView = left;
  _nameTextField.leftViewMode = UITextFieldViewModeAlways;
  
  UIView *rigth=[[UIView alloc]initWithFrame:CGRectMake(0, 0, AutoSize(52), AutoSize(54))];
  _nameTextField.rightView = rigth;
  _nameTextField.rightViewMode = UITextFieldViewModeAlways;
  
  self.limitLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_999999) text:@"0/12"];
  self.limitLabel.frame = rigth.bounds;
  [rigth addSubview:self.limitLabel];
//      [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(rigth);
//      }];

  _nameTextField.limitedNumber = 12;
  _nameTextField.placeholder = @"备注";
  
//    _inputTextField = [[TTextField alloc] initWithFrame:CGRectZero];
//    _inputTextField.text = [self.textValue stringByTrimmingCharactersInSet:
//                                           [NSCharacterSet illegalCharacterSet]];
//    [(TTextField *)_inputTextField setMargin:10];
//    _inputTextField.backgroundColor = [UIColor d_colorWithColorLight:TCell_Nomal dark:TCell_Nomal_Dark];
  _nameTextField.frame = CGRectMake(0, 10+NAVBAR_HEIGHT, self.view.frame.size.width, AutoSize(54));
//    _inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_nameTextField];
//  [[_inputTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
//    if (self.inputTextField.text.length>=12) {
//      self.inputTextField.text = [self.inputTextField.text substringToIndex:12];
//    }
//  }];
  
  
  self.limitLabel.text = [NSString stringWithFormat:@"%lu/12",(unsigned long)self.nameTextField.text.length];
  @weakify(self);
  self.nameTextField.editingChangedBlock = ^(NSString *text) {
    @strongify(self);
    self.limitLabel.text = [NSString stringWithFormat:@"%lu/12",(unsigned long)text.length];
  };
}


- (void)onSave
{
    self.textValue = [self.nameTextField.text stringByTrimmingCharactersInSet:
                      [NSCharacterSet illegalCharacterSet]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
