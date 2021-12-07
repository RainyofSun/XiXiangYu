//
//  XYBlindGiftListCCell.m
//  Xiangyu
//
//  Created by GQLEE on 2021/3/18.
//

#import "XYBlindGiftListCCell.h"

@implementation XYBlindGiftListCCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (id subView in self.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        [self autoLayoutMas];
    }
    return self;
}
- (void)autoLayoutMas {
    [self.contentView addSubview:self.iconImg];
  [self.contentView addSubview:self.titleLab];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(72);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
  [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self.iconImg.mas_bottom).offset(8);
      make.height.mas_equalTo(17);
    make.centerX.mas_equalTo(self.contentView.mas_centerX);
  }];
}
-(UIImageView *)iconImg{
    if(!_iconImg){
        _iconImg = [[UIImageView alloc]init];
    }
    return _iconImg;
}
-(UILabel *)titleLab {
  if (!_titleLab) {
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont systemFontOfSize:13];
    _titleLab.textColor = ColorHex(@"#ffffff");
  }
  return  _titleLab;
}
@end
