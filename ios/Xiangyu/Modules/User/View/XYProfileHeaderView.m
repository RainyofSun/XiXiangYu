//
//  XYProfileHeaderView.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/6/3.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYProfileHeaderView.h"
#import "XYProfileItemView.h"
#import "XYProfileSectionItem.h"
#import "UIButton+Extension.h"

@interface XYProfileHeaderView ()

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UIButton *homePageButton;

@property (strong, nonatomic) UIImageView * certificateStatusVew;

@property (strong, nonatomic) UILabel *identityLable;

@property (nonatomic,strong) XYProfileItemView *heartView;

@property (nonatomic,strong) XYProfileItemView *giftView;

@property (nonatomic,strong) XYProfileItemView *attentionView;

@property (nonatomic,strong) XYProfileItemView *fansView;

@property (nonatomic,strong) XYProfileItemView *likeView;

@property (strong, nonatomic) UIImageView *cycleStyleView;

@property (strong, nonatomic) UIView *itemBgView;

@property (nonatomic,strong) UIButton *certificationBtn;

@property (nonatomic,strong) UIButton *shortVideoBtn;

@property (nonatomic,strong) UIButton *MyFeedBtn;

//@property (strong, nonatomic) UIView *lineView1;
//@property (strong, nonatomic) UIView *lineView2;
//@property (strong, nonatomic) UIView *lineView3;

@end

@implementation XYProfileHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ColorHex(XYThemeColor_F);
        [self setupSubViews];
    }
    return self;
}

#pragma mark - action

- (void)checkGift{
  XYProfileHeaderFooterObject *info = self.info;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([info.target respondsToSelector:@selector(checkGift)]) {
    [info.target performSelector:@selector(checkGift)];
  }
#pragma clang diagnostic pop
}
- (void)checkHeart {
  XYProfileHeaderFooterObject *info = self.info;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([info.target respondsToSelector:@selector(checkHeart)]) {
    [info.target performSelector:@selector(checkHeart)];
  }
#pragma clang diagnostic pop
}

- (void)checkFriends {
  XYProfileHeaderFooterObject *info = self.info;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([info.target respondsToSelector:@selector(checkFriends)]) {
    [info.target performSelector:@selector(checkFriends)];
  }
#pragma clang diagnostic pop
}

- (void)checkAttention {
  XYProfileHeaderFooterObject *info = self.info;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([info.target respondsToSelector:@selector(checkAttention)]) {
    [info.target performSelector:@selector(checkAttention)];
  }
#pragma clang diagnostic pop
}

- (void)checkFans {
  XYProfileHeaderFooterObject *info = self.info;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([info.target respondsToSelector:@selector(checkFans)]) {
    [info.target performSelector:@selector(checkFans)];
  }
#pragma clang diagnostic pop
}

- (void)checkLikes {
  XYProfileHeaderFooterObject *info = self.info;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([info.target respondsToSelector:@selector(checkLikes)]) {
    [info.target performSelector:@selector(checkLikes)];
  }
#pragma clang diagnostic pop
}

- (void)profile {
  XYProfileHeaderFooterObject *info = self.info;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([info.target respondsToSelector:@selector(checkProfile)]) {
    [info.target performSelector:@selector(checkProfile)];
  }
#pragma clang diagnostic pop
}

- (void)certification {
  XYProfileHeaderFooterObject *info = self.info;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([info.target respondsToSelector:@selector(certification)]) {
    [info.target performSelector:@selector(certification)];
  }
#pragma clang diagnostic pop
}

- (void)shortVideo {
  XYProfileHeaderFooterObject *info = self.info;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([info.target respondsToSelector:@selector(shortVideo)]) {
    [info.target performSelector:@selector(shortVideo)];
  }
#pragma clang diagnostic pop
}

