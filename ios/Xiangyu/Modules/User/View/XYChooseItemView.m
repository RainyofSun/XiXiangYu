//
//  XYChooseItemView.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/17.
//

#import "XYChooseItemView.h"

@interface XYChooseItemView ()

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *contentLable;

@property (nonatomic,strong) UIImageView *arrow;

@end

@implementation XYChooseItemView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseItem)];
      [self addGestureRecognizer:tap];
      [self addSubview:self.titleLable];
      [self addSubview:self.contentLable];
      [self addSubview:self.arrow];
    }
    return self;
}
#pragma mark - event
- (void)chooseItem {
  if (self.ChooseItemClick) {
    self.ChooseItemClick();
  }
}

- (void)layoutSubviews {
  self.titleLable.frame = CGRectMake(0, 0, 60, self.XY_height);
  self.arrow.frame = CGRectMake(self.XY_width-22, (self.XY_height-22)/2, 22, 22);
  self.contentLable.frame = CGRectMake(70, 0, self.XY_width-104, self.XY_height);
}

- (void)setTitle:(NSString *)title {
  _title = title;
  if (!title.isNotBlank) {
    return;
  }
  if ([title hasPrefix:@"*"]) {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:title];
    [attr addAttributes:@{NSForegroundColorAttributeName:ColorHex(@"#FF4144")} range:NSMakeRange(0, 1)];
    [attr addAttributes:@{NSForegroundColorAttributeName:ColorHex(XYTextColor_222222)} range:NSMakeRange(1, 2)];
    _titleLable.attributedText = attr;

  } else {
    _titleLable.text = title;
  }
}

- (void)setContent:(NSString *)content {
  _content = content;
  self.contentLable.text = content;
  self.contentLable.textColor = ColorHex(XYTextColor_222222);
}
#pragma mark - getter

- (UILabel *)titleLable {
    if (!_titleLable) {
      _titleLable = [[UILabel alloc] init];
      _titleLable.font = AdaptedFont(14);
    }
    return _titleLable;
}

- (UILabel *)contentLable {
    if (!_contentLable) {
      _contentLable = [[UILabel alloc] init];
      _contentLable.font = AdaptedFont(14);
      _contentLable.textColor = ColorHex(XYTextColor_CCCCCC);
      _contentLable.numberOfLines = 0;
      _contentLable.text = @"请选择";
    }
    return _contentLable;
}

- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] init];
        _arrow.image = [UIImage imageNamed:@"ic_arrow_gray"];
    }
    return _arrow;
}
@end
