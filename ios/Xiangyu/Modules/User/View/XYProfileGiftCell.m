//
//  XYProfileGiftCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2020/12/29.
//

#import "XYProfileGiftCell.h"
#import "XYProfileSectionItem.h"
#import "UIButton+Extension.h"

@interface XYProfileGiftCell ()

@property (strong, nonatomic) UIView *goldBgView;

@property (strong, nonatomic) UIButton *goldTitleView;

@property (strong, nonatomic) UILabel *goldValueLable;

@property (strong, nonatomic) UIButton *goldArrowBtn;

@property (strong, nonatomic) UIView *giftBgView;

@property (strong, nonatomic) UIButton *giftTitleView;

@property (strong, nonatomic) UILabel *giftValueLable;

@end

@implementation XYProfileGiftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.contentView.backgroundColor = ColorHex(XYThemeColor_F);
      self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
  [self.contentView addSubview:self.goldBgView];
  [self.goldBgView addSubview:self.goldTitleView];
  [self.goldBgView addSubview:self.goldValueLable];
  [self.goldBgView addSubview:self.goldArrowBtn];
  
  [self.contentView addSubview:self.giftBgView];
  [self.giftBgView addSubview:self.giftTitleView];
  [self.giftBgView addSubview:self.giftValueLable];
    
    [self.goldBgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.contentView).offset(16);
      make.right.equalTo(self.contentView.mas_centerX).offset(-4);
      make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.goldTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goldBgView).offset(12);
        make.left.equalTo(self.goldBgView).offset(12);
    }];
    
    [self.goldValueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goldBgView).offset(-16);
      make.left.equalTo(self.goldBgView).offset(36);
    }];
    
    [self.goldArrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self.goldValueLable);
      make.right.equalTo(self.goldBgView).offset(-6);
    }];
  
    [self.giftBgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.contentView).offset(-16);
      make.left.equalTo(self.contentView.mas_centerX).offset(4);
      make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.giftTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.giftBgView).offset(12);
        make.left.equalTo(self.giftBgView).offset(12);
    }];
    
    [self.giftValueLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.giftBgView).offset(-16);
      make.left.equalTo(self.giftBgView).offset(36);
    }];
    
  [self.goldTitleView horizontalCenterImageAndTitle:4];
  [self.goldArrowBtn horizontalCenterTitleAndImage:0];
  [self.giftTitleView horizontalCenterImageAndTitle:4];
  
}

- (void)setObject:(XYProfileItem *)object {
    [super setObject:object];
    NSDictionary *info = object.info;
  if (info) {
    NSNumber *balance = info[@"balance"];
    NSNumber *goldBalance = info[@"goldBalance"];
    self.goldValueLable.text = goldBalance.stringValue;
    NSString *giftString = [NSString stringWithFormat:@"%@元", balance.stringValue];
    NSMutableAttributedString *attr_s = [[NSMutableAttributedString alloc] initWithString:giftString];
    [attr_s addAttributes:@{NSFontAttributeName:AdaptedMediumFont(24)} range:NSMakeRange(0, balance.stringValue.length)];
    [attr_s addAttributes:@{NSFontAttributeName:AdaptedMediumFont(12)} range:NSMakeRange(giftString.length-1, 1)];
    self.giftValueLable.attributedText = attr_s;
  }
}

- (void)storeAction {
  if (self.object.target && [self.object.target respondsToSelector:@selector(storeAction)]) {
    [self.object.target performSelector:@selector(storeAction)];
  }
}

- (void)giftAction {
  if (self.object.target && [self.object.target respondsToSelector:@selector(giftAction)]) {
    [self.object.target performSelector:@selector(giftAction)];
  }
}
-(void)blanceAction{
  if (self.object.target && [self.object.target respondsToSelector:@selector(blanceAction)]) {
    [self.object.target performSelector:@selector(blanceAction)];
  }
}
- (void)xiangbiAction {
  if (self.object.target && [self.object.target respondsToSelector:@selector(xiangbiAction)]) {
    [self.object.target performSelector:@selector(xiangbiAction)];
  }
}

#pragma mark - getter

- (UIView *)goldBgView {
    if (!_goldBgView) {
      _goldBgView = [[UIView alloc] init];
      _goldBgView.layer.cornerRadius = 12;
      _goldBgView.backgroundColor = ColorHex(XYThemeColor_B);
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xiangbiAction)];
      [_goldBgView addGestureRecognizer:tap];
    }
    return _goldBgView;
}

- (UIButton *)goldTitleView {
    if (!_goldTitleView) {
        _goldTitleView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goldTitleView setTitle:@"乡币" forState:UIControlStateNormal];
        [_goldTitleView setImage:[UIImage imageNamed:@"xianbi_20"] forState:UIControlStateNormal];
        [_goldTitleView setTitleColor:ColorHex(XYTextColor_222222) forState:UIControlStateNormal];
        _goldTitleView.titleLabel.font = AdaptedFont(XYFont_D);
      [_goldTitleView addTarget:self action:@selector(xiangbiAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goldTitleView;
}

- (UILabel *)goldValueLable {
    if (!_goldValueLable) {
        _goldValueLable = [[UILabel alloc] init];
        _goldValueLable.textColor = ColorHex(XYTextColor_FEA619);
        _goldValueLable.font = AdaptedMediumFont(XYFont_I);
      _goldValueLable.text = @"--";
    }
    return _goldValueLable;
}

- (UIButton *)goldArrowBtn {
    if (!_goldArrowBtn) {
        _goldArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goldArrowBtn setTitle:@"去兑换" forState:UIControlStateNormal];
        [_goldArrowBtn setImage:[UIImage imageNamed:@"ic_arrow_gray"] forState:UIControlStateNormal];
        [_goldArrowBtn setTitleColor:ColorHex(XYTextColor_999999) forState:UIControlStateNormal];
        _goldArrowBtn.titleLabel.font = AdaptedFont(XYFont_B);
      [_goldArrowBtn addTarget:self action:@selector(storeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goldArrowBtn;
}

- (UIView *)giftBgView {
    if (!_giftBgView) {
      _giftBgView = [[UIView alloc] init];
      _giftBgView.layer.cornerRadius = 12;
      _giftBgView.backgroundColor = ColorHex(XYThemeColor_B);
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blanceAction)];
      [_giftBgView addGestureRecognizer:tap];
    }
    return _giftBgView;
}

- (UIButton *)giftTitleView {
    if (!_giftTitleView) {
        _giftTitleView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_giftTitleView setTitle:@"钱包" forState:UIControlStateNormal];
        [_giftTitleView setImage:[UIImage imageNamed:@"iocn_20_qianbao"] forState:UIControlStateNormal];
        [_giftTitleView setTitleColor:ColorHex(XYTextColor_222222) forState:UIControlStateNormal];
        _giftTitleView.titleLabel.font = AdaptedFont(XYFont_D);
      [_giftTitleView addTarget:self action:@selector(blanceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giftTitleView;
}

- (UILabel *)giftValueLable {
    if (!_giftValueLable) {
        _giftValueLable = [[UILabel alloc] init];
        _giftValueLable.textColor = ColorHex(XYTextColor_FE2D63);
        _giftValueLable.font = AdaptedMediumFont(XYFont_I);
      _giftValueLable.text = @"--";
    }
    return _giftValueLable;
}
@end
