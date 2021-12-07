//
//  XYTimelineProfileInfoCell.m
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import "XYTimelineProfileHeaderCell.h"
#import "XYAddressService.h"

@interface XYTimelineProfileInfoItemView : UIView

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *statusLable;

@end

@implementation XYTimelineProfileInfoItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.statusLable];
    
    [self.statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
    }];
    
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
      _titleLabel.textColor = ColorHex(XYTextColor_999999);
      _titleLabel.font = AdaptedFont(12);
    }
    return _titleLabel;
}

- (UILabel *)statusLable {
    if (!_statusLable) {
        _statusLable = [[UILabel alloc] init];
        _statusLable.textAlignment = NSTextAlignmentCenter;
      _statusLable.textColor = ColorHex(XYTextColor_222222);
      _statusLable.font = AdaptedMediumFont(16);
    }
    return _statusLable;
}
@end

@interface XYTimelineProfileHeaderCell()
@property(nonatomic,strong)UIView *bgView;

@property (nonatomic, strong) UILabel *nameLable;

@property (nonatomic, strong) UIImageView *sexView;

@property (nonatomic, strong) UIImageView *statusImageView;

@property (nonatomic, strong) UILabel *industryLable;

@property (nonatomic, strong) UILabel *hometownLable;

@property (nonatomic, strong) UIButton *remarkBtn;

@property (nonatomic, strong) XYTimelineProfileInfoItemView *fansView;

@property (nonatomic, strong) XYTimelineProfileInfoItemView *attentionView;

@property (nonatomic, strong) XYTimelineProfileInfoItemView *likesView;

@property (nonatomic, strong) XYTimelineProfileInfoItemView *giftView;

@end

@implementation XYTimelineProfileHeaderCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
      self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutUI];
    }
    return self;
}

#pragma mark - action
- (void)addFriends {
  if (self.addFriendsBlock && self.model) {
    self.addFriendsBlock();
  }
}

- (void)attention {
  if (self.attentionBlock && self.model) {
    self.attentionBlock();
  }
}
- (void)remark {
  if (self.remarkBlock && self.model) {
    self.remarkBlock();
  }
}


- (void)setModel:(XYTimelineProfileModel *)model {
  _model = model;
  if (!model) return;
  self.attentionBtn.hidden = model.userId.integerValue == [[XYUserService service] fetchLoginUser].userId.integerValue;
  self.addBtn.hidden = model.userId.integerValue == [[XYUserService service] fetchLoginUser].userId.integerValue;
  
  if (model.isFollow.integerValue == 1) {
    
    [self.attentionBtn setTitle:@"已关注" forState:UIControlStateSelected];
    self.attentionBtn.layer.borderWidth = 0.0;
    [self.attentionBtn setBackgroundColor:ColorHex(XYThemeColor_I)];
    [self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    [self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
    self.attentionBtn.selected = YES;
  } else {
    self.attentionBtn.selected = NO;
    self.attentionBtn.layer.borderWidth = 0.0;
    [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.attentionBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
    [self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    [self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
  }
  [self.addBtn setTitle: @"聊天"  forState:UIControlStateNormal];
  
  self.nameLable.text = model.nickName ?: @"";
  self.sexView.image = [UIImage imageNamed:model.sex.intValue == 2 ? @"icon_12_girl" : @"icon_12_boy"];
  self.statusImageView.image = [UIImage imageNamed:(model.status.intValue == 1 || model.status.intValue == 2) ? @"authentication1" : @"authentication2"];
  [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.headPortrait]];
  //[self.iconBgView sd_setImageWithURL:[NSURL URLWithString:model.headPortrait]];
  self.industryLable.text = model.twoIndustry ? [NSString stringWithFormat:@"行业：%@", model.twoIndustry] : @"";
  self.hometownLable.text = model.area ? [NSString stringWithFormat:@"故乡：%@", [[XYAddressService sharedService] queryFormattNameWithAdcode:model.area]] : @"";
  
  self.fansView.statusLable.text = model.fansCount.stringValue;
  self.attentionView.statusLable.text = model.followCount.stringValue;
  self.likesView.statusLable.text = model.likeCount.stringValue;
  self.giftView.statusLable.text = model.giftCount.stringValue;
}

- (void)layoutUI {
  
  [self.contentView addSubview:self.iconBgView];
  
  [self.contentView addSubview:self.bgView];
  [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.bottom.trailing.equalTo(self.contentView);
    make.top.equalTo(self.contentView).offset(140);
  }];
  
  [self.contentView addSubview:self.iconView];
  
  [self.contentView addSubview:self.addBtn];
  [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.mas_equalTo(-15);
      make.width.mas_equalTo(68);
      make.height.mas_equalTo(28);
      make.top.mas_equalTo(self).offset(156);
  }];
  
  [self.contentView addSubview:self.attentionBtn];
  [self.attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.mas_equalTo(self.addBtn.mas_left).offset(-8);
      make.width.mas_equalTo(68);
      make.height.mas_equalTo(28);
      make.top.mas_equalTo(self).offset(156);
  }];
  
  [self.contentView addSubview:self.nameLable];
  [self.nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(14);
      make.top.mas_equalTo(self).offset(213);
  }];
  
  [self.contentView addSubview:self.sexView];
  [self.sexView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(self.nameLable.mas_right).offset(8);
      make.centerY.mas_equalTo(self.nameLable);
    make.width.height.mas_equalTo(12);
  }];
  
  [self.contentView addSubview:self.statusImageView];
  [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.sexView.mas_right).offset(12);
    make.centerY.mas_equalTo(self.nameLable);
    make.width.mas_equalTo(68);
    make.height.mas_equalTo(20);
  }];
  
  [self.contentView addSubview:self.industryLable];
  [self.industryLable mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(14);
      make.top.mas_equalTo(self.nameLable.mas_bottom).offset(4);
  }];
  
  [self.contentView addSubview:self.hometownLable];
  [self.hometownLable mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(14);
      make.top.mas_equalTo(self.industryLable.mas_bottom).offset(4);
  }];
  
