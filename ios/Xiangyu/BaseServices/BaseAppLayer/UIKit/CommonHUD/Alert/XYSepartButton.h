//
//  XYSepartButton.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/18.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYSepartButtonType) {
    XYSepartButtonTypeTop = 1,
    XYSepartButtonTypeBottom,
    XYSepartButtonTypeCorner,
    XYSepartButtonTypeNone
};

@interface XYSepartButton : UIView

- (instancetype)initWithType:(XYSepartButtonType)type;

@property (nonatomic,assign) XYSepartButtonType type;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,weak) id target;

@end
