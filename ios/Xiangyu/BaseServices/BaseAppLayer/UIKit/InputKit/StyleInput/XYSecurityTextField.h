//
//  XYSecurityTextField.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/19.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSecurityTextField : UIView

@property (nonatomic,copy) NSString *text;

@property (nonatomic,copy) NSString *placeholder;

@property (nonatomic,assign) BOOL shouldClear;

@property (nonatomic,assign) BOOL shoundBoard;

@property (nonatomic,assign) NSInteger maxInputNum;

@property (nonatomic,assign) UIKeyboardType keyboardType;

@end
