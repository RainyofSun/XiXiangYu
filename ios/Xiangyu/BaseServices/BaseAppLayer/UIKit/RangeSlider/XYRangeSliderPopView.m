//
//  XYRangeSliderPopView.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYRangeSliderPopView.h"
#import "XYRangeSlider.h"

@interface XYRangeSliderPopView () <XYRangeSliderDelegate>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) UILabel *detailLable;

@property (nonatomic,strong) UIButton *sureButton;

@property (nonatomic,strong) UIButton *cancleButton;

@property (nonatomic,strong) UILabel *contentLable;

@property (nonatomic,strong) UILabel *leftLable;

@property (nonatomic,strong) UILabel *rightLable;

@property (nonatomic,strong) XYRangeSlider *slider;

@property (nonatomic,assign) NSUInteger minValue;

@property (nonatomic,assign) NSUInteger maxValue;

@property (nonatomic,assign) NSUInteger minDefaultValue;

@property (nonatomic,assign) NSUInteger maxDefaultValue;

@property (nonatomic,copy) NSString *unit;

@end

@implementation XYRangeSliderPopView
- (instancetype)initWithMinValue:(NSUInteger)minValue maxValue:(NSUInteger)maxValue unit:(NSString *)unit {
    if (self = [super init]) {
      self.backgroundColor = UIColorAlpha(XYThemeColor_D, XYColorAlpha_0);
      self.minValue = minValue;
      self.maxValue = maxValue;
      self.minDefaultValue = minValue;
      self.maxDefaultValue = maxValue;
      self.unit = unit;
      [self addSubviews];
      [self layoutPageSubviews];
    }
    return self;
}
-(instancetype)initWithMinValue:(NSUInteger)minValue maxValue:(NSUInteger)maxValue minSelectValue:(NSUInteger)minSelectValue maxSelectValue:(NSUInteger)maxSelectValue unit:(NSString *)unit{
  if (self = [super init]) {
    self.backgroundColor = UIColorAlpha(XYThemeColor_D, XYColorAlpha_0);
    self.minValue = minValue;
    self.maxValue = maxValue;
    self.minDefaultValue = minSelectValue;
    self.maxDefaultValue = maxSelectValue;
    self.unit = unit;
    [self addSubviews];
    [self layoutPageSubviews];
    
    self.contentLable.text = [NSString stringWithFormat:@"%.0f～%.0f",roundf(minSelectValue), roundf(maxSelectValue)];
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
  [self.contentView addSubview:self.contentLable];
  [self.contentView addSubview:self.slider];
  [self.contentView addSubview:self.leftLable];
  [self.contentView addSubview:self.rightLable];
}

- (void)layoutPageSubviews {
  self.contentView.frame = CGRectMake(0, kScreenHeight-290, kScreenWidth, 290);
    
  self.topView.frame = CGRectMake(0, 0, kScreenWidth, 46);
  
  self.line.frame = CGRectMake(0, 45.5, kScreenWidth, 0.5);
  
  self.cancleButton.frame = CGRectMake(16, 12, 34, 22);
  
  self.sureButton.frame = CGRectMake(kScreenWidth-50, 12, 34, 22);
  
  self.detailLable.frame = CGRectMake(CGRectGetMaxX(self.cancleButton.frame), 0, kScreenWidth-100, 45);
  
  self.contentLable.frame = CGRectMake(16, 70, kScreenWidth-32, 20);
  
  self.slider.frame = CGRectMake(16, 100, kScreenWidth-32, 40);
  
  self.leftLable.frame = CGRectMake(16, 150, (kScreenWidth-32)/2, 16);
  
  self.rightLable.frame = CGRectMake(kScreenWidth/2, 150, (kScreenWidth-32)/2, 16);
    
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

- (void)sure {
  if (self.selectedBlock) self.selectedBlock(@(self.slider.selectedMinimum), @(self.slider.selectedMaximum));
  
  [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.anyObject.view == self) {
        [self dismiss];
    }
}

#pragma mark - XYRangeSliderDelegate
-(void)rangeSlider:(XYRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum {
  self.contentLable.text = [NSString stringWithFormat:@"%.0f～%.0f",roundf(selectedMinimum), roundf(selectedMaximum)];
}

#pragma mark - getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
      _contentView.backgroundColor = ColorHex(XYThemeColor_B);
    }
    return _contentView;
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

- (XYRangeSlider *)slider {
    if (!_slider) {
      _slider = [[XYRangeSlider alloc] init];
      _slider.tintColor = ColorHex(XYThemeColor_I);
      _slider.delegate = self;
      _slider.minValue = _minValue;
      _slider.maxValue = _maxValue;
      _slider.selectedMinimum = _minDefaultValue;
      _slider.selectedMaximum = _maxDefaultValue;
      _slider.handleImage = [UIImage imageNamed:@"Slider"];
      _slider.selectedHandleDiameterMultiplier = 1;
      _slider.tintColorBetweenHandles = ColorHex(XYTextColor_635FF0);
      _slider.lineHeight = 2;
      _slider.hideLabels = YES;
      _slider.step = 1;
    }
    return _slider;
}

- (UILabel *)leftLable {
    if (!_leftLable) {
      _leftLable = [[UILabel alloc] init];
      _leftLable.font = AdaptedFont(14);
      _leftLable.textColor = ColorHex(XYTextColor_999999);
      _leftLable.textAlignment = NSTextAlignmentLeft;
      _leftLable.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)_minValue, _unit];
    }
    return _leftLable;
}

- (UILabel *)rightLable {
    if (!_rightLable) {
      _rightLable = [[UILabel alloc] init];
      _rightLable.font = AdaptedFont(14);
      _rightLable.textColor = ColorHex(XYTextColor_999999);
      _rightLable.textAlignment = NSTextAlignmentRight;
      _rightLable.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)_maxValue, _unit];
    }
    return _rightLable;
}

- (UILabel *)contentLable {
    if (!_contentLable) {
      _contentLable = [[UILabel alloc] init];
      _contentLable.font = AdaptedFont(14);
      _contentLable.textColor = ColorHex(XYTextColor_635FF0);
      _contentLable.textAlignment = NSTextAlignmentCenter;
      _contentLable.text = [NSString stringWithFormat:@"%lu～%lu",(unsigned long)_minValue, (unsigned long)_maxValue];
    }
    return _contentLable;
}

- (UILabel *)detailLable {
    if (!_detailLable) {
        _detailLable = [[UILabel alloc] init];
        _detailLable.backgroundColor = ColorHex(XYThemeColor_B);
        _detailLable.font = AdaptedFont(XYFont_G);
        _detailLable.textColor = ColorHex(XYTextColor_222222);
        _detailLable.numberOfLines = 0;
        _detailLable.textAlignment = NSTextAlignmentCenter;
        _detailLable.text = @"";
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
