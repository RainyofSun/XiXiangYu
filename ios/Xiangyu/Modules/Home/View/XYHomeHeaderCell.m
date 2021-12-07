//
//  XYHomeHeaderCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2020/12/31.
//

#import "XYHomeHeaderCell.h"

@interface XYHomeHeaderCell ()

@property (strong, nonatomic) UIImageView *bgImageView;

@property (strong, nonatomic) UIImageView *locationImageView;

@property (strong, nonatomic) UIView *bgContentView;

@property (strong, nonatomic) UIImageView *iconImageView;

//@property (strong, nonatomic) UILabel *hometownLabel;
//
//@property (strong, nonatomic) UILabel *locationLabel;
//
//@property (strong, nonatomic) YYLabel *fellowLable;
//
//@property (strong, nonatomic) UIView *line1;
//
//@property (strong, nonatomic) YYLabel *videoLable;
//
//@property (strong, nonatomic) UIView *line2;
//
//@property (strong, nonatomic) YYLabel *tidingsLable;

@property (strong, nonatomic) UILabel *sloganLable;
@property (strong, nonatomic) YYLabel *recommendLable;

@end

@implementation XYHomeHeaderCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = ColorHex(XYThemeColor_F);
        [self setupSubViews];
    }
    return self;
}

- (void)didClickVideos {
  id target = ((NSDictionary *)self.item)[XYHome_Router];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([target respondsToSelector:@selector(didClickVideos)]) {
    [target performSelector:@selector(didClickVideos) withObject:nil];
  }
#pragma clang diagnostic pop
}

- (void)didClickDynamics {
  id target = ((NSDictionary *)self.item)[XYHome_Router];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([target respondsToSelector:@selector(didClickDynamics)]) {
    [target performSelector:@selector(didClickDynamics) withObject:nil];
  }
#pragma clang diagnostic pop
}
- (void)didClickNearBy {
  id target = ((NSDictionary *)self.item)[XYHome_Router];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([target respondsToSelector:@selector(didClickNearBy)]) {
    [target performSelector:@selector(didClickNearBy) withObject:nil];
  }
#pragma clang diagnostic pop
}

- (void)setupSubViews {
  [self.contentView addSubview:self.bgImageView];
  [self.contentView addSubview:self.bgContentView];
  
  [self.contentView addSubview:self.iconImageView];
  [self.bgContentView addSubview:self.locationImageView];
  [self.bgContentView addSubview:self.sloganLable];
  [self.bgContentView addSubview:self.recommendLable];
  
//  [self.bgContentView addSubview:self.locationLabel];
//
//  [self.bgContentView addSubview:self.hometownLabel];
//
//  [self.bgContentView addSubview:self.fellowLable];
//  [self.bgContentView addSubview:self.line1];
//  [self.bgContentView addSubview:self.videoLable];
//  [self.bgContentView addSubview:self.line2];
//  [self.bgContentView addSubview:self.tidingsLable];
  
    
  self.bgImageView.frame = CGRectMake(0, 0, self.XY_width, 70);
    
  self.bgContentView.frame = CGRectMake(16, 22, self.XY_width-32, 80);
  
  self.locationImageView.frame = CGRectMake(self.XY_width-124, 0, 92, 80);
  
  self.iconImageView.frame = CGRectMake(20, 12, 90, 90);
  
  self.sloganLable.frame = CGRectMake(102, 18, self.XY_width-140, 22);
  
  self.recommendLable.frame = CGRectMake(94, 48, self.XY_width-140, 22);
  
//  self.hometownLabel.frame = CGRectMake(16, 16, self.bgContentView.XY_width - 32, 20);
//
//  self.locationLabel.frame = CGRectMake(16, 44, self.bgContentView.XY_width - 32, 20);
//
//  CGFloat item_W = (self.bgContentView.XY_width - 32 - 2)/3;
//
//  self.fellowLable.frame = CGRectMake(16, 76, item_W, 44);
//
//  self.line1.frame = CGRectMake(CGRectGetMaxX(self.fellowLable.frame), 76, 1, 44);
//
//  self.videoLable.frame = CGRectMake(CGRectGetMaxX(self.line1.frame), 76, item_W, 44);
//
//  self.line2.frame = CGRectMake(CGRectGetMaxX(self.videoLable.frame), 76, 1, 44);
//
//  self.tidingsLable.frame = CGRectMake(CGRectGetMaxX(self.line2.frame), 76, item_W, 44);

}

