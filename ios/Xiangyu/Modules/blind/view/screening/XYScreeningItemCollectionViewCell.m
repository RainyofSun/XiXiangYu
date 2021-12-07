//
//  XYScreeningItemCollectionViewCell.m
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
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
#import "XYScreeningItemCollectionViewCell.h"
@interface XYScreeningItemCollectionViewCell()
@property(nonatomic,strong)UIView *bgView;
//@property(nonatomic,strong)UILabel *titleLabel;
@end
@implementation XYScreeningItemCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
#pragma mark - 界面布局
-(void)newView{
  self.bgView = [LSHControl viewWithBackgroundColor:ColorHex(XYTextColor_EEEEEE)];
  [self.bgView roundSize:5];
  [self.contentView addSubview:self.bgView];
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.contentView);
  }];
  
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_999999)];
  [self.bgView addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.bgView);
  }];
  
}
-(void)setIsSelected:(BOOL)isSelected{
  _isSelected = isSelected;
  
  if (self.colortype == 1) {
    self.titleLabel.textColor = isSelected?ColorHex(@"#F92B5E"):ColorHex(XYTextColor_CCCCCC);
    [self.bgView roundSize:AutoSize(10) color:isSelected?ColorHex(@"#F92B5E"):ColorHex(XYTextColor_CCCCCC)];
    
   self.bgView.backgroundColor =ColorHex(XYTextColor_FFFFFF);
  }else  if (self.colortype == 2) {
    self.titleLabel.textColor = isSelected?ColorHex(XYTextColor_FFFFFF):ColorHex(@"#F92B5E");
    [self.bgView roundSize:AutoSize(14) color:ColorHex(@"#F92B5E")];
    

    self.bgView.backgroundColor = isSelected?ColorHex(@"#F92B5E"):ColorHex(XYTextColor_FFFFFF);
  }else{
    self.titleLabel.textColor = isSelected?ColorHex(@"#6160F0"):ColorHex(XYTextColor_999999);
    self.bgView.backgroundColor = isSelected?ColorHex(@"#e7e7ff"):ColorHex(XYTextColor_EEEEEE);
  }
  

}
@end
