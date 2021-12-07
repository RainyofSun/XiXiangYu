//
//  XYInputTextField.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYInputTextField : UIView

@property (nonatomic,copy) NSString *placeholder;

@property (nonatomic,copy) NSString *text;

@property (nonatomic,assign,getter=isShouldClear) BOOL shouldClear;

@property (nonatomic,assign,getter=isShoundBoard) BOOL shoundBoard;

@property (nonatomic,assign,getter=isShoundBoard) BOOL shoundSeparter;

@property (nonatomic,assign,getter=isSecureTextEntry) BOOL secureTextEntry;

@property (nonatomic,assign) NSInteger maxInputNum;

@property (nonatomic,assign) UIKeyboardType keyboardType;

@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *placeholderColor;

@property (nonatomic,assign) CGFloat paddingHorizontal;
@end
