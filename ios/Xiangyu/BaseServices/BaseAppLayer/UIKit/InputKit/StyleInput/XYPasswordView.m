//
//  XYPasswordView.m
//  XYPasswordView
//
//  Created by edz on 2017/7/17.
//  Copyright © 2017年 刘朋坤. All rights reserved.
//

#import "XYPasswordView.h"
#define NNCodeViewHeight self.frame.size.height

@interface XYPasswordTextField : UITextField

@end

@implementation XYPasswordTextField

/// 重写 UITextFiled 子类, 解决长按复制粘贴的问题
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end

@interface XYUnderLineLable : UIView

@property (nonatomic, strong) UILabel *lable;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, assign) BOOL highlighted;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIColor *textColor;

@end

@implementation XYUnderLineLable
- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.userInteractionEnabled = NO;
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = AdaptedMediumFont(24);
    self.lable = label;
    [self addSubview:label];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ColorHex(XYThemeColor_I);
    self.line = line;
    [self addSubview:line];
  }
  return self;
}

- (void)layoutSubviews {
  self.lable.frame = CGRectMake(0, 0, self.XY_width, self.XY_height-1);
  
  self.line.frame = self.highlighted ? CGRectMake(0, self.XY_height-3, self.XY_width, 3) : CGRectMake(0, self.XY_height-1, self.XY_width, 1);
}

- (void)setHighlighted:(BOOL)highlighted {
  _highlighted = highlighted;
  self.line.backgroundColor = highlighted ? ColorHex(@"#635FF0") : ColorHex(XYThemeColor_I);
}

- (void)setText:(NSString *)text {
  _text = text;
  self.lable.text = text;
}

- (void)setTextColor:(UIColor *)textColor {
  _textColor = textColor;
  self.lable.textColor = textColor;
  
}

@end

@interface XYPasswordView() <UITextFieldDelegate>

/// 存放 label 的数组
@property (nonatomic, strong) NSMutableArray <XYUnderLineLable *> *subLables;
/// 输入文本框
@property (nonatomic, strong) XYPasswordTextField *codeTextField;

@property (nonatomic, weak) XYUnderLineLable *currentLable;

@end

@implementation XYPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)becomeInputStatus {
  [self.codeTextField becomeFirstResponder];
}
#pragma mark - setter
- (void)setNumberOfChars:(NSInteger)numberOfChars {
  _numberOfChars = numberOfChars;
  if (self.subLables.count > 0) return;
  
  for (int i = 0; i < numberOfChars; i++) {
    XYUnderLineLable *label = [[XYUnderLineLable alloc] init];
    label.textColor = ColorHex(XYTextColor_222222);
    [self addSubview:label];
    [self.subLables addObject:label];
  }
  
  [self addSubview:self.codeTextField];
}
- (void)layoutSubviews {
  
  self.codeTextField.frame = CGRectMake(0, 0, self.XY_width, self.XY_height);
  
  CGFloat labelX;
  CGFloat labelY = 0;
  CGFloat labelWidth = (self.XY_width - self.itemDistance*(self.subLables.count - 1)) / self.subLables.count;
  for (int i = 0; i < self.subLables.count; i++) {
    if (i == 0) {
        labelX = 0;
    } else {
        labelX = i * (labelWidth + self.itemDistance);
    }
    self.subLables[i].frame = CGRectMake(labelX, labelY, labelWidth, self.XY_height);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  if (textField.text.length == 0) {
    self.currentLable = self.subLables.firstObject;
  }
  self.currentLable.highlighted = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  self.currentLable.highlighted = NO;
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSInteger i = textField.text.length;
    if (i == 0) {
      self.currentLable.highlighted = NO;
      self.currentLable = [self.subLables objectAtIndex:0];
      self.currentLable.text = @"";
      self.currentLable.highlighted = YES;
    } else {
        [self.subLables objectAtIndex:i - 1].text = [NSString stringWithFormat:@"%C", [textField.text characterAtIndex:i - 1]];
        if (self.numberOfChars > i) {
          self.currentLable.highlighted = NO;
          self.currentLable = [self.subLables objectAtIndex:i];
          self.currentLable.text = @"";
          self.currentLable.highlighted = YES;
        } else {
          self.currentLable.highlighted = NO;
          self.currentLable = nil;
        }
    }
    if (self.codeBlock) {
        self.codeBlock(textField.text);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    } else if (string.length == 0) {
        return YES;
    } else if (textField.text.length >= self.numberOfChars) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - getter
- (XYPasswordTextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[XYPasswordTextField alloc] init];
        _codeTextField.backgroundColor = [UIColor clearColor];
        _codeTextField.textColor = [UIColor clearColor];
        _codeTextField.tintColor = [UIColor clearColor];
        _codeTextField.delegate = self;
        _codeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.layer.borderColor = [[UIColor grayColor] CGColor];
        [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _codeTextField;
}

- (NSMutableArray *)subLables {
    if (!_subLables) {
        _subLables = [NSMutableArray array];
    }
    return _subLables;
}

@end

