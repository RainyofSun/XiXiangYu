//
//  XYHeartBuyTypeView.m
//  Xiangyu
//
//  Created by Kang on 2021/7/5.
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
#import "XYHeartBuyTypeView.h"
@interface XYHeartBuyTypeView ()

@end
@implementation XYHeartBuyTypeView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.headerImage = [LSHControl createImageViewWithImage:nil];
  [self addSubview:self.headerImage];
  [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self).offset(AutoSize(23));
    make.width.height.mas_offset(AutoSize(20));
    make.centerY.equalTo(self);
    make.bottom.equalTo(self).offset(-AutoSize(10)).priority(800);
  }];
  
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_222222)];
  [self addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.headerImage.mas_trailing).offset(AutoSize(8));
    make.trailing.lessThanOrEqualTo(self).offset(-AutoSize(50));
    make.centerY.equalTo(self);
  }];
  
  self.selectBtn = [LSHControl createButtonWithButtonImage:[UIImage imageNamed:@"icon_22_option_def"] selectedImage:[UIImage imageNamed:@"icon_22_option_sel"]];
  self.selectBtn.userInteractionEnabled = NO;
  [self addSubview:self.selectBtn];
  [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self).offset(AutoSize(-20));
    make.width.height.mas_offset(AutoSize(20));
    make.centerY.equalTo(self);
  }];
}
+(instancetype)initWithImageName:(NSString *)name title:(NSAttributedString *)title{
  XYHeartBuyTypeView *view = [[XYHeartBuyTypeView alloc]initWithFrame:CGRectZero];
  view.headerImage.image = [UIImage imageNamed:name];
  view.titleLabel.attributedText = title;
  return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
