//
//  XYWalletTopView.m
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
#import "XYWalletTopView.h"
@interface XYWalletTopView ()

@end
@implementation XYWalletTopView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.bgView = [LSHControl createImageViewWithImageName:@"pic_yue"];
//  self.bgView.backgroundColor = ColorHex(XYTextColor_635FF0);
//  self.bgView.backgroundColor =
  [self.bgView roundSize:AutoSize(12)];
  [self addSubview:self.bgView];
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self);
    make.leading.equalTo(self).offset(AutoSize(16));
    make.height.mas_equalTo(AutoSize(120));
    make.bottom.equalTo(self).offset(-AutoSize(12)).priority(800);
  }];
  
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(20) textColor:ColorHex(XYTextColor_FFFFFF) text:@"我的余额"];
  [self.bgView addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.top.equalTo(self.bgView).offset(AutoSize(16));
  }];
  
  self.moneyLabel = [LSHControl createLabelFromFont:AdaptedFont(40) textColor:ColorHex(XYTextColor_FFFFFF) text:@"0"];
  [self.bgView addSubview:self.moneyLabel];
  [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.bgView).offset(AutoSize(16));
    make.height.mas_equalTo(AutoSize(56));
    make.bottom.equalTo(self.bgView).offset(-AutoSize(10));
  }];
  
  

  
  self.arrowView = [LSHControl createImageViewWithImageName:@"icon_12_arrowwh"];
  [self.bgView addSubview:self.arrowView];
  [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self.bgView).offset(-AutoSize(10));
    make.centerY.equalTo(self.bgView);
  }];
  
  self.descLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(XYTextColor_FFFFFF) text:@"提现"];
  [self.bgView addSubview:self.descLabel];
  [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self.arrowView.mas_leading).offset(-AutoSize(4));
    make.centerY.equalTo(self.bgView);
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
