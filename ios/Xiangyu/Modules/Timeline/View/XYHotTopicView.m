//
//  XYHotTopicView.m
//  Xiangyu
//
//  Created by Kang on 2021/7/12.
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
#import "XYHotTopicView.h"
@interface XYHotTopicView ()

@end
@implementation XYHotTopicView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  
  
  self.backgroundColor = ColorHex(@"#EEEEEE");;
  
  [self roundSize:AutoSize(12)];
  
  self.tipLabel = [LSHControl createLabelFromFont:AdaptedFont(15) textColor:ColorHex(@"#F92B5E") text:@"#"];
  [self addSubview:self.tipLabel];
  [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self).offset(AutoSize(12));
    make.centerY.equalTo(self);
    make.width.mas_equalTo(AutoSize(17));
  }];
  
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_333333) text:@"#"];
  [self addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.tipLabel.mas_trailing);
    make.centerY.equalTo(self);
    make.trailing.equalTo(self).offset(-AutoSize(12)).priority(800);
  }];
  
  self.closeBtn = [LSHControl createButtonWithButtonImage:[UIImage imageNamed:@"close"]];
  self.closeBtn.hidden = YES;
  [self.closeBtn handleControlEventWithBlock:^(id sender) {
    self.model = nil;
  }];
  [self addSubview:self.closeBtn];
  [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self);
    make.trailing.equalTo(self).offset(-AutoSize(12));
    make.width.height.mas_equalTo(AutoSize(14));
  }];
  
  self.model = nil;
}
-(void)setModel:(XYTopicModel *)model{
  _model = model;
  if (model) {
    self.closeBtn.hidden = NO;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.leading.equalTo(self.tipLabel.mas_trailing);
      make.centerY.equalTo(self);
      make.trailing.equalTo(self).offset(-AutoSize(32)).priority(800);
    }];
    self.titleLabel.text = model.title;
  }else{
    self.closeBtn.hidden = YES;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.leading.equalTo(self.tipLabel.mas_trailing);
      make.centerY.equalTo(self);
      make.trailing.equalTo(self).offset(-AutoSize(12)).priority(800);
    }];
    self.titleLabel.text = @"添加话题";
  }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
