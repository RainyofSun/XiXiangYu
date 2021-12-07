//
//  XYAddressMenu.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/21.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYAddressMenu.h"

static CGFloat const XYAddressMenuMargin = 10;

@interface XYAddressMenu ()

@property (nonatomic,strong) NSMutableArray * btnArray;

@end

@implementation XYAddressMenu

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    for (NSInteger i = 0; i <= self.btnArray.count - 1 ; i++) {
        
        UIView * view = self.btnArray[i];
        if (i == 0) {
               view.XY_left = XYAddressMenuMargin/2;
        }
        if (i > 0) {
                UIView * preView = self.btnArray[i - 1];
                view.XY_left = XYAddressMenuMargin + preView.XY_right;
        }
        
    }
}

- (NSMutableArray *)btnArray {
    NSMutableArray * mArray  = @[].mutableCopy;
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [mArray addObject:view];
        }
    }
    _btnArray = mArray;
    return _btnArray;
}
@end
