//
//  XYLinkageRecycleCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/19.
//

#import "XYLinkageRecycleCell.h"

@interface XYLinkageRecycleLeftCell ()

@property (nonatomic,strong) UILabel *lable;

@end

@implementation XYLinkageRecycleLeftCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      self.contentView.backgroundColor = ColorHex(XYThemeColor_F);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.lable];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.lable.frame = self.contentView.bounds;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.lable.text = title;
}

- (UILabel *)lable {
    if (!_lable) {
        _lable = [[UILabel alloc] init];
        _lable.font = AdaptedFont(XYFont_D);
        _lable.textColor = ColorHex(XYTextColor_222222);
        _lable.numberOfLines = 0;
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  self.lable.font = selected ? AdaptedMediumFont(XYFont_D) : AdaptedFont(XYFont_D);
  self.contentView.backgroundColor = selected ? ColorHex(XYThemeColor_B) : ColorHex(XYThemeColor_F);
}

@end


@interface XYLinkageRecycleRightCell ()

@property (nonatomic,strong) UILabel *lable;

@end

@implementation XYLinkageRecycleRightCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      self.contentView.backgroundColor = ColorHex(XYThemeColor_B);
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      [self.contentView addSubview:self.lable];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.lable.frame = CGRectMake(16, 0, self.XY_width-32, 48);
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.lable.text = title;
}

- (UILabel *)lable {
    if (!_lable) {
        _lable = [[UILabel alloc] init];
        _lable.font = AdaptedFont(XYFont_D);
        _lable.textColor = ColorHex(XYTextColor_666666);
        _lable.numberOfLines = 0;
        _lable.textAlignment = NSTextAlignmentCenter;
        _lable.backgroundColor = ColorHex(XYThemeColor_F);
      _lable.layer.cornerRadius = 4;
      _lable.layer.masksToBounds = YES;
    }
    return _lable;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  self.lable.textColor = selected ? ColorHex(XYTextColor_FE2D63) : ColorHex(XYTextColor_666666);
}
@end
