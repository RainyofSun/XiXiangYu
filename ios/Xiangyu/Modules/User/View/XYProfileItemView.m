//
//  XYProfileItemView.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/6/3.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYProfileItemView.h"

@implementation XYProfileItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.statusLable];
    
    [self.statusLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.right.equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
    }];
    
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = ColorHex(XYTextColor_FFFFFF);
        _titleLabel.font = AdaptedFont(XYFont_B);
    }
    return _titleLabel;
}

- (UILabel *)statusLable {
    if (!_statusLable) {
        _statusLable = [[UILabel alloc] init];
        _statusLable.textAlignment = NSTextAlignmentCenter;
        _statusLable.textColor = ColorHex(XYTextColor_FFFFFF);
        _statusLable.font = AdaptedFont(XYFont_E);
    }
    return _statusLable;
}
@end
