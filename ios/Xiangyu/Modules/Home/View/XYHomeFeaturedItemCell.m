//
//  XYHomeFeaturedItemCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/4.
//

#import "XYHomeFeaturedItemCell.h"

@interface XYHomeFeaturedItemCell ()

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UIImageView *recommendImageView;

@property(nonatomic,strong)UIView *bottomBGView;
@property(nonatomic,strong)UILabel *markLabel;



@property (strong, nonatomic) YYLabel *memberInfoLabel;

@property (strong, nonatomic) UIButton *attentionBtn;

@property (strong, nonatomic) UILabel *sloganLabel;

@property (strong, nonatomic) UILabel *hometownLabel;

@end

@implementation XYHomeFeaturedItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      self.contentView.layer.borderColor = ColorHex(XYThemeColor_E).CGColor;
      self.contentView.layer.borderWidth = 0.5;
      self.contentView.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
      self.contentView.layer.shadowOffset = CGSizeMake(0,1);
      self.contentView.layer.shadowOpacity = 0.06;
      self.contentView.layer.shadowRadius = 12;
      self.contentView.layer.cornerRadius = 12;
      
      self.bgView.layer.cornerRadius = 12;
      self.bgView.layer.masksToBounds = YES;
      [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
  
 
  [self.contentView addSubview:self.bgView];
  [self.bgView addSubview:self.recommendImageView];
  self.backgroundColor = ColorHex(XYTextColor_FFFFFF);
  self.contentView.backgroundColor = ColorHex(XYTextColor_FFFFFF);
  self.bgView.backgroundColor = ColorHex(XYTextColor_FFFFFF);
  
  self.bottomBGView = [LSHControl viewWithFrame:CGRectMake(0, 0, self.XY_width, AutoSize(68))];
 
  [self.recommendImageView addSubview:self.bottomBGView];
  [self.bottomBGView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.trailing.bottom.equalTo(self.recommendImageView);
    make.height.mas_equalTo(AutoSize(68));
  }];
  
  self.markLabel = [LSHControl createLabelFromFont:AdaptedFont(14) textColor:ColorHex(XYTextColor_FFFFFF) numberOfLines:2];
  
  [self.bottomBGView addSubview:self.markLabel];
  [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(AutoSize(8));
    make.center.equalTo(self.bottomBGView);
  }];
  
  [self.bgView addSubview:self.heartBeatBtn];
  [self.bgView addSubview:self.memberInfoLabel];
  [self.bgView addSubview:self.attentionBtn];
 // [self.bgView addSubview:self.sloganLabel];
  [self.bgView addSubview:self.hometownLabel];
  
  self.bgView.frame = self.contentView.bounds;
  
  self.recommendImageView.frame = CGRectMake(0, 0, self.XY_width, self.XY_width);
  self.bottomBGView.frame = CGRectMake(0, 0, self.XY_width, AutoSize(68));
  [self.bottomBGView setViewColors:@[(id)[UIColor clearColor].CGColor,(id)[[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor] withDirection:1];
  
  self.attentionBtn.frame = CGRectMake(self.XY_width-68, CGRectGetMaxY(self.recommendImageView.frame)+12, 56, 24);
    
  self.memberInfoLabel.frame = CGRectMake(12, CGRectGetMaxY(self.recommendImageView.frame)+12, self.XY_width-80, 24);
  
  self.hometownLabel.frame = CGRectMake(12, CGRectGetMaxY(self.memberInfoLabel.frame)+9, (self.XY_width-24), 17);
  
  [self.heartBeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.recommendImageView).offset(AutoSize(12));
    make.trailing.equalTo(self.recommendImageView).offset(AutoSize(-12));
    make.width.height.mas_equalTo(AutoSize(28));
  }];
  
 // self.hometownLabel.frame = CGRectMake(self.XY_width/2, CGRectGetMaxY(self.memberInfoLabel.frame)+9, (self.XY_width-24)/2, 17);
    
}

- (void)sendheartUser {
  id target = ((NSDictionary *)self.item)[XYHome_Router];
//  NSNumber *userId = ((NSDictionary *)self.item)[@"userId"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([target respondsToSelector:@selector(sendHeartWithObj:)]) {
    [target performSelector:@selector(sendHeartWithObj:) withObject:self.item];
  }
#pragma clang diagnostic pop
}

