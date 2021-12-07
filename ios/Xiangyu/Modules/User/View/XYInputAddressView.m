//
//  XYInputAddressView.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/17.
//

#import "XYInputAddressView.h"
#import "TXLimitedTextField.h"

@interface XYInputAddressView ()

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) TXLimitedTextField *textField;

@property (nonatomic,strong) UIImageView *arrow;

@end

@implementation XYInputAddressView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      [self addSubview:self.titleLable];
      [self addSubview:self.textField];
      [self addSubview:self.arrow];
    }
    return self;
}

- (void)layoutSubviews {
  self.titleLable.frame = CGRectMake(0, 0, 100, self.XY_height);
  self.arrow.frame = CGRectMake(self.XY_width-22, (self.XY_height-22)/2, 22, 22);
  self.textField.frame = CGRectMake(110, 0, self.XY_width-144, self.XY_height);
}

- (void)setTitle:(NSString *)title {
  _title = title;
  if (!title.isNotBlank) {
    return;
  }
  if ([title hasPrefix:@"*"]) {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    [attr addAttributes:@{NSForegroundColorAttributeName:ColorHex(@"#FF4144")} range:NSMakeRange(0, 1)];
    [attr addAttributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_222222)} range:NSMakeRange(1, 2)];
    _titleLable.attributedText = attr;

  } else {
    _titleLable.text = title;
  }
}

- (void)setContent:(NSString *)content {
  _content = content;
  self.textField.text = content;
}
#pragma mark - getter

- (UILabel *)titleLable {
    if (!_titleLable) {
      _titleLable = [[UILabel alloc] init];
      _titleLable.font = AdaptedFont(14);
    }
    return _titleLable;
}

- (TXLimitedTextField *)textField {
    if (!_textField) {
        @weakify(self);
        _textField = [[TXLimitedTextField alloc] init];
        _textField.textColor = ColorHex(XYTextColor_222222);
        _textField.font = AdaptedFont(16);
        _textField.placeholder = @"请输入";
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.editingChangedBlock = ^(NSString *text) {
            @strongify(self);
            self.content = text;
        };
    }
    return _textField;
}

- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] init];
        _arrow.image = [UIImage imageNamed:@"ic_arrow_gray"];
    }
    return _arrow;
}
@end
