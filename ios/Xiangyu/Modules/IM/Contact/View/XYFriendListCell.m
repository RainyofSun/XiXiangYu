//
//  XYFriendListCell.m
//  Xiangyu
//
//  Created by dimon on 04/02/2021.
//

#import "XYFriendListCell.h"

@interface XYFriendListCell ()

@property (strong, nonatomic) UIImageView *icon;

@property (strong, nonatomic) YYLabel *nameLabel;

@property (strong, nonatomic) UILabel *subTitleLabel;

@property (strong, nonatomic) UILabel *subsubTitleLabel;

@property (strong, nonatomic) UILabel *distanceLabel;

@property (strong, nonatomic) UIButton *addBtn;

@end

@implementation XYFriendListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)buttonAction {
  if (self.actionBlock) {
    self.actionBlock(self.item);
  }
}

- (void)setItem:(XYFriendItem *)item {
  _item = item;
  [self.icon sd_setImageWithURL:[NSURL URLWithString:item.headPortrait]];
  
  
  _nameLabel.font = AdaptedMediumFont(XYFont_E);
  NSMutableAttributedString *text = [NSMutableAttributedString new];
  UIFont *font = AdaptedMediumFont(XYFont_E);
  NSAttributedString *text_attr = [[NSAttributedString alloc] initWithString:item.nickName attributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_333333),NSFontAttributeName:font}];
  [text appendAttributedString:text_attr];
    
  UIImage *sexImage = item.sex.integerValue == 2 ? [UIImage imageNamed:@"icon_12_girl"] : [UIImage imageNamed:@"icon_12_boy"];
  NSMutableAttributedString *levelAttachment = [NSMutableAttributedString yy_attachmentStringWithContent:sexImage contentMode:UIViewContentModeCenter attachmentSize:sexImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
  [text appendAttributedString: levelAttachment];
  
  self.nameLabel.attributedText = text;
  
 // self.subTitleLabel.text = [NSString stringWithFormat:@"行业：%@", item.twoIndustry.toSafeValue];
  self.subsubTitleLabel.text = [NSString stringWithFormat:@"故乡：%@", [[XYAddressService sharedService] queryCityAreaNameWithAdcode:item.area]];
  self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", [item.distance doubleValue]];
}

- (void)setIsFriend:(BOOL)isFriend {
  _isFriend = isFriend;
  [_addBtn setTitle:@"聊天" forState:UIControlStateNormal];
 // self.distanceLabel.hidden = !isFriend;
  
}
-(void)setCenterAction:(BOOL)centerAction{
  _centerAction = centerAction;
  self.distanceLabel.hidden = centerAction;
  [self.addBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.right.equalTo(self.contentView).offset(-16);
    make.width.mas_equalTo(56);
    make.height.mas_equalTo(24);
  }];
  
}
- (void)setupSubViews {
  [self.contentView addSubview:self.icon];
  [self.contentView addSubview:self.nameLabel];
 // [self.contentView addSubview:self.subTitleLabel];
 [self.contentView addSubview:self.subsubTitleLabel];
  [self.contentView addSubview:self.distanceLabel];
  [self.contentView addSubview:self.addBtn];
  
  [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentView).offset(12);
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
  
  [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.nameLabel);
    make.right.equalTo(self.contentView).offset(-16);
  }];
  
  [self.addBtn mas_updateConstraints:^(MASConstraintMaker *make) {
    make.bottom.equalTo(self.contentView).offset(-12);
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

- (YYLabel *)nameLabel {
    if (!_nameLabel) {
      _nameLabel = [[YYLabel alloc] init];
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
    _addBtn.layer.cornerRadius = 12;
    _addBtn.layer.masksToBounds = YES;
    [_addBtn addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
  }
  return _addBtn;
}
@end