- (void)followUser {
  id target = ((NSDictionary *)self.item)[XYHome_Router];
  NSNumber *userId = ((NSDictionary *)self.item)[@"userId"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([target respondsToSelector:@selector(followUserWithId:)]) {
    [target performSelector:@selector(followUserWithId:) withObject:userId];
  }
#pragma clang diagnostic pop
}

- (void)setItem:(NSDictionary *)item {
  [super setItem:item];
  NSString *picURL = item[XYHome_PicURL];
  NSString *nickname = item[XYHome_Nickname];
  NSString *levelImg = item[XYHome_LevelImg];
  NSString *genderImg = item[XYHome_GenderImg];
  NSString *slogan = item[XYHome_Slogan];
  NSString *hometown = item[XYHome_Hometown];
  NSString *attentionStatus = item[XYHome_AttentionStatus];
  
  [self.recommendImageView sd_setImageWithURL:[NSURL URLWithString:picURL]];
  self.markLabel.text = [slogan isEqual:[NSNull null]] ? @"" : slogan;
  self.hometownLabel.text = hometown;
  if (![attentionStatus isEqualToString:@"0"]) {
    self.attentionBtn.enabled = NO;
    [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
    [self.attentionBtn setBackgroundColor:ColorHex(XYThemeColor_I)];
    [self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    [self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
  } else {
    self.attentionBtn.enabled = YES;
    [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    [self.attentionBtn setBackgroundColor:ColorHex(XYThemeColor_A)];
    [self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    [self.attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
  }
  [self.attentionBtn addTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
  
  NSMutableAttributedString *text = [NSMutableAttributedString new];
  
  UIFont *font = AdaptedMediumFont(16);
  NSAttributedString *text_attr = [[NSAttributedString alloc] initWithString:nickname attributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_222222),NSFontAttributeName:font}];
  [text appendAttributedString:text_attr];
    
  UIImage *levelImage = [UIImage imageNamed:levelImg];
  NSMutableAttributedString *levelAttachment = [NSMutableAttributedString yy_attachmentStringWithContent:levelImage contentMode:UIViewContentModeCenter attachmentSize:levelImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
  [text appendAttributedString: levelAttachment];
  
  UIImage *genderImage = [UIImage imageNamed:genderImg];
  NSMutableAttributedString *genderAttachment = [NSMutableAttributedString yy_attachmentStringWithContent:genderImage contentMode:UIViewContentModeCenter attachmentSize:genderImage.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
  [text appendAttributedString: genderAttachment];
  
  self.memberInfoLabel.attributedText = text;
  
  [self.heartBeatBtn startAnimation];
  
 // [self.heartBeatBtn.animation play];
}

#pragma mark - getter
- (UIView *)bgView {
    if (!_bgView) {
      _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

- (UIImageView *)recommendImageView {
    if (!_recommendImageView) {
        _recommendImageView = [[UIImageView alloc] init];
      _recommendImageView.contentMode = UIViewContentModeScaleAspectFill;
      _recommendImageView.clipsToBounds = YES;
    }
    return _recommendImageView;
}

- (YYLabel *)memberInfoLabel {
    if (!_memberInfoLabel) {
        _memberInfoLabel = [[YYLabel alloc] init];
    }
    return _memberInfoLabel;
}

- (UILabel *)sloganLabel {
    if (!_sloganLabel) {
        _sloganLabel = [[UILabel alloc] init];
        _sloganLabel.textColor = ColorHex(XYTextColor_666666);
        _sloganLabel.font = AdaptedFont(XYFont_B);
      _sloganLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _sloganLabel;
}

- (UILabel *)hometownLabel {
    if (!_hometownLabel) {
        _hometownLabel = [[UILabel alloc] init];
        _hometownLabel.textColor = ColorHex(XYTextColor_666666);
        _hometownLabel.font = AdaptedFont(XYFont_B);
      //_hometownLabel.textAlignment = NSTextAlignmentRight;
    }
    return _hometownLabel;
}

- (UIButton *)attentionBtn {
  if (!_attentionBtn) {
    _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_attentionBtn setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    _attentionBtn.layer.cornerRadius = 12;
    _attentionBtn.titleLabel.font = AdaptedMediumFont(XYFont_B);
  }
  return _attentionBtn;
}
-(XYHeartBeatView *)heartBeatBtn{
  if (!_heartBeatBtn) {
//    _heartBeatBtn = [LSHControl createButtonWithFrame:CGRectZero buttonImage:@"iocn_28_xindongjt"];
    _heartBeatBtn = [[XYHeartBeatView alloc]initWithFrame:CGRectMake(0, 0, AutoSize(24), AutoSize(24)) fileName:@"hp_xindong"];
    [_heartBeatBtn.animation setLoopAnimation:NO];
//    [_heartBeatBtn.animation playWithCompletion:^(BOOL animationFinished) {
//    }];
    [_heartBeatBtn addTarget:self action:@selector(sendheartUser) forControlEvents:UIControlEventTouchUpInside];
  }
  return _heartBeatBtn;
}

@end
