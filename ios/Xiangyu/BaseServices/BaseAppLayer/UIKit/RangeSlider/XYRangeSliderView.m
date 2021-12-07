//
//  XYRangeSliderView.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYRangeSliderView.h"
#import "XYRangeSlider.h"

@interface XYRangeSliderView () <XYRangeSliderDelegate>

@property (nonatomic,strong) UILabel *contentLable;

@property (nonatomic,strong) UILabel *leftLable;

@property (nonatomic,strong) UILabel *rightLable;

@property (nonatomic,strong) XYRangeSlider *slider;

@property (nonatomic,strong) UIButton *sureButton;

@property (nonatomic,strong) UIButton *cancleButton;

@property (nonatomic,assign) NSUInteger minSelectedValue;

@property (nonatomic,assign) NSUInteger maxSelectedValue;

@property (nonatomic,assign) NSUInteger minValue;

@property (nonatomic,assign) NSUInteger maxValue;

@property (nonatomic,copy) NSString *unit;

@end

@implementation XYRangeSliderView
- (instancetype)initWithMinValue:(NSUInteger)minValue maxValue:(NSUInteger)maxValue unit:(NSString *)unit {
    if (self = [super init]) {
      self.backgroundColor = [UIColor whiteColor];
      self.minValue = minValue;
      self.maxValue = maxValue;
      self.minSelectedValue = minValue;
      self.maxSelectedValue = maxValue;
      self.unit = unit;
      [self addSubviews];
      [self layoutPageSubviews];
    }
    return self;
}
- (instancetype)initWithMinValue:(NSUInteger)minValue maxValue:(NSUInteger)maxValue  minSelectValue:(NSUInteger)minSelectValue maxSelectValue:(NSUInteger)maxSelectValue   unit:(NSString *)unit{
  if (self = [super init]) {
    self.backgroundColor = [UIColor whiteColor];
    self.minValue = minValue;
    self.maxValue = maxValue;
    self.minSelectedValue = minSelectValue;
    self.maxSelectedValue = maxSelectValue;
    self.unit = unit;
    [self addSubviews];
    [self layoutPageSubviews];
    
    self.contentLable.text = [NSString stringWithFormat:@"%.0f～%.0f",roundf(minSelectValue), roundf(maxSelectValue)];
  }
  return self;
}
- (void)addSubviews {
  
  [self addSubview:self.contentLable];
  [self addSubview:self.slider];
  [self addSubview:self.leftLable];
  [self addSubview:self.rightLable];
  
  [self addSubview:self.cancleButton];
  [self addSubview:self.sureButton];
}

- (void)layoutPageSubviews {
  
  self.contentLable.frame = CGRectMake(16, 40, kScreenWidth-32, 20);
  
  self.slider.frame = CGRectMake(16, 70, kScreenWidth-32, 40);
  
  self.leftLable.frame = CGRectMake(16, CGRectGetMaxY(self.slider.frame)+4, (kScreenWidth-32)/2, 18);
  
  self.rightLable.frame = CGRectMake(kScreenWidth/2, CGRectGetMaxY(self.slider.frame)+4, (kScreenWidth-32)/2, 18);
    
  self.cancleButton.frame = CGRectMake(16, CGRectGetMaxY(self.leftLable.frame)+30, (kScreenWidth-48)/2, 36);
  
  self.sureButton.frame = CGRectMake(kScreenWidth/2+8, CGRectGetMaxY(self.leftLable.frame)+30, (kScreenWidth-48)/2, 36);
  
}

- (void)sure {
  if (self.selectedBlock) self.selectedBlock(@(self.slider.selectedMinimum), @(self.slider.selectedMaximum));
}

- (void)dismiss {
  if (self.dismissBlock) self.dismissBlock();
}

#pragma mark - XYRangeSliderDelegate
-(void)rangeSlider:(XYRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum {
  self.contentLable.text = [NSString stringWithFormat:@"%.0f～%.0f",roundf(selectedMinimum), roundf(selectedMaximum)];
}

#pragma mark - getter

- (XYRangeSlider *)slider {
    if (!_slider) {
      _slider = [[XYRangeSlider alloc] init];
      _slider.tintColor = ColorHex(XYThemeColor_I);
      _slider.delegate = self;
      _slider.minValue = _minValue;
      _slider.maxValue = _maxValue;
      _slider.selectedMinimum = self.minSelectedValue;
      _slider.selectedMaximum = self.maxSelectedValue;
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

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setBackgroundColor:ColorHex(XYThemeColor_A)];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
        _sureButton.titleLabel.font = AdaptedFont(16);
      _sureButton.layer.cornerRadius = 18;
      _sureButton.layer.masksToBounds = YES;
        [_sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setBackgroundColor:ColorHex(XYThemeColor_I)];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = AdaptedFont(16);
        [_cancleButton setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
      _cancleButton.layer.cornerRadius = 18;
      _cancleButton.layer.masksToBounds = YES;
        [_cancleButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

@end
