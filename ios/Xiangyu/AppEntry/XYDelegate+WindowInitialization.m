//
//  XYDelegate+WindowInitialization.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYDelegate+WindowInitialization.h"
#import "XYLoginMobileViewController.h"
#import "XYTabbarConfig.h"
#import "YYFPSLabel.h"
#import "GuideViewController.h"
@implementation XYDelegate (WindowInitialization)

- (void)initializeWindowWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
  [self configGlobalNavBarStyle];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchMainView) name:XYGotoMainViewNotificationName object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchLoginView) name:XYLogoutNotificationName object:nil];
  
  if ([XYUserService service].isLogin) {
    [self switchMainView];
  } else {
    [self switchLoginView];
  }
    
#ifdef DEBUG
    [self FPSLable];
#endif
    
    [self.window makeKeyAndVisible];
    
  id tag = [[NSUserDefaults standardUserDefaults]objectForKey:@"GuideKey"];
  if (!tag || ![tag isEqualToString: [XYAppVersion currentVersion]]) {
      GuideViewController *guideView=[[GuideViewController alloc]init];
      guideView.modalPresentationStyle = UIModalPresentationOverFullScreen;
     [self.window.rootViewController presentViewController:guideView animated:NO completion:nil];
   // [self.window addSubview:guideView.view];
  }
}

- (void)switchMainView {
  self.window.rootViewController = [XYTabbarConfig sharedConfig].tabBarController;
}

- (void)switchLoginView {
  if (!self.window.rootViewController || [self.window.rootViewController isKindOfClass:[CYLTabBarController class]]) {
    [[XYTabbarConfig sharedConfig] releaseViewControllers];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[XYLoginMobileViewController alloc] init]];
  }
}

- (void)FPSLable {
    YYFPSLabel *label = [[YYFPSLabel alloc] initWithFrame:CGRectMake(kScreenWidth - 100, 30, 100, 30)];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
}

- (void)configGlobalNavBarStyle {
  [GKConfigure setupCustomConfigure:^(GKNavigationBarConfigure *configure) {
    // 导航栏背景色
    configure.backgroundColor = ColorHex(XYThemeColor_B);
    // 导航栏标题颜色
    configure.titleColor = ColorHex(XYTextColor_222222);
    // 导航栏标题字体
    configure.titleFont = AdaptedMediumFont(18);
    
    configure.statusBarStyle = UIStatusBarStyleDefault;
    
    configure.backStyle = GKNavigationBarBackStyleBlack;
    
    configure.backImage = [UIImage imageNamed:@"icon_arrow_back_22"];
  }];
}


@end
