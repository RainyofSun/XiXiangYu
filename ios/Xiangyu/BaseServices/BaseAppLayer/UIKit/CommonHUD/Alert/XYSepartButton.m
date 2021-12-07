//
//  XYSepartButton.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/18.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYSepartButton.h"
#import "XYDefaultButton.h"

@interface XYSepartButton ()

@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,strong) UIView *lineView;

@end

@implementation XYSepartButton
- (instancetype)initWithType:(XYSepartButtonType)type {
    if (self = [super init]) {
        self.type = type;
        [self addSubview:self.btn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    switch (_type) {
        case XYSepartButtonTypeTop:
        {
            _btn.frame = self.bounds;
            _btn.XY_top = 1;
            self.lineView.frame = CGRectMake(0, 0, self.XY_width, 1);
        }
            break;
        case XYSepartButtonTypeBottom:
        {
            _btn.frame = self.bounds;
            _btn.XY_height = self.XY_height - 1;
            self.lineView.frame = CGRectMake(0, _btn.XY_height, self.XY_width, 1);
        }
            break;
        case XYSepartButtonTypeCorner:
            _btn.frame = CGRectMake(5, 5, self.XY_width-10, self.XY_height-10);
            break;
        case XYSepartButtonTypeNone:
            _btn.frame = self.bounds;
            break;
        default:
            break;
    }
}

- (void)setType:(XYSepartButtonType)type {
    if ((type == XYSepartButtonTypeTop || type == XYSepartButtonTypeBottom) && !
        _type) {
        self.lineView.hidden = NO;
        [self addSubview:self.lineView];
    } else if (type == XYSepartButtonTypeCorner) {
        self.lineView.hidden = YES;
    } else {
        self.lineView.hidden = YES;
    }
    _type = type;
    [self layoutIfNeeded];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.btn setTitle:title forState:UIControlStateNormal];
}

- (void)buttonAction:(UIButton *)sender {
    [self.target performSelectorOnMainThread:@selector(buttonAction:) withObject:@(self.tag) waitUntilDone:NO];
}
- (UIButton *)btn {
    if (!_btn) {
        if (_type == XYSepartButtonTypeCorner) {
            _btn = [XYDefaultButton buttonWithType:UIButtonTypeCustom];
            [_btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            _btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_btn setTitleColor:ColorHex(XYTextColor_222222) forState:UIControlStateNormal];
            _btn.titleLabel.font = AdaptedFont(XYFont_E);
            [_btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _btn;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = ColorHex(XYThemeColor_E);
    }
    return _lineView;
}
@end
