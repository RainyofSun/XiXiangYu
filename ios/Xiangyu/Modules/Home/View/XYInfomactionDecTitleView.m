//
//  XYInfomactionDecTitleView.m
//  Xiangyu
//
//  Created by Kang on 2021/6/6.
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
#import "XYInfomactionDecTitleView.h"
@interface XYInfomactionDecTitleView ()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *readLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@end
@implementation XYInfomactionDecTitleView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.backgroundColor =  ColorHex(XYTextColor_FFFFFF);
  
  self.titleLabel = [UILabel new];
  self.titleLabel.numberOfLines = 0;
  self.titleLabel.font = AdaptedMediumFont(XYFont_I);
  self.titleLabel.textColor = ColorHex(XYTextColor_222222);
  [self addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self).offset(16);
    make.top.equalTo(self).offset(14);
    make.centerX.equalTo(self);
  }];
  
  self.readLabel = [UILabel new];
  self.readLabel.font = AdaptedMediumFont(XYFont_B);
  self.readLabel.textColor = ColorHex(XYTextColor_999999);
  [self addSubview:self.readLabel];
  [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.titleLabel);
    make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
    make.trailing.lessThanOrEqualTo(self).offset(-12);
    make.bottom.equalTo(self).offset(-12).priority(800);
  }];
  
  self.timeLabel = [UILabel new];
  self.timeLabel.font = AdaptedMediumFont(XYFont_B);
  self.timeLabel.textColor = ColorHex(XYTextColor_999999);
  [self addSubview:self.timeLabel];
  [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.readLabel.mas_trailing).offset(16);
    make.centerY.equalTo(self.readLabel);
    make.trailing.lessThanOrEqualTo(self.mas_centerX);
  }];
  
}
-(void)setParams:(NSDictionary *)params{
  _params = params;
  self.titleLabel.text = [NSString stringWithFormat:@"%@",[params objectForKey:@"title"]?:@""];
  self.readLabel.text = [NSString stringWithFormat:@"%@阅读   %@",[params objectForKey:@"readCount"]?:@"",[params objectForKey:@"createTime"]?:@""];
//  self.timeLabel.text = [NSString stringWithFormat:@"%@",[params objectForKey:@"createTime"]?:@""];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
