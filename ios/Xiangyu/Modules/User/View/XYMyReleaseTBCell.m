//
//  XYMyReleaseTBCell.m
//  Xiangyu
//
//  Created by GQLEE on 2021/2/25.
//

#import "XYMyReleaseTBCell.h"

@implementation XYMyReleaseTBCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.contentView.backgroundColor = ColorHex(@"#F5F5F5");
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.arrowView];
  
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.contentView).offset(ADAPTATIONRATIO * 32);
    make.top.equalTo(self.contentView).offset(ADAPTATIONRATIO * 16);
    make.right.equalTo(self.contentView).offset(-ADAPTATIONRATIO * 32);
    make.height.mas_equalTo(ADAPTATIONRATIO * 160);
  }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(ADAPTATIONRATIO * 32);
        make.centerY.equalTo(self);
      make.width.height.mas_equalTo(ADAPTATIONRATIO * 72);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(11);
        make.centerY.equalTo(self);
    }];
  
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-16);
        make.centerY.equalTo(self);
    }];
  
    
}


- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UIImageView *)arrowView {
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_arrow_gray"]];
    }
    return _arrowView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = ColorHex(XYTextColor_222222);
        _titleLabel.font = AdaptedFont(XYFont_E);
    }
    return _titleLabel;
}

- (UIView *)bgView {
  if (!_bgView) {
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.cornerRadius = 8;
    _bgView.layer.masksToBounds = YES;
  }
  return  _bgView;
}

@end
