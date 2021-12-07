//
//  XYIndustryCircleCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import "XYIndustryCircleCell.h"

@interface XYIndustryCircleCell ()

@property (strong, nonatomic) UIImageView *icon;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *subTitleLabel;

@property (strong, nonatomic) UILabel *subsubTitleLabel;

@property (strong, nonatomic) UILabel *distanceLabel;

@property (strong, nonatomic) UIButton *addBtn;

@end

@implementation XYIndustryCircleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)add {
  if (self.addBlock) {
    self.addBlock(self.item);
  }
}

- (void)setItem:(XYInterestItem *)item {
  _item = item;
  [self.icon sd_setImageWithURL:[NSURL URLWithString:item.picURL]];
  self.nameLabel.text = item.name;
  self.subTitleLabel.text = item.subTitle;
  self.subsubTitleLabel.text = item.subsubTitle;
  
self.subTitleLabel.text = [NSString stringWithFormat:@"行业：%@", item.subTitle];
   self.subsubTitleLabel.text = [NSString stringWithFormat:@"故乡：%@", item.subsubTitle];
  
  
  //self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", [item.distance doubleValue]];
  self.subsubTitleLabel.hidden = item.isGroup;
  if (item.isGroup) {
    [self.addBtn setTitle:@"进群" forState:UIControlStateNormal];
  } else {
    [self.addBtn setTitle: @"聊天"  forState:UIControlStateNormal];
  }
}

- (void)setupSubViews {
  [self.contentView addSubview:self.icon];
  [self.contentView addSubview:self.nameLabel];
  [self.contentView addSubview:self.subTitleLabel];
  [self.contentView addSubview:self.subsubTitleLabel];
  
  [self.contentView addSubview:self.distanceLabel];
  
  [self.contentView addSubview:self.addBtn];
  
  [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.left.equalTo(self.contentView).offset(16);
    make.width.height.mas_equalTo(44);
  }];
  
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentView).offset(12);
    make.left.equalTo(self.icon.mas_right).offset(16);
  }];
  
  [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
    make.left.equalTo(self.nameLabel);
  }];
  
  [self.subsubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.subTitleLabel.mas_bottom).offset(2);
    make.left.equalTo(self.nameLabel);
  }];
  
  [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.nameLabel);
    make.right.equalTo(self.contentView).offset(-16);
  }];
  
  [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
   // make.centerY.equalTo(self.subTitleLabel.mas_bottom).offset(1);
    make.centerY.equalTo(self.icon);
    make.right.equalTo(self.contentView).offset(-16);
    make.width.mas_equalTo(56);
    make.height.mas_equalTo(24);
  }];

}

#pragma mark - getter

- (UIImageView *)icon {
    if (!_icon) {
      _icon = [[UIImageView alloc] init];
      _icon.layer.cornerRadius = 22;
      _icon.layer.masksToBounds = YES;
    }
    return _icon;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
      _nameLabel = [[UILabel alloc] init];
      _nameLabel.textColor = ColorHex(XYTextColor_333333);
      _nameLabel.font = AdaptedMediumFont(XYFont_E);
    }
    return _nameLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
      _subTitleLabel = [[UILabel alloc] init];
      _subTitleLabel.textColor = ColorHex(XYTextColor_999999);
      _subTitleLabel.font = AdaptedFont(XYFont_B);
    }
    return _subTitleLabel;
}

- (UILabel *)subsubTitleLabel {
    if (!_subsubTitleLabel) {
      _subsubTitleLabel = [[UILabel alloc] init];
      _subsubTitleLabel.textColor = ColorHex(XYTextColor_999999);
      _subsubTitleLabel.font = AdaptedFont(XYFont_B);
    }
    return _subsubTitleLabel;
}
- (UILabel *)distanceLabel {
    if (!_distanceLabel) {
      _distanceLabel = [[UILabel alloc] init];
      _distanceLabel.textColor = ColorHex(XYTextColor_635FF0);
      _distanceLabel.font = AdaptedFont(12);
    }
    return _distanceLabel;
}
- (UIButton *)addBtn {
  if (!_addBtn) {
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
    _addBtn.titleLabel.font = AdaptedFont(XYFont_B);
    [_addBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.layer.cornerRadius = 12;
    _addBtn.layer.masksToBounds = YES;
  }
  return _addBtn;
}
@end
