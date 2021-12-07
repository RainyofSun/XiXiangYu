//
//  XYHomeTaskCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/6/1.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYHomeTaskCell.h"

@interface XYHomeTaskCell ()

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UIView *contentBgView;

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) YYLabel *detailLable;

@property (strong, nonatomic) UILabel *contentLable;

@property (strong, nonatomic) UIButton *actionBtn;

@end

@implementation XYHomeTaskCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      self.contentView.backgroundColor = ColorHex(XYThemeColor_F);
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.contentBgView];
  
    [self.contentBgView addSubview:self.iconView];
    [self.contentBgView addSubview:self.titleLabel];
    [self.contentBgView addSubview:self.detailLable];
    [self.contentBgView addSubview:self.actionBtn];
  
    [self.bgView addSubview:self.contentLable];
    
    [self.bgView makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.contentView).offset(4);
      make.bottom.equalTo(self.contentView).offset(-4);
      make.left.equalTo(self.contentView).offset(16);
      make.right.equalTo(self.contentView).offset(-16);
    }];
  
    [self.contentBgView mas_updateConstraints:^(MASConstraintMaker *make) {
      make.left.right.top.equalTo(self.bgView);
      make.height.mas_offset(80);
    }];
    
    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.contentBgView).offset(16);
      make.top.equalTo(self.contentBgView).offset(22);
      make.width.height.mas_equalTo(36);
    }];
    
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentBgView).offset(17);
        make.left.equalTo(self.iconView.mas_right).offset(18);
    }];
    
    [self.detailLable makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.equalTo(self.titleLabel);
    }];
    
    [self.actionBtn makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.contentBgView).offset(26);
      make.right.equalTo(self.contentBgView).offset(-16);
      make.width.mas_equalTo(68);
      make.height.mas_equalTo(28);
    }];
  
  [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(0);
    make.right.equalTo(self.bgView).offset(-16);
    make.left.equalTo(self.bgView).offset(16);
    make.bottom.equalTo(self.bgView).offset(0);
  }];
}

- (void)doTask {
  id target = ((NSDictionary *)self.item)[XYHome_Router];
  NSNumber * index = ((NSDictionary *)self.item)[@"index"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([target respondsToSelector:@selector(doTask:)]) {
    [target performSelector:@selector(doTask:) withObject:index];
  }
#pragma clang diagnostic pop
}

- (void)setItem:(NSDictionary *)item {
  [super setItem:item];
  
  NSString *title = item[XYHome_Title];
  NSString *picURL = item[XYHome_PicURL];
  NSString *detail = item[XYHome_Detail];
  NSString *content = item[XYHome_Content];
  NSNumber *expand = item[@"expand"];
  NSNumber *expandHeight = item[@"expandHeight"];
  NSNumber *status = item[@"status"];
  
  NSString *actionText = status.integerValue == 0 ? @"领取" : (status.integerValue == 1 ? @"待完成" : @"已完成");
  [_actionBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
  self.titleLabel.text = title;
  self.contentLable.text = content;
  [self.iconView sd_setImageWithURL:[NSURL URLWithString:picURL]];
  [self.actionBtn setTitle:actionText forState:UIControlStateNormal];
  [self.actionBtn addTarget:self action:@selector(doTask) forControlEvents:UIControlEventTouchUpInside];
  
  NSMutableAttributedString *text = [NSMutableAttributedString new];
  
  UIFont *font = AdaptedRegularFont(XYFont_B);
  NSAttributedString *text_attr = [[NSAttributedString alloc] initWithString:detail attributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_FE2D63),NSFontAttributeName:font}];
  [text appendAttributedString:text_attr];
    
  UIImage *levelImage = expand.boolValue ? [UIImage imageNamed:@"arrow_8_red-1"] : [UIImage imageNamed:@"arrow_8_red"];
  NSMutableAttributedString *levelAttachment = [NSMutableAttributedString yy_attachmentStringWithContent:levelImage contentMode:UIViewContentModeCenter attachmentSize:levelImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
  [text appendAttributedString: levelAttachment];
  
  self.detailLable.attributedText = text;
  
  if (expand.boolValue) {
    [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(expandHeight.floatValue-32);
      make.right.equalTo(self.bgView).offset(-16);
      make.left.equalTo(self.bgView).offset(16);
      make.bottom.equalTo(self.bgView).offset(-16);
    }];
  } else {
    [self.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(0);
      make.right.equalTo(self.bgView).offset(-16);
      make.left.equalTo(self.bgView).offset(16);
      make.bottom.equalTo(self.bgView).offset(0);
    }];
  }
}

#pragma mark - getter

- (UIView *)bgView {
    if (!_bgView) {
      _bgView = [[UIView alloc] init];
      _bgView.backgroundColor = ColorHex(@"#FAFAFA");
      _bgView.layer.cornerRadius = 4;
      _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIView *)contentBgView {
    if (!_contentBgView) {
      _contentBgView = [[UIView alloc] init];
      _contentBgView.backgroundColor = ColorHex(XYThemeColor_B);
    }
    return _contentBgView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = ColorHex(XYTextColor_222222);
        _titleLabel.font = AdaptedMediumFont(XYFont_E);
    }
    return _titleLabel;
}

- (UILabel *)contentLable {
    if (!_contentLable) {
      _contentLable = [[UILabel alloc] init];
      _contentLable.textColor = ColorHex(XYTextColor_222222);
      _contentLable.font = AdaptedFont(12);
      _contentLable.numberOfLines = 0;
    }
    return _contentLable;
}

- (YYLabel *)detailLable {
    if (!_detailLable) {
        _detailLable = [[YYLabel alloc] init];
    }
    return _detailLable;
}

- (UIButton *)actionBtn {
  if (!_actionBtn) {
    _actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_actionBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
    [_actionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    _actionBtn.layer.cornerRadius = 14;
    _actionBtn.titleLabel.font = AdaptedMediumFont(XYFont_B);
  }
  return _actionBtn;
}
@end