- (void)setItem:(NSDictionary *)item {
  [super setItem:item];
  
  NSString *hometown = [NSString stringWithFormat:@"嗨~  欢迎来自 %@ 的你！", item[XYHome_Hometown]];
  NSRange hometownRange = [hometown rangeOfString:item[XYHome_Hometown]];
  NSMutableAttributedString *hometownAttr_s = [[NSMutableAttributedString alloc] initWithString:hometown attributes:@{NSForegroundColorAttributeName : ColorHex(XYTextColor_666666),NSFontAttributeName : AdaptedFont(14)}];
  
  [hometownAttr_s addAttributes:@{NSForegroundColorAttributeName : ColorHex(@"#F92B5E"),NSFontAttributeName : AdaptedFont(14)} range:hometownRange];
  
  self.sloganLable.attributedText = hometownAttr_s;
  
  NSString *recommString = [NSString stringWithFormat:@"在 %@ 共有 %@老乡▶ 等着你哦~", item[XYHome_Location], item[XYHome_Fellow]];
  NSRange locationRange = [recommString rangeOfString:item[XYHome_Location]];
  NSRange fellowRange = [recommString rangeOfString:[NSString stringWithFormat:@"%@老乡▶", item[XYHome_Fellow]]];
  
  NSMutableAttributedString *recommAttr_s = [[NSMutableAttributedString alloc] initWithString:recommString attributes:@{NSForegroundColorAttributeName : ColorHex(XYTextColor_666666),NSFontAttributeName : AdaptedFont(14)}];
  
  [recommAttr_s addAttributes:@{NSForegroundColorAttributeName : ColorHex(@"#F92B5E"),NSFontAttributeName : AdaptedFont(14)} range:locationRange];
  [recommAttr_s addAttributes:@{NSForegroundColorAttributeName : ColorHex(@"#F92B5E"),NSFontAttributeName : AdaptedFont(14)} range:fellowRange];
  
  self.recommendLable.attributedText = recommAttr_s;
  
  
//  NSString *hometown = [NSString stringWithFormat:@"您的故乡：%@", item[XYHome_Hometown]];
//  NSMutableAttributedString *hometownAttr_s = [[NSMutableAttributedString alloc] initWithString:hometown];
//  [hometownAttr_s addAttributes:@{NSForegroundColorAttributeName : ColorHex(XYTextColor_666666)} range:NSMakeRange(0, 5)];
//  [hometownAttr_s addAttributes:@{NSFontAttributeName : AdaptedFont(XYFont_D)} range:NSMakeRange(0, 5)];
//  [hometownAttr_s addAttributes:@{NSForegroundColorAttributeName : ColorHex(XYTextColor_222222)} range:NSMakeRange(5, hometown.length-5)];
//  [hometownAttr_s addAttributes:@{NSFontAttributeName : AdaptedMediumFont(XYFont_E)} range:NSMakeRange(5, hometown.length-5)];
//  self.hometownLabel.attributedText = hometownAttr_s;
//
//  NSString *location = [NSString stringWithFormat:@"您的位置：%@", item[XYHome_Location]];
//  NSMutableAttributedString *locationAttr_s = [[NSMutableAttributedString alloc] initWithString:location];
//  [locationAttr_s addAttributes:@{NSForegroundColorAttributeName : ColorHex(XYTextColor_666666)} range:NSMakeRange(0, 5)];
//  [locationAttr_s addAttributes:@{NSFontAttributeName : AdaptedFont(XYFont_D)} range:NSMakeRange(0, 5)];
//  [locationAttr_s addAttributes:@{NSForegroundColorAttributeName : ColorHex(XYTextColor_222222)} range:NSMakeRange(5, location.length-5)];
//  [locationAttr_s addAttributes:@{NSFontAttributeName : AdaptedMediumFont(XYFont_E)} range:NSMakeRange(5, location.length-5)];
//  self.locationLabel.attributedText = locationAttr_s;
//
//
//  NSString *fellow = item[XYHome_Fellow];
//  self.fellowLable.attributedText = [self createAttributedStringWithDesc:@"共有老乡：" value:fellow unit:@"人"];
//  self.fellowLable.textAlignment = NSTextAlignmentCenter;
//  NSString *shortVideo = item[XYHome_Shortvideo];
//  self.videoLable.attributedText = [self createAttributedStringWithDesc:@"短视频：" value:shortVideo unit:@"条"];
//  self.videoLable.textAlignment = NSTextAlignmentCenter;
//  NSString *tidings = item[XYHome_Tidings];
//  self.tidingsLable.attributedText = [self createAttributedStringWithDesc:@"动态：" value:tidings unit:@"条"];
//  self.tidingsLable.textAlignment = NSTextAlignmentCenter;
}

