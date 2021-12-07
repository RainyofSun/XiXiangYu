//
//  XYHomeRecommendCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import "XYHomeRecommendCell.h"

@interface XYHomeRecommendCell ()

@property (strong, nonatomic) UIImageView *icon;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UILabel *subTitleLabel;

@property (strong, nonatomic) UILabel *subsubTitleLabel;

@property (strong, nonatomic) UIButton *addBtn;

@end

@implementation XYHomeRecommendCell

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

//  self.subTitleLabel.text = item.subTitle;
  self.subsubTitleLabel.text = item.subsubTitle;
  if (item.isGroup) {
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = _nameLabel.font;
    NSAttributedString *text_attr = [[NSAttributedString alloc] initWithString:item.name attributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_333333),NSFontAttributeName:font}];
    [text appendAttributedString:text_attr];
    
    self.nameLabel.attributedText = text;
    self.addBtn.enabled = YES;
    [self.addBtn setTitle:@"进群" forState:UIControlStateNormal];
  } else {
    self.addBtn.enabled = !item.isAdded;
    [self.addBtn setTitle:@"聊天" forState:UIControlStateNormal];
    [self.addBtn setBackgroundColor:item.isAdded ? ColorHex(XYThemeColor_K) : ColorHex(XYThemeColor_A)];
    
 
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = _nameLabel.font;
    NSAttributedString *text_attr = [[NSAttributedString alloc] initWithString:item.name attributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_333333),NSFontAttributeName:font}];
    [text appendAttributedString:text_attr];
      
    UIImage *sexImage = item.sex.integerValue == 2 ? [UIImage imageNamed:@"icon_12_girl"] : [UIImage imageNamed:@"icon_12_boy"];
    NSMutableAttributedString *levelAttachment = [NSMutableAttributedString yy_attachmentStringWithContent:sexImage contentMode:UIViewContentModeCenter attachmentSize:sexImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString: levelAttachment];
    
    self.nameLabel.attributedText = text;
    
    
  }
}

- (void)setupSubViews {
  [self.contentView addSubview:self.icon];
  [self.contentView addSubview:self.nameLabel];
//  [self.contentView addSubview:self.subTitleLabel];
  [self.contentView addSubview:self.subsubTitleLabel];
  [self.contentView addSubview:self.addBtn];
  
  [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentView);
    make.left.equalTo(self.contentView).offset(16);
    make.width.height.mas_equalTo(44);
  }];
  
  [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.icon);
    make.left.equalTo(self.icon.mas_right).offset(12);
    make.height.mas_equalTo(22);
  }];
  
//  [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
//    make.left.equalTo(self.nameLabel);
//  }];
  
  [self.subsubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.nameLabel.mas_bottom);
    make.left.equalTo(self.nameLabel);
    make.height.mas_equalTo(22);
  }];
  
  [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
      _icon.layer.cornerRadius = 26;
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
