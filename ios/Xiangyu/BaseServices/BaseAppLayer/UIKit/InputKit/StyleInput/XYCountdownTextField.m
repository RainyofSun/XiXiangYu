//
//  XYCountdownTextField.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/19.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYCountdownTextField.h"
#import "TXLimitedTextField.h"
#import "YYTimer.h"

@interface XYCountdownTextField ()

@property (nonatomic,strong) TXLimitedTextField *textField;

@property (nonatomic,strong) UIButton *countdownButton;

@end

@implementation XYCountdownTextField
{
    YYTimer *timer_;
    NSInteger time_;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorHex(XYThemeColor_B);
        time_ = 60;
        [self addSubview:self.countdownButton];
        [self addSubview:self.textField];
        [self addConstraints];
        
    }
    return self;
}
#pragma mark - event
- (void)fire {
    timer_ = [YYTimer timerWithTimeInterval:1.0 target:self selector:@selector(countdownTime) repeats:YES];
    [timer_ fire];
}
- (void)countdownTime {
    if (time_ == 0) {
        time_ = 60;
        [timer_ invalidate];
        timer_ = nil;
        self.countdownButton.enabled = YES;
        [self.countdownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    } else {
        self.countdownButton.enabled = NO;
        [self.countdownButton setTitle:[NSString stringWithFormat:@"%lds后重新获取",time_] forState:UIControlStateNormal];
        time_ --;
    }
}

- (void)obtainCode:(UIButton *)sender {
    if (self.actionBlock) {
        self.actionBlock();
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.XY_height / 2;
}

- (void)addConstraints {
    
    [self.countdownButton remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).with.offset(-AdaptedWidth(20));
        make.centerY.equalTo(self);
    }];
    
    [self.textField remakeConstraints:^(MASConstraintMaker *make) {
        make.right.greaterThanOrEqualTo(self.countdownButton.mas_left).with.offset(-AdaptedWidth(20));
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
- (void)setFireEnable:(BOOL)fireEnable {
    _fireEnable = fireEnable;
    self.countdownButton.enabled = fireEnable;
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
#pragma mark - getter
- (TXLimitedTextField *)textField {
    if (!_textField) {
        _textField = [[TXLimitedTextField alloc] init];
        _textField.textColor = ColorHex(XYTextColor_222222);
        _textField.font = AdaptedFont(16);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [_textField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        @weakify(self);
        _textField.editingChangedBlock = ^(NSString *text) {
            @strongify(self);
            self.text = text;
        };
    }
    return _textField;
}
- (UIButton *)countdownButton {
    if (!_countdownButton) {
        _countdownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_countdownButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _countdownButton.titleLabel.font = AdaptedFont(16);
        [_countdownButton setTitleColor:ColorHex(XYTextColor_222222) forState:UIControlStateNormal];
        [_countdownButton setTitleColor:ColorHex(XYTextColor_CCCCCC) forState:UIControlStateDisabled];
        [_countdownButton addTarget:self action:@selector(obtainCode:) forControlEvents:UIControlEventTouchUpInside];
        [_countdownButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _countdownButton;
}

@end
