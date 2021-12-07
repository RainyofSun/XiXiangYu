//
//  XYSecurityTextField.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/19.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYSecurityTextField.h"
#import "TXLimitedTextField.h"

@interface XYSecurityTextField ()

@property (nonatomic,strong) TXLimitedTextField *textField;

@property (nonatomic,strong) UIButton *visibleButton;

@end

@implementation XYSecurityTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorHex(XYThemeColor_B);
        [self addSubview:self.visibleButton];
        [self addSubview:self.textField];
        [self addConstraints];
        
    }
    return self;
}
#pragma mark - event
- (void)security:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.textField.secureTextEntry = !sender.isSelected;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.XY_height / 2;
}

- (void)addConstraints {
    
    [self.visibleButton makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-AdaptedWidth(20));
        make.centerY.equalTo(self);
    }];
    
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.right.greaterThanOrEqualTo(self.visibleButton.mas_left).with.offset(-AdaptedWidth(20));
        make.left.equalTo(self.mas_left).with.offset(AdaptedWidth(20));
        make.top.bottom.equalTo(self);
    }];
}
#pragma mark - setter
- (void)setText:(NSString *)text {
    _text = text;
    self.textField.text = text;
}
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
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
#pragma mark - getter
- (TXLimitedTextField *)textField {
    if (!_textField) {
        _textField = [[TXLimitedTextField alloc] init];
        _textField.textColor = ColorHex(XYTextColor_222222);
        _textField.font = AdaptedFont(16);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.secureTextEntry = YES;
        [_textField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        @weakify(self);
        _textField.editingChangedBlock = ^(NSString *text) {
            @strongify(self);
            self.text = text;
        };
    }
    return _textField;
}
- (UIButton *)visibleButton {
    if (!_visibleButton) {
        _visibleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_visibleButton setImage:[UIImage imageNamed:@"login_icon_eye_close"] forState:UIControlStateNormal];
        [_visibleButton setImage:[UIImage imageNamed:@"login_icon_eye_open"] forState:UIControlStateSelected];
        [_visibleButton addTarget:self action:@selector(security:) forControlEvents:UIControlEventTouchUpInside];
        [_visibleButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _visibleButton;
}

@end
