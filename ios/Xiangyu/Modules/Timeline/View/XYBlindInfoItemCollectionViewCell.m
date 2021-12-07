//
//  XYBlindInfoItemCollectionViewCell.m
//  Xiangyu
//
//  Created by Kang on 2021/6/30.
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
#import "XYBlindInfoItemCollectionViewCell.h"
@interface XYBlindInfoItemCollectionViewCell ()
@property(nonatomic,strong)UIView *bgView;
@end
@implementation XYBlindInfoItemCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
#pragma mark - 界面布局
-(void)newView{
  self.bgView = [LSHControl viewWithBackgroundColor:ColorHex(@"#F5F5F5")];
  [self.bgView roundSize:AutoSize(13)];
  [self.contentView addSubview:self.bgView];
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.contentView);
  }];
  
  
  self.titleLabel = [LSHControl createLabelFromFont:AdaptedFont(12) textColor:ColorHex(XYTextColor_666666) text:@""];
  [self.bgView addSubview:self.titleLabel];
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.bgView);
  }];
  
  
  
}
+(CGSize)getItemCellSizeWithData:(NSString *)string{

    UILabel *temp = [[UILabel alloc] init];
    temp.font = AdaptedFont(12);
    temp.numberOfLines = 0;
    temp.text = string;
  return CGSizeMake([temp sizeThatFits:CGSizeMake(kScreenWidth-AutoSize(56), CGFLOAT_MAX)].width+AutoSize(20), AutoSize(26));
  
}
@end
