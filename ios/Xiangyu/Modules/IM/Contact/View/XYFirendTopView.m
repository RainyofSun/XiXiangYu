//
//  XYFirendTopView.m
//  Xiangyu
//
//  Created by Kang on 2021/7/10.
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
#import "XYFirendTopView.h"
@interface XYFirendTopView ()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *arrowImage;
@end
@implementation XYFirendTopView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.backgroundColor = ColorHex(@"#FFDBE4");
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(@"#F92B5E") text:@"当前处于陌生人模式，加TA好友才能优先看到你哦~"];
  [self addSubview:self.titleLabel];
 
  
  self.arrowImage = [LSHControl createImageViewWithImageName:@"icon_12_farrow"];
  [self addSubview:self.arrowImage];
  [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self);
    make.trailing.equalTo(self).offset(-AutoSize(16));
    make.width.height.mas_equalTo(AutoSize(13));
  }];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self);
    make.leading.equalTo(self).offset(AutoSize(16));
    make.trailing.equalTo(self.arrowImage.mas_leading).offset(-AutoSize(10));
  }];
  
  self.clipsToBounds = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
