//
//  XYPerfectInformationPopView.m
//  Xiangyu
//
//  Created by Kang on 2021/8/8.
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
#import "XYPerfectInformationPopView.h"
@interface XYPerfectInformationPopView ()

@end
@implementation XYPerfectInformationPopView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
      [self configProperty];
    }
    return self;
}
- (void)configProperty
{
    FWPopupBaseViewProperty *property = [FWPopupBaseViewProperty manager];
    property.popupAlignment = FWPopupAlignmentCenter;
    property.popupAnimationStyle = FWPopupAnimationStyleScale;
    property.touchWildToHide = @"0";
   //    property.maskViewColor = [UIColor colorWithWhite:0 alpha:0.8];
    //    property.popupEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    //    property.animationDuration = 0.2;
    self.vProperty = property;
  
  
  [self roundSize:AutoSize(10)];
  self.backgroundColor = ColorHex(XYTextColor_FFFFFF);
}
-(void)newView{
  self.topImage = [LSHControl createImageViewWithImageName:@"perfect_information"];
  [self addSubview:self.topImage];
  [self.topImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self).offset(AutoSize(32));
    make.width.height.mas_equalTo(AutoSize(100));
  }];
  
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(@"#F92B5E") text:@"您还未完善资料"];
  [self addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self.topImage.mas_bottom).offset(AutoSize(20));
  }];
  
  self.descLabel = [LSHControl createLabelFromFont:AdaptedFont(12) textColor:ColorHex(XYTextColor_666666) text:@"详细资料未完善，请先完善个人详细资料"];
  [self addSubview:self.descLabel];
  [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.top.equalTo(self.titleLabel.mas_bottom).offset(AutoSize(4));
  }];
  

  
  self.cancelBtn = [LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(16) buttonTitle:@"取消" buttonTitleColor:ColorHex(@"#F92B5E") action:^(id sender) {
    [self hide];
  }];
  [self.cancelBtn roundSize:AutoSize(16) color:ColorHex(@"#F92B5E")];
  [self addSubview:self.cancelBtn];
  [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.size.mas_equalTo(CGSizeMake(AutoSize(212), AutoSize(32)));
    make.bottom.equalTo(self).offset(-AutoSize(27));
  }];
  
  self.confirmBtn = [LSHControl createButtonWithFrame:CGRectZero buttonTitleFont:AdaptedFont(16) buttonTitle:@"去完善" buttonTitleColor:ColorHex(XYTextColor_FFFFFF) action:^(id sender) {
    [self hide];
    if (self.successBlock) {
      self.successBlock(@"");
    }
  }];
  self.confirmBtn.backgroundColor = ColorHex(@"#F92B5E");
  [self.confirmBtn roundSize:AutoSize(16)];
  [self addSubview:self.confirmBtn];
  [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self);
    make.size.mas_equalTo(CGSizeMake(AutoSize(212), AutoSize(32)));
    make.bottom.equalTo(self.cancelBtn.mas_top).offset(-AutoSize(12));
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