//  [self.contentView addSubview:self.remarkBtn];
//  [self.remarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.right.mas_equalTo(-10);
//      make.centerY.mas_equalTo(self.industryLable);
//    make.width.mas_equalTo(56);
//    make.height.mas_equalTo(24);
//  }];
  
  CGFloat width = (kScreenWidth - 3)/4;
  [self.contentView addSubview:self.fansView];
  [self.fansView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(0);
    make.top.mas_equalTo(self.hometownLable.mas_bottom).offset(24);
    make.width.mas_equalTo(width);
    make.height.mas_equalTo(48);
  }];
  
  UIView *line1 = [UIView new];
  line1.backgroundColor = ColorHex(XYThemeColor_E);
  [self.contentView addSubview:line1];
  [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.fansView.mas_right);
    make.centerY.mas_equalTo(self.fansView);
    make.width.mas_equalTo(1);
    make.height.mas_equalTo(24);
  }];
  
  [self.contentView addSubview:self.attentionView];
  [self.attentionView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(line1.mas_right);
    make.top.mas_equalTo(self.hometownLable.mas_bottom).offset(24);
    make.width.mas_equalTo(width);
    make.height.mas_equalTo(48);
  }];
  
  UIView *line2 = [UIView new];
  line2.backgroundColor = ColorHex(XYThemeColor_E);
  [self.contentView addSubview:line2];
  [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.attentionView.mas_right);
    make.centerY.mas_equalTo(self.fansView);
    make.width.mas_equalTo(1);
    make.height.mas_equalTo(24);
  }];
  
  [self.contentView addSubview:self.likesView];
  [self.likesView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(line2.mas_right);
    make.top.mas_equalTo(self.hometownLable.mas_bottom).offset(24);
    make.width.mas_equalTo(width);
    make.height.mas_equalTo(48);
  }];
  
  UIView *line3 = [UIView new];
  line3.backgroundColor = ColorHex(XYThemeColor_E);
  [self.contentView addSubview:line3];
  [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(self.likesView.mas_right);
    make.centerY.mas_equalTo(self.fansView);
    make.width.mas_equalTo(1);
    make.height.mas_equalTo(24);
  }];
  
  [self.contentView addSubview:self.giftView];
  [self.giftView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(line3.mas_right);
    make.top.mas_equalTo(self.hometownLable.mas_bottom).offset(24);
    make.width.mas_equalTo(width);
    make.height.mas_equalTo(48);
  }];
}
#pragma mark - getter
- (UIImageView *)iconView {
  if (!_iconView) {
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(24, 120, 80, 80)];
    _iconView.layer.cornerRadius = 40;
    _iconView.layer.masksToBounds = YES;
  }
  return _iconView;
}

