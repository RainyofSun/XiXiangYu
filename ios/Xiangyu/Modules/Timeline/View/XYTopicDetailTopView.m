//
//  XYTopicDetailTopView.m
//  Xiangyu
//
//  Created by Kang on 2021/7/4.
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
#import "XYTopicDetailTopView.h"
@interface XYTopicDetailTopView ()

@end
@implementation XYTopicDetailTopView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
  self.imgScrollView=[SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:nil];
 // self.imgScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
  self.imgScrollView.pageControlDotSize = CGSizeMake(AutoSize(13), AutoSize(5));
//  self.imgScrollView.currentPageDotImage = [UIImage imageWithColor:whiteBackgroundColor size:CGSizeMake(AutoSize(13), AutoSize(5))];
//  self.imgScrollView.pageDotImage =[UIImage imageWithColor:[whiteBackgroundColor colorWithAlphaComponent:0.65] size:CGSizeMake(AutoSize(13), AutoSize(5))];
//  self.imgScrollView.pageDotColor=[whiteBackgroundColor colorWithAlphaComponent:0.65];
  self.imgScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
  [self addSubview:self.imgScrollView];
  
  [self.imgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.leading.top.trailing.equalTo(self);
    make.height.mas_equalTo(AutoSize(200));
  }];
  
  [self addSubview:self.bgView];
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.imgScrollView.mas_bottom).offset(-AutoSize(50));
    make.centerX.equalTo(self);
    make.leading.equalTo(self).offset(AutoSize(16));
    make.bottom.equalTo(self).offset(-AutoSize(10));
  }];
  
  // self 自适应高度
   CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
   CGRect frame = self.frame;
   frame.size.height = height;
   self.frame = frame;
  
}
-(void)setModel:(XYTopicModel *)model{
  _model = model;
  self.imgScrollView.imageURLStringsGroup = [model.image componentsSeparatedByString:@"|"];
  self.titleLabel.text = [NSString stringWithFormat:@"# %@",model.title];
  self.hotLabel.text = [NSString stringWithFormat:@"%@ 热度",model.fiery];
  self.remarkLabel.text = model.remark;
  
  // self 自适应高度
   CGFloat height = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
   CGRect frame = self.frame;
   frame.size.height = height;
   self.frame = frame;
}
-(UIView *)bgView{
  if (!_bgView) {
    _bgView = [LSHControl viewWithBackgroundColor:ColorHex(XYTextColor_FFFFFF)];
    [_bgView roundSize:AutoSize(12)];
    self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(16) textColor:ColorHex(XYTextColor_222222) text:@""];
    self.titleLabel.numberOfLines = 0;
    [_bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.leading.top.equalTo(_bgView).offset(AutoSize(16));
      make.trailing.lessThanOrEqualTo(_bgView).offset(-AutoSize(90));
    }];
    
    self.hotLabel = [LSHControl createLabelFromFont:AdaptedFont(12) textColor:ColorHex(@"#F92B5E") text:@""];
    [_bgView addSubview:self.hotLabel];
    [self.hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.trailing.equalTo(_bgView).offset(-AutoSize(16));
      make.centerY.equalTo(self.titleLabel);
    }];
    
    self.remarkLabel = [LSHControl createLabelFromFont:AdaptedFont(12) textColor:ColorHex(XYTextColor_999999) text:@""];
    self.remarkLabel.numberOfLines = 0;
    [_bgView addSubview:self.remarkLabel];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.leading.equalTo(self.titleLabel);
      make.trailing.equalTo(self.hotLabel);
      make.top.equalTo(self.titleLabel.mas_bottom).offset(AutoSize(10));
      make.bottom.equalTo(_bgView).offset(-AutoSize(16)).priority(800);
    }];
    
    
  }
  return _bgView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
