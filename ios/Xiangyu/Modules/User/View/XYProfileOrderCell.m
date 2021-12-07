//
//  XYProfileOrderCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2020/12/29.
//

#import "XYProfileOrderCell.h"
#import "XYProfileSectionItem.h"
#import "UIButton+Extension.h"

@interface XYProfileOrderCell ()

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIButton *waitdeliverBtn;

@property (strong, nonatomic) UIButton *waitreceivingBtn;

@property (strong, nonatomic) UIButton *completedBtn;

@end

@implementation XYProfileOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      self.contentView.backgroundColor = ColorHex(XYThemeColor_F);
        [self setupSubViews];
    }
    return self;
}

#pragma mark - action
- (void)waitDeliverAction {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([self.object.target respondsToSelector:@selector(waitDeliverAction)]) {
    [self.object.target performSelector:@selector(waitDeliverAction)];
  }
#pragma clang diagnostic pop
}

- (void)waitReceivingAction {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([self.object.target respondsToSelector:@selector(waitReceivingAction)]) {
    [self.object.target performSelector:@selector(waitReceivingAction)];
  }
#pragma clang diagnostic pop
}

- (void)completedAction {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([self.object.target respondsToSelector:@selector(completedAction)]) {
    [self.object.target performSelector:@selector(completedAction)];
  }
#pragma clang diagnostic pop
}

- (void)setupSubViews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.waitdeliverBtn];
    [self.bgView addSubview:self.waitreceivingBtn];
    [self.bgView addSubview:self.completedBtn];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.contentView).offset(16);
      make.right.equalTo(self.contentView).offset(-16);
      make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(12);
        make.left.equalTo(self.bgView).offset(12);
    }];
    
    [self.waitdeliverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.titleLabel.mas_bottom).offset(26);
      make.left.equalTo(self.bgView).offset(35);
    }];
    
    [self.waitreceivingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.waitdeliverBtn);
      make.centerX.equalTo(self.bgView);
    }];
  
    [self.completedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self.waitdeliverBtn);
      make.right.equalTo(self.bgView).offset(-35);
    }];
 
  [self.waitdeliverBtn verticalCenterImageAndTitle];
  [self.waitreceivingBtn verticalCenterImageAndTitle];
  [self.completedBtn verticalCenterImageAndTitle];
}

- (void)setObject:(XYProfileItem *)object {
    [super setObject:object];
    
}

#pragma mark - getter

- (UIView *)bgView {
    if (!_bgView) {
      _bgView = [[UIView alloc] init];
      _bgView.layer.cornerRadius = 12;
      _bgView.backgroundColor = ColorHex(XYThemeColor_B);
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = ColorHex(XYTextColor_222222);
        _titleLabel.font = AdaptedMediumFont(XYFont_E);
      _titleLabel.text = @"我的订单";
    }
    return _titleLabel;
}

- (UIButton *)waitdeliverBtn {
    if (!_waitdeliverBtn) {
        _waitdeliverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_waitdeliverBtn setTitle:@"待发货" forState:UIControlStateNormal];
        [_waitdeliverBtn setImage:[UIImage imageNamed:@"icon_26_daifahuo"] forState:UIControlStateNormal];
        [_waitdeliverBtn setTitleColor:ColorHex(XYTextColor_222222) forState:UIControlStateNormal];
        _waitdeliverBtn.titleLabel.font = AdaptedFont(XYFont_D);
      [_waitdeliverBtn addTarget:self action:@selector(waitDeliverAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _waitdeliverBtn;
}

- (UIButton *)waitreceivingBtn {
    if (!_waitreceivingBtn) {
        _waitreceivingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_waitreceivingBtn setTitle:@"待收货" forState:UIControlStateNormal];
        [_waitreceivingBtn setImage:[UIImage imageNamed:@"icon_26_daishouhuo"] forState:UIControlStateNormal];
        [_waitreceivingBtn setTitleColor:ColorHex(XYTextColor_222222) forState:UIControlStateNormal];
        _waitreceivingBtn.titleLabel.font = AdaptedFont(XYFont_D);
      [_waitreceivingBtn addTarget:self action:@selector(waitReceivingAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _waitreceivingBtn;
}

- (UIButton *)completedBtn {
    if (!_completedBtn) {
        _completedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completedBtn setTitle:@"已完成" forState:UIControlStateNormal];
        [_completedBtn setImage:[UIImage imageNamed:@"icon_26_yiwangcheng"] forState:UIControlStateNormal];
        [_completedBtn setTitleColor:ColorHex(XYTextColor_222222) forState:UIControlStateNormal];
        _completedBtn.titleLabel.font = AdaptedFont(XYFont_D);
      [_completedBtn addTarget:self action:@selector(completedAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completedBtn;
}
@end
