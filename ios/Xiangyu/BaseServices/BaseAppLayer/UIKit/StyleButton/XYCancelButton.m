//
//  XYCancelButton.m
//  Xiangyu
//
//  Created by dimon on 02/02/2021.
//

#import "XYCancelButton.h"

@implementation XYCancelButton
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
        [self setBackgroundColor:ColorHex(XYThemeColor_F)];
    } else {
        [self setBackgroundColor:ColorHex(XYThemeColor_I)];
    }
}

- (void)setUpStyle {
    [self setBackgroundColor:ColorHex(XYThemeColor_I)];
    self.titleLabel.font = AdaptedFont(XYFont_F);
    [self setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateNormal];
    [self setTitleColor:ColorHex(XYTextColor_FFFFFF) forState:UIControlStateDisabled];
}

@end