//- (NSMutableAttributedString *)createAttributedStringWithDesc:(NSString *)desc value:(NSString *)value unit:(NSString *)unit {
//  UIFont *maxFont = AdaptedFont(14);
//
//  NSString *text = [NSString stringWithFormat:@"%@%@%@", desc, value, unit];
//  NSMutableAttributedString *attr_s = [[NSMutableAttributedString alloc] initWithString:text];
//  NSRange descRange = [text rangeOfString:desc];
//  [attr_s addAttributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_666666),
//                          NSFontAttributeName:AdaptedFont(12)
//  } range:descRange];
//  NSRange valueRange = [text rangeOfString:[NSString stringWithFormat:@"%@%@", value, unit]];
//  [attr_s addAttributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_FE2D63),
//                          NSFontAttributeName:AdaptedFont(14)
//  } range:valueRange];
//
//  UIImage *image = [UIImage imageNamed:@"arrow_10"];
//  NSMutableAttributedString *attachment = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:maxFont alignment:YYTextVerticalAlignmentCenter];
//  [attr_s appendAttributedString:attachment];
//  return attr_s;
//}
#pragma mark - getter

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
      _bgImageView.image = [UIImage imageNamed:@"bg_home_red"];
    }
    return _bgImageView;
}
- (UIImageView *)locationImageView {
    if (!_locationImageView) {
      _locationImageView = [[UIImageView alloc] init];
      _locationImageView.image = [UIImage imageNamed:@"bghome dingwe"];
    }
    return _locationImageView;
}
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
      _iconImageView = [[UIImageView alloc] init];
      _iconImageView.image = [UIImage imageNamed:@"shouye-maga"];
    }
    return _iconImageView;
}


- (UIView *)bgContentView {
    if (!_bgContentView) {
      _bgContentView = [[UIView alloc] init];
      _bgContentView.backgroundColor = ColorHex(XYThemeColor_F);
      _bgContentView.layer.cornerRadius = 12;
      _bgContentView.layer.shadowColor = ColorHex(XYThemeColor_G).CGColor;
      _bgContentView.layer.shadowOffset = CGSizeMake(0,0);
      _bgContentView.layer.shadowOpacity = 0.16;
      _bgContentView.layer.shadowRadius = 12;
    }
    return _bgContentView;
}
//
//- (UILabel *)locationLabel {
//    if (!_locationLabel) {
//      _locationLabel = [[UILabel alloc] init];
//      _locationLabel.textColor = ColorHex(XYTextColor_666666);
//      _locationLabel.font = AdaptedFont(XYFont_D);
//    }
//    return _locationLabel;
//}
//
//- (UILabel *)hometownLabel {
//    if (!_hometownLabel) {
//      _hometownLabel = [[UILabel alloc] init];
//      _hometownLabel.textColor = ColorHex(XYTextColor_222222);
//      _hometownLabel.font = AdaptedMediumFont(XYFont_E);
//    }
//    return _hometownLabel;
//}
//
//- (YYLabel *)fellowLable {
//    if (!_fellowLable) {
//      _fellowLable = [[YYLabel alloc] init];
//      @weakify(self);
//      _fellowLable.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        [weak_self didClickFriends];
//      };
//    }
//    return _fellowLable;
//}
//
//- (UIView *)line1 {
//    if (!_line1) {
//      _line1 = [[UIView alloc] init];
//      _line1.backgroundColor = ColorHex(XYThemeColor_F);
//    }
//    return _line1;
//}
//
//- (YYLabel *)videoLable {
//    if (!_videoLable) {
//      _videoLable = [[YYLabel alloc] init];
//      @weakify(self);
//      _videoLable.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        [weak_self didClickVideos];
//      };
//    }
//    return _videoLable;
//}

//- (UIView *)line2 {
//    if (!_line2) {
//      _line2 = [[UIView alloc] init];
//      _line2.backgroundColor = ColorHex(XYThemeColor_F);
//    }
//    return _line2;
//}
//
//- (YYLabel *)tidingsLable {
//    if (!_tidingsLable) {
//      _tidingsLable = [[YYLabel alloc] init];
//      @weakify(self);
//      _tidingsLable.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//        [weak_self didClickDynamics];
//      };
//    }
//    return _tidingsLable;
//}

- (UILabel *)sloganLable {
    if (!_sloganLable) {
      _sloganLable = [[UILabel alloc] init];
    }
    return _sloganLable;
}

- (YYLabel *)recommendLable {
    if (!_recommendLable) {
      _recommendLable = [[YYLabel alloc] init];
//      @weakify(self);
//      _recommendLable.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//       // @strongify(self);
//        [weak_self didClickNearBy];
//      };
    }
    return _recommendLable;
}
@end
