//
//  XYLoadingHUD.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/16.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XYShowLoading [XYLoadingHUD show]

#define XYHiddenLoading [XYLoadingHUD hidden]

#define XYShowOn(_view_) [XYLoadingHUD showOnView:(_view_)]

#define XYHiddenOn(_view_) [XYLoadingHUD hiddenOnView:(_view_)]

@interface XYLoadingHUD : NSObject

/** 在窗口上显示加载动画 */
+ (void)show;

/** 在view上显示加载动画 */
+ (void)showOnView:(UIView *)view;

/** 显示加载动画和文字 */
+ (void)showWithText:(NSString *)text;

/** 在view上显示加载动画和文字 */
+ (void)showWithText:(NSString *)text onView:(UIView *)view;

/** 隐藏加载动画 */
+ (void)hidden;

/** 隐藏加在view上的加载动画 */
+ (void)hiddenOnView:(UIView *)view;

@end
