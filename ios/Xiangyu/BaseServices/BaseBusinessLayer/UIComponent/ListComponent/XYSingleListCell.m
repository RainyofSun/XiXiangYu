//
//  XYSingleListCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/4.
//

#import "XYSingleListCell.h"

@interface XYSingleListCell ()

@property (nonatomic,strong) UILabel *lable;

@end

@implementation XYSingleListCell
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
    self.lable.frame = CGRectMake(16, 0, self.XY_width-32, self.XY_height);
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.lable.text = title;
}

- (UILabel *)lable {
    if (!_lable) {
        _lable = [[UILabel alloc] init];
        _lable.font = AdaptedFont(14);
        _lable.textColor = ColorHex(XYTextColor_444444);
    }
    return _lable;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  self.lable.textColor = selected ? ColorHex(XYTextColor_635FF0) : ColorHex(XYTextColor_444444);
}

@end

