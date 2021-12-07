//
//  XYFriendListCell.m
//  Xiangyu
//
//  Created by dimon on 04/02/2021.
//

#import "XYSearchCell.h"

@interface XYDemandCell ()

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *addressLabel;

@property (strong, nonatomic) UILabel *contentLabel;

@property (strong, nonatomic) YYLabel *contactsLabel;

@property (strong, nonatomic) UIView *line;

@property (strong, nonatomic) UILabel *hometownLabel;

@end

@implementation XYDemandCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.contentView.backgroundColor = ColorHex(XYThemeColor_F);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setItem:(XYDemandModel *)item {
  _item = item;
  
  self.titleLabel.text = item.title;
  
  self.addressLabel.text = item.address;
  
  self.contentLabel.text = item.content;
  
  NSMutableAttributedString *text = [NSMutableAttributedString new];
  UIFont *font = AdaptedFont(12);
  
  UIImage *sexImage = [UIImage imageNamed:@"icon_12_xinxi"];
  NSMutableAttributedString *levelAttachment = [NSMutableAttributedString yy_attachmentStringWithContent:sexImage contentMode:UIViewContentModeCenter attachmentSize:sexImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
  [text appendAttributedString: levelAttachment];
  
  NSAttributedString *text_attr1 = [[NSAttributedString alloc] initWithString:item.linkName ? [NSString stringWithFormat:@" %@", item.linkName]: @" " attributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_999999),NSFontAttributeName:font}];
  [text appendAttributedString:text_attr1];
  
  NSAttributedString *text_attr2 = [[NSAttributedString alloc] initWithString:item.phone ? [NSString stringWithFormat:@"  %@", [item.phone stringByReplacingCharactersInRange:NSMakeRange(4, 4) withString:@"****"]]: @"  " attributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_999999),NSFontAttributeName:font}];
  [text appendAttributedString:text_attr2];

  self.contactsLabel.attributedText = text;

  self.hometownLabel.text = [NSString stringWithFormat:@"故乡：%@", [[XYAddressService sharedService] queryCityAreaNameWithAdcode:item.area]];
}

- (void)setupSubViews {
  [self.contentView addSubview:self.bgView];
  [self.bgView addSubview:self.titleLabel];
  [self.bgView addSubview:self.addressLabel];
  [self.bgView addSubview:self.contentLabel];
  [self.bgView addSubview:self.line];
  [self.bgView addSubview:self.contactsLabel];
  [self.bgView addSubview:self.hometownLabel];
  
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.insets(UIEdgeInsetsMake(8, 0, 0, 0));
  }];
  
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentView).offset(16);
    make.left.equalTo(self.contentView).offset(16);
    make.right.equalTo(self.contentView).offset(-16);
  }];
  
  [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
    make.left.equalTo(self.contentView).offset(16);
  }];
  
  [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.addressLabel.mas_bottom).offset(7);
    make.left.equalTo(self.contentView).offset(16);
  }];
  
  [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentLabel.mas_bottom).offset(12);
    make.left.right.equalTo(self.contentView);
    make.height.mas_equalTo(1);
  }];
  
  [self.contactsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentLabel.mas_bottom).offset(25);
    make.left.equalTo(self.contentView).offset(16);
  }];
  
  [self.hometownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contactsLabel);
    make.right.equalTo(self.contentView).offset(-16);
  }];

}

#pragma mark - getter

- (UIView *)bgView {
    if (!_bgView) {
      _bgView = [[UIView alloc] init];
      _bgView.backgroundColor = ColorHex(XYThemeColor_B);
      _bgView.layer.cornerRadius = 8;
      _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
      _titleLabel = [[UILabel alloc] init];
      _titleLabel.textColor = ColorHex(XYTextColor_222222);
      _titleLabel.font = AdaptedFont(16);
    }
    return _titleLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
      _addressLabel = [[UILabel alloc] init];
      _addressLabel.textColor = ColorHex(XYTextColor_999999);
      _addressLabel.font = AdaptedFont(12);
    }
    return _addressLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
      _contentLabel = [[UILabel alloc] init];
      _contentLabel.textColor = ColorHex(XYTextColor_222222);
      _contentLabel.font = AdaptedFont(14);
    }
    return _contentLabel;
}

- (UIView *)line {
    if (!_line) {
      _line = [[UIView alloc] init];
      _line.backgroundColor = ColorHex(XYThemeColor_E);
    }
    return _line;
}

- (YYLabel *)contactsLabel {
    if (!_contactsLabel) {
      _contactsLabel = [[YYLabel alloc] init];
    }
    return _contactsLabel;
}

- (UILabel *)hometownLabel {
    if (!_hometownLabel) {
      _hometownLabel = [[UILabel alloc] init];
      _hometownLabel.textColor = ColorHex(XYTextColor_999999);
      _hometownLabel.font = AdaptedFont(12);
    }
    return _hometownLabel;
}

@end

@interface XYActivityCell ()

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation XYActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setItem:(XYActivityModel *)item {
  _item = item;
  
  self.titleLabel.text = item.title;
  
  [self.iconView sd_setImageWithURL:[NSURL URLWithString:item.resource]];
  
  
  NSString * startTime = [[NSDate dateWithString:item.validityStart format:XYFullDateFormatterName] stringWithFormat:XYYTDDateFormatterName];
  NSString * endTime = [[NSDate dateWithString:item.validityEnd format:XYFullDateFormatterName] stringWithFormat:XYYTDDateFormatterName];
  self.timeLabel.text = [NSString stringWithFormat:@"时间：%@ ~ %@",startTime, endTime];
  
  self.contentLabel.text = item.content;
}

- (void)setupSubViews {
  [self.contentView addSubview:self.iconView];
  [self.contentView addSubview:self.titleLabel];
  [self.contentView addSubview:self.timeLabel];
  [self.contentView addSubview:self.contentLabel];
  
  [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self.contentView);
    make.left.equalTo(self.contentView).offset(16);
    make.width.height.mas_equalTo(80);
  }];
  
  [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.contentView).offset(16);
    make.left.equalTo(self.iconView.mas_right).offset(15);
    make.right.equalTo(self.contentView).offset(-16);
  }];
  
  [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
    make.left.equalTo(self.titleLabel);
  }];
  
  [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.timeLabel.mas_bottom).offset(8);
    make.left.equalTo(self.timeLabel);
  }];

}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
      _titleLabel = [[UILabel alloc] init];
      _titleLabel.textColor = ColorHex(XYTextColor_222222);
      _titleLabel.font = AdaptedFont(16);
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
      _timeLabel = [[UILabel alloc] init];
      _timeLabel.textColor = ColorHex(XYTextColor_999999);
      _timeLabel.font = AdaptedFont(12);
    }
    return _timeLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
      _contentLabel = [[UILabel alloc] init];
      _contentLabel.textColor = ColorHex(XYTextColor_222222);
      _contentLabel.font = AdaptedFont(14);
    }
    return _contentLabel;
}

- (UIImageView *)iconView {
    if (!_iconView) {
      _iconView = [[UIImageView alloc] init];
      _iconView.layer.cornerRadius = 8;
      _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}


@end
