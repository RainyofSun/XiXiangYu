//
//  XYToast.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/16.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYToast.h"

@implementation XYToast

+ (void)showSuccessText:(NSString *)text {
    [self showSuccessText:text view:nil];
}

+ (void)showSuccessText:(NSString *)text view:(UIView *)view {
    [self showImage:[UIImage imageNamed:@"tips_success"] text:text onView:view afterDelay:2.0];
}

+ (void)showErrorText:(NSString *)text {
    [self showErrorText:text view:nil];
}

+ (void)showErrorText:(NSString *)text view:(UIView *)view {
    [self showImage:[UIImage imageNamed:@"tips_fail"] text:text onView:view afterDelay:2.0];
}

+ (void)showServerbusy {
  [self showErrorText:@"系统繁忙"];
}

+ (void)showNotReachable {
  [self showErrorText:@"网络无法连接"];
}

+ (void)showWeakNetwork {
  [self showErrorText:@"网络不给力"];
}

+ (void)showImage:(UIImage *)image text:(NSString *)text onView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay {
    if (view == nil) view = kKeyWindow;
    if (!text.isNotBlank) return;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = UIColorAlpha(XYThemeColor_D, XYColorAlpha_70);
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.detailsLabel.text = text;
    hud.detailsLabel.textColor = ColorHex(XYTextColor_FFFFFF);
    hud.detailsLabel.font = AdaptedFont(XYFont_E);
    hud.removeFromSuperViewOnHide = YES;
    hud.minSize = CGSizeMake(140, 140);
    [hud hideAnimated:YES afterDelay:afterDelay];
}


+ (void)showText:(NSString *)text {
    [self showText:text onView:nil afterDelay:2.0 handler:nil];
}

+ (void)showText:(NSString *)text handler:(void(^)(void))handler {
    [self showText:text onView:nil afterDelay:2.0 handler:handler];
}

+ (void)showText:(NSString *)text onView:(UIView *)view {
    [self showText:text onView:view afterDelay:2.0 handler:nil];
}

+ (void)showText:(NSString *)text onView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay {
    [self showText:text onView:view afterDelay:afterDelay handler:nil];
}

+ (void)showText:(NSString *)text onView:(UIView *)view afterDelay:(NSTimeInterval)afterDelay handler:(void(^)(void))handler {
    if (view == nil) view = kKeyWindow;
    if (!text.isNotBlank) return;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = UIColorAlpha(XYThemeColor_D, XYColorAlpha_70);
    hud.detailsLabel.font = AdaptedFont(XYFont_E);
    hud.detailsLabel.textColor = ColorHex(XYTextColor_FFFFFF);
    hud.detailsLabel.text = text;
    [hud hideAnimated:YES afterDelay:afterDelay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(afterDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (handler) {
            handler();
        }
    });
}
@end
