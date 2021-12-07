//
//  XYFirendTextView.m
//  Xiangyu
//
//  Created by Kang on 2021/7/15.
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
#import "XYFirendTextView.h"
@interface XYFirendTextView ()

@end
@implementation XYFirendTextView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(12) textColor:ColorHex(XYTextColor_999999)];
  [self addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self).offset(AutoSize(16));
    make.top.equalTo(self).offset(AutoSize(4));
    make.height.mas_equalTo(AutoSize(32));
  }];
  
  self.bgView = [LSHControl viewWithBackgroundColor:ColorHex(XYTextColor_FFFFFF)];
  [self addSubview:self.bgView];
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.bottom.trailing.equalTo(self);
    make.top.equalTo(self.titleLabel.mas_bottom);
    make.height.mas_equalTo(AutoSize(60));
  }];
  
  self.textField = [LSHControl creatTextfieldWithFrame:CGRectZero textfieldTextFont:AdaptedFont(16) textFieldTextColor:ColorHex(XYTextColor_222222)];
  [self.bgView addSubview:self.textField];
  [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.bgView).offset(AutoSize(15));
    make.center.equalTo(self.bgView);
    make.top.equalTo(self.bgView).offset(AutoSize(5));
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
