//
//  XYInputTextField.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYInputTextField.h"
#import "TXLimitedTextField.h"

@interface XYInputTextField ()

@property (nonatomic,strong) UIView *separter;

@property (nonatomic,strong) TXLimitedTextField *textField;

@end

@implementation XYInputTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorHex(XYThemeColor_B);
        [self addSubview:self.textField];
        [self addSubview:self.separter];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
  self.separter.frame = CGRectMake(0, self.XY_height-1, self.XY_width, 1);
  
  self.textField.frame = CGRectMake(0, 0, self.XY_width, self.XY_height-1);
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

- (void)setShoundSeparter:(BOOL)shoundSeparter {
  _shoundSeparter = shoundSeparter;
  self.separter.hidden = !shoundSeparter;
}

- (void)setText:(NSString *)text {
    _text = text;
    self.textField.text = text;
}

- (void)setShouldClear:(BOOL)shouldClear {
    _shouldClear = shouldClear;
    if (shouldClear) {
        self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    } else {
        self.textField.clearButtonMode = UITextFieldViewModeNever;
    }
}

- (void)setShoundBoard:(BOOL)shoundBoard {
    _shoundBoard = shoundBoard;
    if (shoundBoard) {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = ColorHex(XYThemeColor_F).CGColor;
    }
}
- (void)setMaxInputNum:(NSInteger)maxInputNum {
    _maxInputNum = maxInputNum;
    self.textField.limitedNumber = maxInputNum;
}
- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.textField.keyboardType = keyboardType;
}
- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    _secureTextEntry = secureTextEntry;
    self.textField.secureTextEntry = secureTextEntry;
}
#pragma mark - getter
- (UIView *)separter {
    if (!_separter) {
        _separter = [[UIView alloc] init];
      _separter.backgroundColor = ColorHex(XYThemeColor_F);
    }
    return _separter;
}
- (TXLimitedTextField *)textField {
    if (!_textField) {
        @weakify(self);
        _textField = [[TXLimitedTextField alloc] init];
        _textField.textColor = ColorHex(XYTextColor_222222);
        _textField.font = AdaptedFont(XYFont_E);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.editingChangedBlock = ^(NSString *text) {
            @strongify(self);
            self.text = text;
        };
    }
    return _textField;
}
-(void)setTextColor:(UIColor *)textColor{
  _textField.textColor = textColor;
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
  
  NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_textField.placeholder attributes:
      @{NSForegroundColorAttributeName:placeholderColor,
                      NSFontAttributeName:_textField.font
      }];
  _textField.attributedPlaceholder = attrString;
  
  
}
-(void)setPaddingHorizontal:(CGFloat)paddingHorizontal{
  if (paddingHorizontal>0) {
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.rightViewMode = UITextFieldViewModeAlways;
    
    self.textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, paddingHorizontal, paddingHorizontal)];
    self.textField.rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, paddingHorizontal, paddingHorizontal)];
  }else{
    self.textField.leftViewMode = UITextFieldViewModeNever;
    self.textField.rightViewMode = UITextFieldViewModeNever;
  }
}
@end
