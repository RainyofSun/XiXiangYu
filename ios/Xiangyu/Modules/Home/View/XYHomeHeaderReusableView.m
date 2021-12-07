//
//  XYHomeHeaderReusableView.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/31.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYHomeHeaderReusableView.h"

@interface XYHomeHeaderReusableView ()

@property (nonatomic,strong) UIImageView * iconView;

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel * messageLable;

@property (nonatomic,weak) UITapGestureRecognizer *tap;

@end

@implementation XYHomeHeaderReusableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorHex(XYThemeColor_F);
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    [self addSubview:self.iconView];
    [self addSubview:self.titleLable];
    [self addSubview:self.messageLable];


    [self.titleLable makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.left.equalTo(self).offset(16);
    }];

    [self.iconView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.centerY.equalTo(self.titleLable);
    }];
    
    [self.messageLable makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.iconView.mas_left);
        make.centerY.equalTo(self.iconView);
    }];
    
}
- (void)headertipsClick {
  if (self.tipsClickBlock && self.router.isNotBlank) {
    self.tipsClickBlock(self.router);
  }
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
  if (imageName.isNotBlank) {
    _iconView.image = [UIImage imageNamed:imageName];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headertipsClick)];
    [_iconView addGestureRecognizer:tap];
    self.tap = tap;
  } else {
    [_iconView removeGestureRecognizer:self.tap];
  }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLable.text = title;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    _messageLable.text = message;
  if (message.isNotBlank) {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headertipsClick)];
    [_messageLable addGestureRecognizer:tap];
    self.tap = tap;
  } else {
    [_messageLable removeGestureRecognizer:self.tap];
  }
}

#pragma mark - getter

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
      _iconView.userInteractionEnabled = YES;
    }
    return _iconView;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = ColorHex(XYTextColor_222222);
        _titleLable.font = AdaptedMediumFont(XYFont_G);
    }
    return _titleLable;
}

- (UILabel *)messageLable {
    if (!_messageLable) {
        _messageLable = [[UILabel alloc] init];
        _messageLable.userInteractionEnabled = YES;
        _messageLable.textColor = ColorHex(XYTextColor_999999);
        _messageLable.font = AdaptedFont(XYFont_B);
    }
    return _messageLable;
}

@end
