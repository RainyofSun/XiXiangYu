//
//  UIView+Extension.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/15.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (CGFloat)XY_left {
    return self.frame.origin.x;
}

- (void)setXY_left:(CGFloat)XY_left {
    CGRect frame = self.frame;
    frame.origin.x = XY_left;
    self.frame = frame;
}

- (CGFloat)XY_top {
    return self.frame.origin.y;
}

- (void)setXY_top:(CGFloat)XY_top {
    CGRect frame = self.frame;
    frame.origin.y = XY_top;
    self.frame = frame;
}

- (CGFloat)XY_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setXY_right:(CGFloat)XY_right {
    CGRect frame = self.frame;
    frame.origin.x = XY_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)XY_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setXY_bottom:(CGFloat)XY_bottom {
    CGRect frame = self.frame;
    frame.origin.y = XY_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)XY_width {
    return self.frame.size.width;
}

- (void)setXY_width:(CGFloat)XY_width {
    CGRect frame = self.frame;
    frame.size.width = XY_width;
    self.frame = frame;
}

- (CGFloat)XY_height {
    return self.frame.size.height;
}

- (void)setXY_height:(CGFloat)XY_height {
    CGRect frame = self.frame;
    frame.size.height = XY_height;
    self.frame = frame;
}

- (CGFloat)XY_centerX {
    return self.center.x;
}

- (void)setXY_centerX:(CGFloat)XY_centerX {
    self.center = CGPointMake(XY_centerX, self.center.y);
}

- (CGFloat)XY_centerY {
    return self.center.y;
}

- (void)setXY_centerY:(CGFloat)XY_centerY {
    self.center = CGPointMake(self.center.x, XY_centerY);
}

- (CGPoint)XY_origin {
    return self.frame.origin;
}

- (void)setXY_origin:(CGPoint)XY_origin {
    CGRect frame = self.frame;
    frame.origin = XY_origin;
    self.frame = frame;
}

- (CGSize)XY_size {
    return self.frame.size;
}

- (void)setXY_size:(CGSize)XY_size {
    CGRect frame = self.frame;
    frame.size = XY_size;
    self.frame = frame;
}

@end
