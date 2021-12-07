//
//  XYBlindGiftListCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/3/10.
//

#import "XYBlindGiftListCell.h"

@interface XYBlindGiftListImageView : UIView

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation XYBlindGiftListImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
  CGFloat item_W = (kScreenWidth - 32 - 24)/4;
  self.imageView.frame = CGRectMake(0, 0, item_W, item_W);
  self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+4, item_W, 16);
    
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
      _titleLabel.textColor = ColorHex(XYTextColor_222222);
      _titleLabel.font = AdaptedFont(12);
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
      _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end

@interface XYBlindGiftListCell ()

@property (strong, nonatomic) UILabel *titleLable;

@property (strong, nonatomic) UIView *giftBgView;

@property (strong, nonatomic) UILabel *noGiftLable;
@property (strong, nonatomic) UIButton *arrowBtn;


@end

@implementation XYBlindGiftListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      [self.contentView addSubview:self.titleLabel];
      [self.contentView addSubview:self.arrowBtn];
      [self.contentView addSubview:self.giftBgView];
      [self.contentView addSubview:self.noGiftLable];
      self.titleLabel.frame = CGRectMake(16, 0, kScreenWidth-32, 22);
      self.arrowBtn.frame = CGRectMake(kScreenWidth-38, 0, 22, 22);
      self.giftBgView.frame = CGRectMake(16, 36, kScreenWidth-32, 100);
      self.noGiftLable.frame = CGRectMake(0, 53, kScreenWidth-32, 30);
      CGFloat item_W = (kScreenWidth - 32 - 24)/4;
      for (int i = 0; i < 4; i ++) {
        XYBlindGiftListImageView *itemBgView = [[XYBlindGiftListImageView alloc] initWithFrame:CGRectMake((item_W+8)*i, 0, item_W, item_W+20)];
        itemBgView.hidden = YES;
        itemBgView.tag = i + 100;
        [self.giftBgView addSubview:itemBgView];
      }
    }
    return self;
}
- (void)giftListClick {
  
  if (self.giftListClickToPage) {
      self.giftListClickToPage();
  }
  
}
- (void)setData:(NSArray<XYBlindGiftModel *> *)data {
  _data = data;
  if (!data || data.count == 0) {
    self.giftBgView.hidden = YES;
    self.noGiftLable.hidden = NO;
    return;
  } else {
    self.giftBgView.hidden = NO;
    self.noGiftLable.hidden = YES;
  }
  
  NSUInteger index = 100;
  for (XYBlindGiftModel *item in data) {
    XYBlindGiftListImageView *view = [self.giftBgView viewWithTag:index];
    view.hidden = NO;
    [view.imageView sd_setImageWithURL:[NSURL URLWithString:item.giftIconUrl]];
    view.titleLabel.text = item.giftName;
    index ++;
  }
  
  for (NSUInteger i = data.count; i < 4; i ++) {
    [self.giftBgView viewWithTag:i].hidden = YES;
  }
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
      _titleLabel.textColor = ColorHex(XYTextColor_222222);
      _titleLabel.font = AdaptedMediumFont(18);
    }
    return _titleLabel;
}

- (UIView *)giftBgView {
  if (!_giftBgView) {
    _giftBgView = [[UIView alloc] init];
    _giftBgView.backgroundColor = [UIColor whiteColor];
  }
  return _giftBgView;
}

- (UILabel *)noGiftLable {
    if (!_noGiftLable) {
      _noGiftLable = [[UILabel alloc] init];
      _noGiftLable.textColor = ColorHex(XYTextColor_999999);
      _noGiftLable.font = AdaptedFont(15);
      _noGiftLable.text = @"你愿意送TA第一个礼物吗？";
      _noGiftLable.textAlignment = NSTextAlignmentCenter;
    }
    return _noGiftLable;
}

- (UIButton *)arrowBtn {
    if (!_arrowBtn) {
      _arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_arrowBtn setImage:[UIImage imageNamed:@"ic_arrow_gray"] forState:UIControlStateNormal];
      
      [_arrowBtn addTarget:self action:@selector(giftListClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _arrowBtn;
}
@end
