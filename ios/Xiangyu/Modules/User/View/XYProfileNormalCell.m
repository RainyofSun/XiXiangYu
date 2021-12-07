//
//  XYProfileNormalCell.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/6/3.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYProfileNormalCell.h"
#import "XYProfileSectionItem.h"

@interface XYProfileNormalCell ()

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *subLable;

@property (strong, nonatomic) UIImageView *arrowView;

@end

@implementation XYProfileNormalCell

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
    [self.bgView addSubview:self.subLable];
    [self.bgView addSubview:self.arrowView];
    [self.bgView addSubview:self.lineView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.top.bottom.equalTo(self.contentView);
    }];
  
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(16);
        make.centerY.equalTo(self);
    }];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-16);
        make.centerY.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(11);
        make.centerY.equalTo(self);
    }];
    
    [self.subLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowView.mas_left).offset(-15);
        make.left.greaterThanOrEqualTo(self.titleLabel.mas_right).offset(15);
        make.centerY.equalTo(self);
    }];
  
  [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.bgView).offset(16);
      make.right.equalTo(self.bgView).offset(-16);
      make.height.equalTo(@(1));
      make.bottom.equalTo(self.bgView);
  }];
    
}

- (void)setObject:(XYProfileItem *)object {
    [super setObject:object];
    self.iconView.image = [UIImage imageNamed:object.picURL];
    self.titleLabel.text = object.title;
    self.subLable.text = object.status;
  if (object.withCordis.integerValue == 1 || object.withCordis.integerValue == 2) {
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kScreenWidth-32, 52) byRoundingCorners:object.withCordis.integerValue == 1 ? (UIRectCornerTopLeft|UIRectCornerTopRight) : (UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = CGRectMake(0, 0, kScreenWidth-32, 52);
    layer.path = path.CGPath;
    self.bgView.layer.mask = layer;
  } else {
    self.bgView.layer.mask = nil;
  }
  self.lineView.hidden = !object.withLine.boolValue;
}

#pragma mark - getter

- (UIView *)bgView {
    if (!_bgView) {
      _bgView = [[UIView alloc] init];
      _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)lineView {
    if (!_lineView) {
      _lineView = [[UIView alloc] init];
      _lineView.backgroundColor = ColorHex(@"#E6E6E6");
      _lineView.hidden = YES;
    }
    return _lineView;
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

- (UILabel *)subLable {
    if (!_subLable) {
        _subLable = [[UILabel alloc] init];
        _subLable.backgroundColor = ColorHex(XYThemeColor_B);
        _subLable.textColor = ColorHex(XYTextColor_CCCCCC);
        _subLable.font = AdaptedFont(XYFont_D);
    }
    return _subLable;
}
@end