- (void)myTidings {
  XYProfileHeaderFooterObject *info = self.info;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([info.target respondsToSelector:@selector(myTidings)]) {
    [info.target performSelector:@selector(myTidings)];
  }
#pragma clang diagnostic pop
}
- (void)setupSubViews {

    [self addSubview:self.contentView];
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.homePageButton];
    [self.contentView addSubview:self.certificateStatusVew];
    [self.contentView addSubview:self.identityLable];
    [self.contentView addSubview:self.giftView];
  [self.contentView addSubview:self.heartView];
//    [self.contentView addSubview:self.lineView1];
    [self.contentView addSubview:self.attentionView];
//  [self.contentView addSubview:self.lineView2];
    [self.contentView addSubview:self.fansView];
//  [self.contentView addSubview:self.lineView3];
    [self.contentView addSubview:self.likeView];
    [self.contentView addSubview:self.cycleStyleView];
    [self.contentView addSubview:self.itemBgView];
    [self.itemBgView addSubview:self.certificationBtn];
    [self.itemBgView addSubview:self.shortVideoBtn];
    [self.itemBgView addSubview:self.MyFeedBtn];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self).offset(-42);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(24);
        make.top.equalTo(self.contentView).offset(68);
        make.width.height.equalTo(@60);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(11);
        make.top.equalTo(self.iconView).offset(8);
    }];

    [self.homePageButton mas_makeConstraints:^(MASConstraintMaker *make) {
      make.right.equalTo(self.contentView).offset(-16);
      make.centerY.equalTo(self.iconView);
      make.width.equalTo(@84);
    }];

    [self.certificateStatusVew mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.nameLabel.mas_right).offset(8);
      make.centerY.equalTo(self.nameLabel);
    }];

    [self.identityLable mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.nameLabel);
      make.bottom.equalTo(self.iconView).offset(-7);
    }];
  
    [self.heartView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.contentView);
      make.top.equalTo(self.iconView.mas_bottom).offset(31);
      make.width.equalTo(@((kScreenWidth-2)/5));
      make.height.equalTo(@44);
    }];
  
  [self.giftView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.heartView.mas_right).offset(.5);
    make.top.equalTo(self.iconView.mas_bottom).offset(31);
    make.width.equalTo(@((kScreenWidth-2)/5));
    make.height.equalTo(@44);
  }];
  
//
//    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.left.equalTo(self.friendsView.mas_right);
//      make.centerY.equalTo(self.friendsView);
//      make.width.equalTo(@(0.5));
//      make.height.equalTo(@24);
//    }];

    [self.attentionView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.giftView.mas_right).offset(.5);
      make.top.equalTo(self.iconView.mas_bottom).offset(31);
      make.width.equalTo(@((kScreenWidth-2)/5));
      make.height.equalTo(@44);
    }];

//    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.left.equalTo(self.attentionView.mas_right);
//      make.centerY.equalTo(self.friendsView);
//      make.width.equalTo(@(0.5));
//      make.height.equalTo(@24);
//    }];
  
    [self.fansView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.attentionView.mas_right).offset(.5);
      //make.left.equalTo(self.lineView2.mas_right);
      make.top.equalTo(self.iconView.mas_bottom).offset(31);
      make.width.equalTo(@((kScreenWidth-2)/5));
      make.height.equalTo(@44);
    }];
  
