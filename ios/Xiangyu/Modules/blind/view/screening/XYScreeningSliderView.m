//
//  XYScreeningSliderView.m
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
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
#import "XYScreeningSliderView.h"

@interface XYScreeningSliderView () <XYRangeSliderDelegate>
@property(nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLable;

@property (nonatomic,strong) UILabel *leftLable;

@property (nonatomic,strong) UILabel *rightLable;




@property(nonatomic,assign)NSUInteger minValue;
@property(nonatomic,assign)NSUInteger maxValue;
@property(nonatomic,assign)NSUInteger minSelectValue;
@property(nonatomic,assign)NSUInteger maxSelectValue;
@property(nonatomic,strong)NSString *unit;
@end
@implementation XYScreeningSliderView

- (instancetype)initWithMinValue:(NSUInteger)minValue maxValue:(NSUInteger)maxValue  minSelectValue:(NSUInteger)minSelectValue maxSelectValue:(NSUInteger)maxSelectValue  unit:(NSString *)unit{
  self = [self initWithFrame:CGRectZero];
  if (self) {
    _minValue = minValue;
    _maxValue = maxValue;
    _minSelectValue = minSelectValue;
    _maxSelectValue = maxSelectValue;
    _unit = unit;
    [self reshView];
  }
  return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_999999)];
  [self addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self).offset(AutoSize(20));
    make.top.equalTo(self).offset(AutoSize(10));
  }];
  
  [self addSubview:self.contentLable];
  [self.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self.titleLabel.mas_bottom).offset(AutoSize(2));
   
    
  }];
  
  [self addSubview:self.slider];
  [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self.contentLable.mas_bottom).offset(AutoSize(2));
    make.leading.equalTo(self).offset(AutoSize(20));
    make.height.mas_equalTo(AutoSize(40));
  }];
  
  [self addSubview:self.leftLable];
  [self.leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.slider);
    make.top.equalTo(self.slider.mas_bottom);
  }];
  
  
  [self addSubview:self.rightLable];
  [self.rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self.slider);
    make.top.equalTo(self.slider.mas_bottom);
    make.bottom.equalTo(self).offset(-AutoSize(10)).priority(800);
  }];
  
//  self.sliderView = [[XYRangeSliderView alloc] initWithMinValue:18 maxValue:50 minSelectValue:24 maxSelectValue:38  unit:@"岁"];
//  self.sliderView .dismissBlock = ^{
////    [menu packupMenu];
//  };
//  self.sliderView .selectedBlock = ^(NSNumber *min, NSNumber *max) {
//
//  };
  
  
}
-(void)insetMinSelectValue:(NSUInteger)minSelectValue maxSelectValue:(NSUInteger)maxSelectValue {
  self.minSelectValue = minSelectValue;
  self.maxSelectValue = maxSelectValue;
  [self reshView];
}
-(void)reshView{
  self.slider.minValue = self.minValue;
  self.slider.maxValue = self.maxValue;
  self.slider.selectedMinimum = self.minSelectValue;
  self.slider.selectedMaximum = self.maxSelectValue;
  
  self.leftLable.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)self.minValue, self.unit];
  self.rightLable.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)self.maxValue, self.unit];
  
  self.contentLable.text = [NSString stringWithFormat:@"%lu～%lu",(unsigned long)self.minSelectValue, (unsigned long)self.maxSelectValue];
}
#pragma mark - XYRangeSliderDelegate
-(void)rangeSlider:(XYRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum {
  self.contentLable.text = [NSString stringWithFormat:@"%.0f～%.0f",roundf(selectedMinimum), roundf(selectedMaximum)];

    if (self.selectedBlock) self.selectedBlock(@(self.slider.selectedMinimum), @(self.slider.selectedMaximum));
  
}
-(void)setTitle:(NSString *)title{
  self.titleLabel.text = title;
}
- (XYRangeSlider *)slider {
    if (!_slider) {
      _slider = [[XYRangeSlider alloc] init];
      _slider.tintColor = ColorHex(XYThemeColor_I);
      _slider.delegate = self;
     // _slider.minValue = _minValue;
     // _slider.maxValue = _maxValue;
     // _slider.selectedMinimum = self.minSelectedValue;
      //_slider.selectedMaximum = self.maxSelectedValue;
      _slider.handleImage = [UIImage imageNamed:@"Slider"];
      _slider.selectedHandleDiameterMultiplier = 1;
      _slider.tintColorBetweenHandles = ColorHex(@"#6160F0");
      _slider.lineHeight = 2;
      _slider.hideLabels = YES;
      _slider.step = 1;
    }
    return _slider;
}

- (UILabel *)leftLable {
    if (!_leftLable) {
      _leftLable = [[UILabel alloc] init];
      _leftLable.font = AdaptedFont(12);
      _leftLable.textColor = ColorHex(XYTextColor_999999);
      _leftLable.textAlignment = NSTextAlignmentLeft;
     // _leftLable.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)_minValue, _unit];
    }
    return _leftLable;
}

- (UILabel *)rightLable {
    if (!_rightLable) {
      _rightLable = [[UILabel alloc] init];
      _rightLable.font = AdaptedFont(12);
      _rightLable.textColor = ColorHex(XYTextColor_999999);
      _rightLable.textAlignment = NSTextAlignmentRight;
     // _rightLable.text = [NSString stringWithFormat:@"%lu%@",(unsigned long)_maxValue, _unit];
    }
    return _rightLable;
}

- (UILabel *)contentLable {
    if (!_contentLable) {
      _contentLable = [[UILabel alloc] init];
      _contentLable.font = AdaptedFont(14);
      _contentLable.textColor = ColorHex(XYTextColor_635FF0);
      _contentLable.textAlignment = NSTextAlignmentCenter;
     // _contentLable.text = [NSString stringWithFormat:@"%lu～%lu",(unsigned long)_minValue, (unsigned long)_maxValue];
    }
    return _contentLable;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
