//
//  XYDefaultButton.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/15.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYDefaultButton.h"

@implementation XYDefaultButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpStyle];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.XY_height / 2;
}
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        [self setBackgroundColor:ColorHex(XYThemeColor_H)];
    } else {
        [self setBackgroundColor:ColorHex(XYThemeColor_A)];
    }
}
- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled) {
        [self setBackgroundColor:ColorHex(XYThemeColor_A)];
    } else {
        [self setBackgroundColor:ColorHex(XYThemeColor_I)];
    }
}

- (void)setUpStyle {
    [self setBackgroundColor:ColorHex(XYThemeColor_A)];
    self.titleLabel.font = AdaptedFont(XYFont_F);
    [self setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    [self setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
}

@end