//    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.left.equalTo(self.fansView.mas_right);
//      make.centerY.equalTo(self.friendsView);
//      make.width.equalTo(@(0.5));
//      make.height.equalTo(@24);
//    }];
  
    [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.fansView.mas_right).offset(.5);
      //make.left.equalTo(self.lineView3.mas_right);
      make.top.equalTo(self.iconView.mas_bottom).offset(31);
      make.width.equalTo(@((kScreenWidth-2)/5));
      make.height.equalTo(@44);
    }];
  
  [self.cycleStyleView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.bottom.right.equalTo(self.contentView);
    make.height.equalTo(@16);
  }];

    [self.itemBgView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.contentView).offset(16);
      make.right.equalTo(self.contentView).offset(-16);
      make.top.equalTo(self.fansView.mas_bottom).offset(24);
      make.height.equalTo(@86);
    }];

  CGFloat btnWidth = (kScreenWidth - 32)/3;
  [self.certificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.itemBgView);
    make.bottom.equalTo(self.itemBgView).offset(-10);
    make.top.equalTo(self.itemBgView).offset(10);
    make.width.mas_equalTo(btnWidth);
  }];

  [self.shortVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.certificationBtn.mas_right);
    make.bottom.equalTo(self.itemBgView).offset(-10);
    make.top.equalTo(self.itemBgView).offset(10);
    make.width.mas_equalTo(btnWidth);
  }];

  [self.MyFeedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self.itemBgView);
    make.bottom.equalTo(self.itemBgView).offset(-10);
    make.top.equalTo(self.itemBgView).offset(10);
    make.width.mas_equalTo(btnWidth);
  }];

  [self.homePageButton horizontalCenterTitleAndImage:5];
  [self.certificationBtn verticalCenterImageAndTitle];
  [self.shortVideoBtn verticalCenterImageAndTitle];
  [self.MyFeedBtn verticalCenterImageAndTitle];
  
  [self setLockWithStatus:YES];
}


- (void)setInfo:(XYProfileHeaderFooterObject *)info {
    [super setInfo:info];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:info.picURL] placeholderImage:[UIImage imageNamed:@"default_avatar"]];
    self.nameLabel.text = info.name;
    self.identityLable.text = info.identity;
    self.heartView.titleLabel.text = info.heart;
    self.heartView.statusLable.text = info.heartCount;
  self.certificateStatusVew.image = [UIImage imageNamed:[info.status integerValue]==2?@"icon_14_renzheng":@"icon_14_weirenzheng"];
  
  self.giftView.titleLabel.text = info.gift;
  self.giftView.statusLable.text = info.giftCount;
  
    self.attentionView.titleLabel.text = info.attention;
    self.attentionView.statusLable.text = info.attentionCount;
    self.fansView.titleLabel.text = info.fans;
    self.fansView.statusLable.text = info.fansCount;
    self.likeView.titleLabel.text = info.like;
    self.likeView.statusLable.text = info.likeCount;
  
  [self setLockWithStatus:[info.lock boolValue]];
}
#pragma mark - getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = ColorHex(XYThemeColor_A);
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profile)];
      [_contentView addGestureRecognizer:tap];
    }
    return _contentView;
}

//- (UIView *)lineView1 {
//    if (!_lineView1) {
//      _lineView1 = [[UIView alloc] init];
//      _lineView1.backgroundColor = ColorHex(XYThemeColor_B);
//    }
//    return _lineView1;
//}
//- (UIView *)lineView2 {
//    if (!_lineView2) {
//      _lineView2 = [[UIView alloc] init];
//      _lineView2.backgroundColor = ColorHex(XYThemeColor_B);
//    }
//    return _lineView2;
//}
//- (UIView *)lineView3 {
//    if (!_lineView3) {
//      _lineView3 = [[UIView alloc] init];
//      _lineView3.backgroundColor = ColorHex(XYThemeColor_B);
//    }
//    return _lineView3;
//}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
      //_iconView.userInteractionEnabled = YES;
      _iconView.contentMode = UIViewContentModeScaleAspectFill;
      
      _iconView.layer.cornerRadius = 30;
      _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = ColorHex(XYTextColor_FFFFFF);
        _nameLabel.font = AdaptedFont(XYFont_F);
    }
    return _nameLabel;
}

- (UIButton *)homePageButton {
    if (!_homePageButton) {
        _homePageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_homePageButton setTitle:@"个人资料" forState:UIControlStateNormal];
        [_homePageButton setImage:[UIImage imageNamed:@"ic_arrow_gray"] forState:UIControlStateNormal];
        [_homePageButton setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
        _homePageButton.titleLabel.font = AdaptedFont(XYFont_B);
      [_homePageButton setBackgroundColor:UIColorAlpha(XYThemeColor_D, XYColorAlpha_10)];
      _homePageButton.layer.cornerRadius = 6;
      
      [_homePageButton addTarget:self action:@selector(profile) forControlEvents:UIControlEventTouchUpInside];
      
    }
    return _homePageButton;
}

