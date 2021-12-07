//
//  XYMinorButton.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/15.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYMinorButton.h"

@implementation XYMinorButton
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
        [self setBackgroundColor:ColorHex(XYThemeColor_I)];
    } else {
        [self setBackgroundColor:ColorHex(XYThemeColor_B)];
    }
}
- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (enabled) {
        [self setBackgroundColor:ColorHex(XYThemeColor_B)];
    } else {
        [self setBackgroundColor:ColorHex(XYThemeColor_E)];
    }
}

- (void)setUpStyle {
    [self setBackgroundColor:ColorHex(XYThemeColor_B)];
    self.titleLabel.font = AdaptedFont(XYFont_D);
    self.layer.borderColor = ColorHex(XYThemeColor_A).CGColor;
    self.layer.borderWidth = 0.5;
    [self setTitleColor:ColorHex(XYTextColor_FE2D63) forState:UIControlStateNormal];
    [self setTitleColor:ColorHex(XYTextColor_CCCCCC) forState:UIControlStateDisabled];
}

@end
