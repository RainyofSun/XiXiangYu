//
//  UIView+Extension.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/15.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic) CGFloat XY_left;        ///< Shortcut for frame.origin.x.

@property (nonatomic) CGFloat XY_top;         ///< Shortcut for frame.origin.y

@property (nonatomic) CGFloat XY_right;       ///< Shortcut for frame.origin.x + frame.size.width

@property (nonatomic) CGFloat XY_bottom;      ///< Shortcut for frame.origin.y + frame.size.height

@property (nonatomic) CGFloat XY_width;       ///< Shortcut for frame.size.width.

@property (nonatomic) CGFloat XY_height;      ///< Shortcut for frame.size.height.

@property (nonatomic) CGFloat XY_centerX;     ///< Shortcut for center.x

@property (nonatomic) CGFloat XY_centerY;     ///< Shortcut for center.y

@property (nonatomic) CGPoint XY_origin;      ///< Shortcut for frame.origin.

@property (nonatomic) CGSize  XY_size;        ///< Shortcut for frame.size.


@end