- (UIImageView *)certificateStatusVew {
    if (!_certificateStatusVew) {
        _certificateStatusVew = [[UIImageView alloc] init];
      _certificateStatusVew.image = [UIImage imageNamed:@"icon_14_renzheng"];
    }
    return _certificateStatusVew;
}

- (UIImageView *)cycleStyleView {
    if (!_cycleStyleView) {
        _cycleStyleView = [[UIImageView alloc] init];
        _cycleStyleView.image = [UIImage imageNamed:@"bg_16_hui"];
    }
    return _cycleStyleView;
}

- (UILabel *)identityLable {
    if (!_identityLable) {
        _identityLable = [[UILabel alloc] init];
        _identityLable.textColor = UIColorAlpha(XYTextColor_FFFFFF, XYColorAlpha_80);
        _identityLable.font = AdaptedFont(XYFont_B);
    }
    return _identityLable;
}

- (XYProfileItemView *)giftView {
    if (!_giftView) {
      _giftView = [[XYProfileItemView alloc] init];
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkGift)];
      [_giftView addGestureRecognizer:tap];
    }
    return _giftView;
}

- (XYProfileItemView *)heartView {
    if (!_heartView) {
      _heartView = [[XYProfileItemView alloc] init];
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkHeart)];
    [_heartView addGestureRecognizer:tap];
    }
    return _heartView;
}

- (XYProfileItemView *)attentionView {
    if (!_attentionView) {
        _attentionView = [[XYProfileItemView alloc] init];
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkAttention)];
      [_attentionView addGestureRecognizer:tap];
    }
    return _attentionView;
}

- (XYProfileItemView *)fansView {
    if (!_fansView) {
        _fansView = [[XYProfileItemView alloc] init];
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkFans)];
      [_fansView addGestureRecognizer:tap];
    }
    return _fansView;
}

- (XYProfileItemView *)likeView {
    if (!_likeView) {
        _likeView = [[XYProfileItemView alloc] init];
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkLikes)];
      [_likeView addGestureRecognizer:tap];
    }
    return _likeView;
}

- (UIView *)itemBgView {
    if (!_itemBgView) {
        _itemBgView = [[UIView alloc] init];
        _itemBgView.backgroundColor = ColorHex(XYThemeColor_B);
      _itemBgView.layer.cornerRadius = 12;
    }
    return _itemBgView;
}

- (UIButton *)certificationBtn {
    if (!_certificationBtn) {
        _certificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_certificationBtn setTitle:@"未实名认证" forState:UIControlStateNormal];
        [_certificationBtn setImage:[UIImage imageNamed:@"icon_32_renzheng"] forState:UIControlStateNormal];
        [_certificationBtn setTitleColor:ColorHex(XYTextColor_222222) forState:UIControlStateNormal];
        _certificationBtn.titleLabel.font = AdaptedFont(XYFont_D);
      [_certificationBtn addTarget:self action:@selector(certification) forControlEvents:UIControlEventTouchUpInside];
    }
    return _certificationBtn;
}

