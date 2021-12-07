//
//  XYActionAlertCell.m
//  Baiqu
//
//  Created by Jacky Dimon on 2018/1/21.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYActionAlertCell.h"

@interface XYActionAlertCell ()

@property (nonatomic,strong) UILabel *lable;

@end

@implementation XYActionAlertCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.lable.textColor = titleColor;
}
- (UILabel *)lable {
    if (!_lable) {
        _lable = [[UILabel alloc] init];
        _lable.font = AdaptedFont(17);
        _lable.textColor = ColorHex(@"#000000");
        _lable.numberOfLines = 1;
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}
@end
