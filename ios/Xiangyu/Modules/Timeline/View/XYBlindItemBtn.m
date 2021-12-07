//
//  XYBlindItemBtn.m
//  Xiangyu
//
//  Created by Kang on 2021/7/1.
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
#import "XYBlindItemBtn.h"
@interface XYBlindItemBtn ()
@property(nonatomic,strong)UIImageView *bgImage;
@property(nonatomic,strong)UILabel *nameLabel;
@end
@implementation XYBlindItemBtn
-(instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName{
  self = [self initWithFrame:CGRectZero];
  if (self) {
    self.title = title;
    self.imageName = imageName;
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
  self.bgImage = [LSHControl createImageViewWithImageName:self.imageName];
  [self addSubview:self.bgImage];
  [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self);
  }];
  
//  self.nameLabel = [LSHControl createLabelFromFont:AdaptedFont(8) textColor:ColorHex(XYTextColor_FFFFFF) text:self.title];
//  [self addSubview:self.nameLabel];
//  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.centerX.equalTo(self);
//    make.top.equalTo(self.mas_centerY).offset(AutoSize(6));
//  }];
  
}
-(void)setImageName:(NSString *)imageName{
  _imageName = imageName;
  self.bgImage.image = [UIImage imageNamed:imageName];
}
-(void)setTitle:(NSString *)title{
  _title = title;
  self.nameLabel.text = title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
