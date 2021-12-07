//
//  XYImageAlertView.m
//  Baiqu
//
//  Created by Jacky Dimon on 2018/1/18.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYImageAlertView.h"
#import "XYSepartButton.h"

@interface XYImageAlertView ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong) UILabel *titleLable;

@property (nonatomic,strong) UILabel *detailLable;

@property (nonatomic,strong) UIView *horizontalLine;

@property (nonatomic,strong) UIView *verticalLine;

@property (nonatomic,strong) NSMutableArray *btnArray;

@property (nonatomic,strong) NSMutableArray *eventArray;

@end

@implementation XYImageAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorAlpha(@"#000000", XYColorAlpha_0);
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.closeBtn];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLable];
    [self.contentView addSubview:self.detailLable];
    [self.contentView addSubview:self.horizontalLine];
    [self.contentView addSubview:self.verticalLine];
}

- (void)layoutPageViews {
    
    if (self.type == XYAlertActionTypeForce) {
     self.closeBtn.frame = CGRectMake(15, 15, 15, 15);
    }
    
    self.contentView.frame = CGRectMake(70, 0, (kScreenWidth - 140), 0);
    
    self.imageView.frame = CGRectMake((kScreenWidth - 230)/2, 20, 90, 90);
    
    self.titleLable.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame)+20, (kScreenWidth - 140), 24);
    
    self.detailLable.frame = CGRectMake(22, CGRectGetMaxY(self.titleLable.frame)+6, (kScreenWidth - 184), 0);
    self.detailLable.XY_height = [self _calculateHeightForLable:self.detailLable].height;
    
    CGFloat height = CGRectGetMaxY(self.detailLable.frame);
    self.horizontalLine.frame = CGRectMake(0, height+20, (kScreenWidth - 140), 1);
    height = CGRectGetMaxY(self.horizontalLine.frame);
    
    if (self.btnArray.count == 1) {
        XYSepartButton *btn = self.btnArray.firstObject;
        btn.frame = CGRectMake(0, height, (kScreenWidth - 140), 43);
        height = CGRectGetMaxY(btn.frame);
    } else if (self.btnArray.count == 2) {
        self.verticalLine.frame = CGRectMake((kScreenWidth - 139)/2, height, 1, 43);
        XYSepartButton *left = self.btnArray.firstObject;
        XYSepartButton *right = self.btnArray.lastObject;
        if (self.type != XYAlertActionTypeForce) {
            right.type = XYSepartButtonTypeNone;
        }
        left.frame = CGRectMake(0, height, CGRectGetMinX(self.verticalLine.frame), 43);
        right.frame = CGRectMake(CGRectGetMaxX(self.verticalLine.frame), height, (kScreenWidth - 140 - CGRectGetMaxX(self.verticalLine.frame)), 43);
        height = CGRectGetMaxY(left.frame);
    } else if (self.btnArray.count > 2) {
        for (XYSepartButton *btn in self.btnArray) {
            if (btn.tag == 0) {
             btn.frame = CGRectMake(0, height, (kScreenWidth - 140), 43);
            } else {
                btn.frame = CGRectMake(0, CGRectGetMaxY(((UIButton *)self.btnArray[btn.tag - 1]).frame), (kScreenWidth - 140), 43);
                if (btn.tag == self.btnArray.count - 1) {
                    height = CGRectGetMaxY(btn.frame);
                }
            }
        }
    } else {
        height = CGRectGetMaxY(self.detailLable.frame);
    }
    
    if (self.type == XYAlertActionTypeForce) {
        self.contentView.height = height + 15;
    } else {
        self.contentView.height = height;
    }
    self.contentView.XY_centerY = self.XY_centerY;
}

- (void)show {
    [kKeyWindow addSubview:self];
    self.frame = kKeyWindow.bounds;
    [self layoutPageViews];
    self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.2 animations:^{
    self.backgroundColor = UIColorAlpha(@"#000000", XYColorAlpha_50);
    self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeScale(0.01,0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)addEvent:(NSString *)event action:(AlertActionBlock)action {
    XYSepartButton *btn = [[XYSepartButton alloc] initWithType:self.type == XYAlertActionTypeForce ? XYSepartButtonTypeCorner :(self.eventArray.count == 0 ? XYSepartButtonTypeNone : XYSepartButtonTypeTop)];
    btn.title = event;
    btn.tag = self.eventArray.count;
    btn.target = self;
    [self.contentView addSubview:btn];
    
    [self.btnArray addObject:btn];
    
    if (action == nil) {
        [self.eventArray addObject:@0];
    } else {
        [self.eventArray addObject:action];
    }
    [self layoutPageViews];
}

- (void)buttonAction:(NSNumber *)sender {
    id obj = self.eventArray[sender.integerValue];
    
    if (!obj) [self dismiss];
    
    if ([obj isKindOfClass:[NSNumber class]]) {
        [self dismiss];
    } else {
        if ((AlertActionBlock)obj) {
            ((AlertActionBlock)obj)();
        }
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLable.text = title;
}

- (void)setDetailText:(NSString *)detailText {
    _detailText = detailText;
    self.detailLable.text = detailText;
    [self layoutPageViews];
}

- (void)setType:(XYAlertActionType)type {
    _type = type;
    if (type == XYAlertActionTypeForce) {
        self.verticalLine.hidden = YES;
        self.horizontalLine.hidden = YES;
    }
    [self layoutPageViews];
}
#pragma mark - getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColorAlpha(@"#F6F6F6", XYColorAlpha_90);
        _contentView.layer.cornerRadius = 7;
    }
    return _contentView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"icon-pop-Close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = ColorHex(@"#D8D8D8");
    }
    return _imageView;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = AdaptedFont(17);
        _titleLable.textColor = ColorHex(@"#000000");
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}

- (UILabel *)detailLable {
    if (!_detailLable) {
        _detailLable = [[UILabel alloc] init];
        _detailLable.font = AdaptedFont(13);
        _detailLable.textColor = ColorHex(@"#000000");
        _detailLable.numberOfLines = 0;
        _detailLable.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLable;
}

- (UIView *)horizontalLine {
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.backgroundColor = UIColorAlpha(@"#000000", XYColorAlpha_10);
    }
    return _horizontalLine;
}

- (UIView *)verticalLine {
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = UIColorAlpha(@"#000000", XYColorAlpha_10);
    }
    return _verticalLine;
}

- (NSMutableArray *)btnArray {
    if (!_btnArray) {
        _btnArray = @[].mutableCopy;
    }
    return _btnArray;
}

- (NSMutableArray *)eventArray {
    if (!_eventArray) {
        _eventArray = @[].mutableCopy;
    }
    return _eventArray;
}
#pragma mark - private
- (CGSize)_calculateHeightForLable:(UILabel *)lable {
    
   return [lable sizeThatFits:CGSizeMake(lable.XY_width, MAXFLOAT)];
    
}
@end