- (UIButton *)shortVideoBtn {
    if (!_shortVideoBtn) {
        _shortVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shortVideoBtn setTitle:@"我的短视频" forState:UIControlStateNormal];
        [_shortVideoBtn setImage:[UIImage imageNamed:@"icon_32_shiping"] forState:UIControlStateNormal];
        [_shortVideoBtn setTitleColor:ColorHex(XYTextColor_222222) forState:UIControlStateNormal];
        _shortVideoBtn.titleLabel.font = AdaptedFont(XYFont_D);
      [_shortVideoBtn addTarget:self action:@selector(shortVideo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shortVideoBtn;
}

- (UIButton *)MyFeedBtn {
    if (!_MyFeedBtn) {
        _MyFeedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_MyFeedBtn setTitle:@"我的动态" forState:UIControlStateNormal];
        [_MyFeedBtn setImage:[UIImage imageNamed:@"icon_32_dotai"] forState:UIControlStateNormal];
        [_MyFeedBtn setTitleColor:ColorHex(XYTextColor_222222) forState:UIControlStateNormal];
        _MyFeedBtn.titleLabel.font = AdaptedFont(XYFont_D);
      [_MyFeedBtn addTarget:self action:@selector(myTidings) forControlEvents:UIControlEventTouchUpInside];
    }
    return _MyFeedBtn;
}
-(void)setLockWithStatus:(BOOL)status{
  
  // 后台控制开关 上架与否
  if (status) {
    self.heartView.hidden = YES;
    self.giftView.hidden = YES;
    [self.heartView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.contentView);
      make.top.equalTo(self.iconView.mas_bottom).offset(31);
      make.width.equalTo(@((kScreenWidth-2)/5));
      make.height.equalTo(@44);
    }];

  [self.giftView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.heartView.mas_right).offset(.5);
    make.top.equalTo(self.iconView.mas_bottom).offset(31);
    make.width.equalTo(@((kScreenWidth-2)/5));
    make.height.equalTo(@44);
  }];


    [self.attentionView mas_remakeConstraints:^(MASConstraintMaker *make) {
     // make.left.equalTo(self.giftView.mas_right).offset(.5);
      make.left.equalTo(self.contentView);
      make.top.equalTo(self.iconView.mas_bottom).offset(31);
      make.width.equalTo(@((kScreenWidth-2)/5));
      make.height.equalTo(@44);
    }];


    [self.fansView mas_remakeConstraints:^(MASConstraintMaker *make) {
     // make.left.equalTo(self.attentionView.mas_right).offset(.5);
      //make.left.equalTo(self.lineView2.mas_right);
      make.centerX.equalTo(self.contentView);
      make.top.equalTo(self.iconView.mas_bottom).offset(31);
      make.width.equalTo(@((kScreenWidth-2)/5));
      make.height.equalTo(@44);
    }];


    [self.likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
     // make.left.equalTo(self.fansView.mas_right).offset(.5);
      make.right.equalTo(self.contentView);
      //make.left.equalTo(self.lineView3.mas_right);
      make.top.equalTo(self.iconView.mas_bottom).offset(31);
      make.width.equalTo(@((kScreenWidth-2)/5));
      make.height.equalTo(@44);
    }];
  }else{
    self.heartView.hidden = NO;
    self.giftView.hidden = NO;
    [self.heartView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.contentView);
      make.top.equalTo(self.iconView.mas_bottom).offset(31);
      make.width.equalTo(@((kScreenWidth-2)/5));
      make.height.equalTo(@44);
    }];

  [self.giftView mas_remakeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.heartView.mas_right).offset(.5);
    make.top.equalTo(self.iconView.mas_bottom).offset(31);
    make.width.equalTo(@((kScreenWidth-2)/5));
    make.height.equalTo(@44);
  }];

    [self.attentionView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.giftView.mas_right).offset(.5);
      make.top.equalTo(self.iconView.mas_bottom).offset(31);
      make.width.equalTo(@((kScreenWidth-2)/5));
      make.height.equalTo(@44);
    }];

 

    [self.fansView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.attentionView.mas_right).offset(.5);
      //make.left.equalTo(self.lineView2.mas_right);
      make.top.equalTo(self.iconView.mas_bottom).offset(31);
      make.width.equalTo(@((kScreenWidth-2)/5));
      make.height.equalTo(@44);
    }];


    [self.likeView mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.fansView.mas_right).offset(.5);
      make.top.equalTo(self.iconView.mas_bottom).offset(31);
      make.width.equalTo(@((kScreenWidth-2)/5));
      make.height.equalTo(@44);
    }];
  }
 
}
@end
