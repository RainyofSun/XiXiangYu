//
//  XYPasswordView.h
//  XYPasswordView
//
//  Created by edz on 2017/7/17.
//  Copyright © 2017年 刘朋坤. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^XYPasswordViewTextDidChangeBlock)(NSString *codeString);

@interface XYPasswordView : UIView

@property (nonatomic, assign) NSInteger numberOfChars;

@property (nonatomic, assign) CGFloat itemDistance;

@property (nonatomic, copy) XYPasswordViewTextDidChangeBlock codeBlock;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *underLineColor;

- (void)becomeInputStatus;

@end