-(UIButton *)addBtn {
  if (!_addBtn) {
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setBackgroundColor:ColorHex(XYTextColor_635FF0)];
    [_addBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    _addBtn.titleLabel.font = AdaptedFont(12);
    _addBtn.layer.cornerRadius = 14;
    _addBtn.layer.masksToBounds = YES;
    [_addBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    _addBtn.hidden = YES;
  }
  return _addBtn;
}

- (UIButton *)attentionBtn {
  if (!_attentionBtn) {
    _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_attentionBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
    [_attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    _attentionBtn.titleLabel.font = AdaptedFont(12);
    _attentionBtn.layer.cornerRadius = 14;
    _attentionBtn.layer.masksToBounds = YES;
    [_attentionBtn addTarget:self action:@selector(attention) forControlEvents:UIControlEventTouchUpInside];
    _attentionBtn.hidden = YES;
  }
  return _attentionBtn;
}

- (UILabel *)nameLable {
    if (!_nameLable) {
      _nameLable = [[UILabel alloc] init];
      _nameLable.textColor = ColorHex(XYTextColor_999999);
      _nameLable.font = AdaptedFont(12);
    }
    return _nameLable;
}

- (UIImageView *)sexView {
  if (!_sexView) {
    _sexView = [[UIImageView alloc] init];
  }
  return _sexView;
}

- (UIImageView *)statusImageView {
  if (!_statusImageView) {
    _statusImageView = [[UIImageView alloc] init];
  }
  return _statusImageView;
}

- (UILabel *)industryLable {
    if (!_industryLable) {
      _industryLable = [[UILabel alloc] init];
      _industryLable.textColor = ColorHex(XYTextColor_999999);
      _industryLable.font = AdaptedFont(12);
    }
    return _industryLable;
}

- (UILabel *)hometownLable {
    if (!_hometownLable) {
      _hometownLable = [[UILabel alloc] init];
      _hometownLable.textColor = ColorHex(XYTextColor_999999);
      _hometownLable.font = AdaptedFont(12);
    }
    return _hometownLable;
}

- (UIButton *)remarkBtn {
  if (!_remarkBtn) {
    _remarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_remarkBtn addTarget:self action:@selector(remark) forControlEvents:UIControlEventTouchUpInside];
    [_remarkBtn setTitle:@"备注" forState:UIControlStateNormal];
    [_remarkBtn setTitleColor:ColorHex(XYTextColor_999999) forState:UIControlStateNormal];
    _remarkBtn.titleLabel.font = AdaptedFont(12);
    _remarkBtn.layer.cornerRadius = 12;
    _remarkBtn.layer.masksToBounds = YES;
    _remarkBtn.layer.borderWidth = 1;
    _remarkBtn.layer.borderColor = ColorHex(XYThemeColor_I).CGColor;
  }
  return _remarkBtn;
}

- (XYTimelineProfileInfoItemView *)fansView {
    if (!_fansView) {
      _fansView = [[XYTimelineProfileInfoItemView alloc] init];
      _fansView.titleLabel.text = @"粉丝";
      _fansView.statusLable.text = @"0";
    }
    return _fansView;
}

- (XYTimelineProfileInfoItemView *)attentionView {
    if (!_attentionView) {
      _attentionView = [[XYTimelineProfileInfoItemView alloc] init];
      _attentionView.titleLabel.text = @"关注";
      _attentionView.statusLable.text = @"0";
    }
    return _attentionView;
}

- (XYTimelineProfileInfoItemView *)likesView {
    if (!_likesView) {
      _likesView = [[XYTimelineProfileInfoItemView alloc] init];
      _likesView.titleLabel.text = @"点赞";
      _likesView.statusLable.text = @"0";
    }
    return _likesView;
}

- (XYTimelineProfileInfoItemView *)giftView {
    if (!_giftView) {
      _giftView = [[XYTimelineProfileInfoItemView alloc] init];
      _giftView.titleLabel.text = @"礼物";
      _giftView.statusLable.text = @"0";
    }
    return _giftView;
}

- (UIImageView *)iconBgView {
    if (!_iconBgView) {
      _iconBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 155)];
      _iconBgView.image = [UIImage imageNamed:@"pic_bg5"];
      _iconBgView.contentMode =  UIViewContentModeScaleAspectFill;
      _iconBgView.clipsToBounds = YES;
      UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
      UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];;
      effectView.frame = CGRectMake(0, 0, kScreenWidth, 155);
      [_iconBgView addSubview:effectView];
      //effectView.alpha = 0.9f;
    }
    return _iconBgView;
}
-(UIView *)bgView{
  if (!_bgView) {
    _bgView = [UIView new];
    _bgView.layer.cornerRadius = 10;
    _bgView.layer.masksToBounds = YES;
    _bgView.backgroundColor = ColorHex(XYTextColor_FFFFFF);
  }
  return _bgView;
}
@end
