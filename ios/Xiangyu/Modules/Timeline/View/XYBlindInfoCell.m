//
//  XYBlindInfoCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/3/10.
//

#import "XYBlindInfoCell.h"

@interface XYBlindInfoCell ()

@property (strong, nonatomic) YYLabel *contentLable;

@end

@implementation XYBlindInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.selectionStyle = UITableViewCellSelectionStyleNone;
      [self.contentView addSubview:self.titleLabel];
      [self.contentView addSubview:self.contentLable];
    }
    return self;
}

- (void)setTextLayout:(YYTextLayout *)textLayout {
    _textLayout = textLayout;
    self.titleLabel.frame = CGRectMake(16, 0, kScreenWidth-32, 22);
    self.contentLable.frame = CGRectMake(16, 36, kScreenWidth-32, textLayout.textBoundingSize.height);
    self.contentLable.textLayout = textLayout;
    
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

- (YYLabel *)contentLable {
    if (!_contentLable) {
      _contentLable = [[YYLabel alloc] init];
    }
    return _contentLable;
}
@end
