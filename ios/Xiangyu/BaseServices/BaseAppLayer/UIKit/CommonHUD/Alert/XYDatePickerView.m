//
//  XYDatePickerView.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/19.
//

#import "XYDatePickerView.h"

@interface XYDatePickerView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) UILabel *detailLable;

@property (nonatomic,strong) UIDatePicker *picker;

@property (nonatomic,strong) UIButton *sureButton;

@property (nonatomic,strong) UIButton *cancleButton;


@end

@implementation XYDatePickerView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      self.backgroundColor = UIColorAlpha(XYThemeColor_D, XYColorAlpha_0);
      [self addSubviews];
      [self layoutPageSubviews];
    }
    return self;
}

- (void)addSubviews {
  [self addSubview:self.contentView];
  [self.contentView addSubview:self.topView];
  [self.topView addSubview:self.line];
  [self.topView addSubview:self.detailLable];
  [self.topView addSubview:self.cancleButton];
  [self.topView addSubview:self.sureButton];
  [self.contentView addSubview:self.picker];
}

- (void)layoutPageSubviews {
  self.contentView.frame = CGRectMake(0, kScreenHeight-290, kScreenWidth, 290);
    
  self.topView.frame = CGRectMake(0, 0, kScreenWidth, 46);
  
  self.line.frame = CGRectMake(0, 45.5, kScreenWidth, 0.5);
  
  self.cancleButton.frame = CGRectMake(16, 12, 34, 22);
  
  self.sureButton.frame = CGRectMake(kScreenWidth-50, 12, 34, 22);
  
  self.detailLable.frame = CGRectMake(CGRectGetMaxX(self.cancleButton.frame), 0, kScreenWidth-100, 45);
  
  self.picker.frame = CGRectMake(0, 64, kScreenWidth, 193);
    
}
- (void)show {
    [kKeyWindow addSubview:self];
    self.frame = kKeyWindow.bounds;
    self.contentView.transform = CGAffineTransformMakeTranslation(0, 290);
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = UIColorAlpha(XYThemeColor_D, XYColorAlpha_40);
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeTranslation(0, 290);
    } completion:^(BOOL finished) {
        if (self.dismissBlock) self.dismissBlock();
        [self removeFromSuperview];
    }];
}

- (void)setDate:(NSDate *)date {
  _date = date;
  if (date) {
    [self.picker setDate:date animated:YES];
  }
}

- (void)sure {
  if (self.selectedBlock) self.selectedBlock(self.picker.date);
  
  [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.anyObject.view == self) {
        [self dismiss];
    }
}
#pragma mark - getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
      _contentView.backgroundColor = ColorHex(XYThemeColor_B);
    }
    return _contentView;
}

- (UIDatePicker *)picker {
    if (!_picker) {
        _picker = [[UIDatePicker alloc] init];
      if (@available(iOS 13.4, *)) {
        _picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
      }
        _picker.datePickerMode = UIDatePickerModeDate;
    }
  _picker.maximumDate = [NSDate date];
    return _picker;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = ColorHex(XYThemeColor_B);
    }
    return _topView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = ColorHex(XYThemeColor_E);
    }
    return _line;
}

- (UILabel *)detailLable {
    if (!_detailLable) {
        _detailLable = [[UILabel alloc] init];
        _detailLable.backgroundColor = ColorHex(XYThemeColor_B);
        _detailLable.font = AdaptedFont(XYFont_G);
        _detailLable.textColor = ColorHex(XYTextColor_222222);
        _detailLable.numberOfLines = 0;
        _detailLable.textAlignment = NSTextAlignmentCenter;
      _detailLable.text = @"选择日期";
    }
    return _detailLable;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setBackgroundColor:ColorHex(XYThemeColor_B)];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = AdaptedFont(15);
        [_sureButton setTitleColor:ColorHex(XYTextColor_FE2D63) forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setBackgroundColor:ColorHex(XYThemeColor_B)];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = AdaptedFont(15);
        [_cancleButton setTitleColor:ColorHex(XYTextColor_666666) forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

@end
