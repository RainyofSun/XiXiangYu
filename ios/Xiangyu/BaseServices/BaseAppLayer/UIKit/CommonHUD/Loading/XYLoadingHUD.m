//
//  XYLoadingHUD.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/16.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYLoadingHUD.h"
#import <Lottie/Lottie.h>

static NSString *const kDefaultLoadingText = @"加载中";

@implementation XYLoadingHUD

+ (void)show {
    [self showWithText:kDefaultLoadingText onView:kKeyWindow];
}
+ (void)showOnView:(UIView *)view {
    [self showWithText:kDefaultLoadingText onView:view];
}
+ (void)showWithText:(NSString *)text {
    [self showWithText:text onView:kKeyWindow];
}
+ (void)showWithText:(NSString *)text onView:(UIView *)view {
    if (view == nil) view = kKeyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor clearColor];
    NSString *path = [NSBundle pathForResourceName:@"data" ofType:@"json"];
  //CGRect rect = CGRectMake(0, 0, 30, 40);
    LOTAnimationView *animation = [LOTAnimationView animationWithFilePath:path];
 // animation.bounds = rect;
    [animation setLoopAnimation:YES];
  animation.contentMode = UIViewContentModeScaleAspectFit;
    [animation play];
  
  UIView *custom =[[UIView alloc]init];
  [custom addSubview:animation];
  [animation remakeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(custom);
    make.width.height.mas_equalTo(88);
  }];
  
    hud.customView = custom;
    hud.label.textColor = ColorHex(XYTextColor_666666);
    hud.label.font = AdaptedFont(XYFont_A);
    if (text.isNotBlank) hud.label.text = text;
}

+ (void)hidden {
    [self hiddenOnView:kKeyWindow];
}
+ (void)hiddenOnView:(UIView *)view {
    if (view == nil) view = kKeyWindow;
    [MBProgressHUD hideHUDForView:view animated:YES];
}
@end
