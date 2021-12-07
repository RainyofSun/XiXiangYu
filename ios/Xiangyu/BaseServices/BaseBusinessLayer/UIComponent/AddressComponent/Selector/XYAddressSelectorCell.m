//
//  XYAddressSelectorCell.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/23.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYAddressSelectorCell.h"

@interface XYAddressSelectorCell ()

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UIImageView *checkView;

@end

@implementation XYAddressSelectorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubviews];
        [self makeConstraints];
    }
    return self;
}

- (void)addSubviews {
    [self.contentView addSubview:self.titleLable];
    [self.contentView addSubview:self.checkView];
    
}

- (void)makeConstraints {
    [self.titleLable makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(16);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.checkView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLable.mas_right).with.offset(12);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLable.text = title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    self.checkView.hidden = !selected;
    _titleLable.textColor = selected ? ColorHex(XYTextColor_635FF0) : ColorHex(XYTextColor_444444);
}

#pragma mark - getter
- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = AdaptedFont(XYFont_D);
        _titleLable.textColor = ColorHex(XYTextColor_444444);
    }
    return _titleLable;
}

- (UIImageView *)checkView {
    if (!_checkView) {
        _checkView = [[UIImageView alloc] init];
        _checkView.hidden = YES;
        _checkView.image = [UIImage imageNamed:@"icon-dui-selected"];
    }
    return _checkView;
}
@end
