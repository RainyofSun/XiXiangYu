//
//  XYProfessItemView.m
//  Xiangyu
//
//  Created by Kang on 2021/6/28.
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
#import "XYProfessItemView.h"
@interface XYProfessItemView ()

@end
@implementation XYProfessItemView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.backgroundColor = ColorHex(@"#6160F0");
  [self roundSize:AutoSize(12)];
  self.iconImage = [LSHControl createImageViewWithImageName:@"icon_20_heart"];
  [self addSubview:self.iconImage];
  [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.top.equalTo(self).offset(AutoSize(16));
    make.width.height.mas_equalTo(AutoSize(20));
  }];
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_FFFFFF)];
  [self addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.iconImage.mas_trailing).offset(AutoSize(4));
    make.centerY.equalTo(self.iconImage);
  }];
  
  self.valueLabel = [LSHControl createLabelFromFont:AdaptedFont(36) textColor:ColorHex(XYTextColor_FFFFFF) text:@"0"];
  [self addSubview:self.valueLabel];
  [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.iconImage);
    make.centerX.equalTo(self);
    make.bottom.equalTo(self).offset(-AutoSize(18));
  }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
@implementation XYProfessTopView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  [self addSubview:self.myHeart];
  [self addSubview:self.toMyHeart];
  NSArray *arr = @[self.myHeart,self.toMyHeart];
  [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:AutoSize(4) leadSpacing:AutoSize(15) tailSpacing:AutoSize(15)];
  [arr mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(AutoSize(116));
    make.centerY.equalTo(self);
    make.bottom.equalTo(self).offset(-AutoSize(8)).priority(800);
  }];
}
-(XYProfessItemView *)myHeart{
  if (!_myHeart) {
    _myHeart = [[XYProfessItemView alloc]initWithFrame:CGRectZero];
    _myHeart.titleLabel.text = @"我心动的";
  }
  return _myHeart;
}
-(XYProfessItemView *)toMyHeart{
  if (!_toMyHeart) {
    _toMyHeart = [[XYProfessItemView alloc]initWithFrame:CGRectZero];
    _toMyHeart.titleLabel.text = @"对我心动";
  }
  return _toMyHeart;
}
-(void)setModel:(XYGetProfessModel *)model{
  self.myHeart.valueLabel.text = model.sendOut.stringValue?:@"0";
  self.toMyHeart.valueLabel.text = model.received.stringValue?:@"0";
}
@end
