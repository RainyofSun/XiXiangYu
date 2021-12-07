//
//  XYGiftPaymentCollectionViewCell.m
//  Xiangyu
//
//  Created by GQLEE on 2021/3/15.
//

#import "XYGiftPaymentCollectionViewCell.h"

@implementation XYGiftPaymentCollectionViewCell

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
  [self.contentView addSubview:self.titleLab];
    
  [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(24);
    make.width.mas_equalTo(56);
    make.centerY.mas_equalTo(self.contentView.mas_centerY);
    make.centerX.mas_equalTo(self.contentView.mas_centerX);
  }];
}
-(UILabel *)titleLab {
  if (!_titleLab) {
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont systemFontOfSize:12];
    _titleLab.textColor = ColorHex(@"#FE2D63");
    _titleLab.layer.masksToBounds = YES;
    _titleLab.layer.cornerRadius = 12;
    _titleLab.textAlignment = NSTextAlignmentCenter;
    _titleLab.layer.borderColor = ColorHex(@"#FE2D63").CGColor;
    _titleLab.layer.borderWidth = 1;
  }
  return  _titleLab;
}
@end
