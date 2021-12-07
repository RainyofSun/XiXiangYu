//
//  XYGiftCollectionViewCell.m
//  Xiangyu
//
//  Created by GQLEE on 2021/3/13.
//

#import "XYGiftCollectionViewCell.h"

@implementation XYGiftCollectionViewCell

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
  [self.contentView addSubview:self.decLab];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(72);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
  [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self.iconImg.mas_bottom).offset(8);
      make.height.mas_equalTo(17);
    make.centerX.mas_equalTo(self.contentView.mas_centerX);
  }];
  [self.decLab mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(self.titleLab.mas_bottom).offset(2);
      make.height.mas_equalTo(12);
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
    _titleLab.font =AdaptedFont(14);
    _titleLab.textColor = ColorHex(@"#333333");
  }
  return  _titleLab;
}
-(UILabel *)decLab {
  if (!_decLab) {
    _decLab = [[UILabel alloc] init];
    _decLab.font = AdaptedFont(12);
    _decLab.textColor = ColorHex(@"#999999");
  }
  return  _decLab;
}

@end
