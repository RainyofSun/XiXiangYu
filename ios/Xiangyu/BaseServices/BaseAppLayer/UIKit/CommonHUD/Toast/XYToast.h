//
//  XYToast.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/16.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XYToastText(_text_) [XYToast showText:(_text_)]

#define XYToastTextOnView(_text_,_view_) [XYToast showText:(_text_) onView:(_view_)]

@interface XYToast : NSObject

+ (void)showSuccessText:(NSString *)text;

+ (void)showSuccessText:(NSString *)text view:(UIView *)view;

+ (void)showErrorText:(NSString *)text;

+ (void)showErrorText:(NSString *)text view:(UIView *)view;

+ (void)showServerbusy;

+ (void)showNotReachable;

+ (void)showWeakNetwork;

+ (void)showText:(NSString *)text;

+ (void)showText:(NSString *)text handler:(void(^)(void))handler;

+ (void)showText:(NSString *)text onView:(UIView *)view;

+ (void)showText:(NSString *)text onView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay;

+ (void)showText:(NSString *)text onView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay handler:(void(^)(void))handler;
@end
