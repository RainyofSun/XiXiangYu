//  XYTabbarConfig.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/5/26.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYTabbarConfig.h"
#import "XYProfileViewController.h"
#import "XYHomeViewController.h"
#import "XYTimelineContainerController.h"
#import "GKDYPlayerViewController.h"
#import "ConversationController.h"
#import "UINavigationController+GKCategory.h"
#import "XYBaseNavigationController.h"

@interface XYTabbarConfig () <CYLTabBarControllerDelegate>

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end
static XYTabbarConfig *instance = nil;
@implementation XYTabbarConfig
+ (XYTabbarConfig *)sharedConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)releaseViewControllers {
  self.tabBarController = nil;
}

- (CYLTabBarController *)tabBarController {
    if (_tabBarController == nil) {
      CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:
                                               self.viewControllers tabBarItemsAttributes:
                                               self.tabBarItemsAttributesForController];
      [self customizeTabBarAppearance];
      _tabBarController = tabBarController;
      _tabBarController.delegate = self;
        
    }
    return _tabBarController;
}

- (NSArray *)viewControllers {
  XYHomeViewController *homeVC = [[XYHomeViewController alloc] init];
  UINavigationController *homeNav = [XYBaseNavigationController rootVC:homeVC translationScale:NO];
  homeNav.gk_openSystemNavHandle = YES;

  XYTimelineContainerController *timelineVC = [[XYTimelineContainerController alloc] init];
  UINavigationController *timelineNav = [XYBaseNavigationController rootVC:timelineVC translationScale:NO];
  timelineNav.gk_openSystemNavHandle = YES;

  GKDYPlayerViewController *featuredVC = [[GKDYPlayerViewController alloc] init];
  UINavigationController *featuredNav = [XYBaseNavigationController rootVC:featuredVC translationScale:NO];
  featuredNav.gk_openSystemNavHandle = YES;

  ConversationController *friendsVC = [[ConversationController alloc] init];
  UINavigationController *friendsNav = [XYBaseNavigationController rootVC:friendsVC translationScale:NO];
  friendsNav.gk_openSystemNavHandle = YES;

  XYProfileViewController *profileVC = [[XYProfileViewController alloc] init];
  UINavigationController *profileNav = [XYBaseNavigationController rootVC:profileVC translationScale:NO];
  profileNav.gk_openSystemNavHandle = YES;
  
  
    
  NSArray *viewControllers = @[
                               homeNav,
                               timelineNav,
                               featuredNav,
                               friendsNav,
                               profileNav
                               ];
  
  return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
  NSDictionary *firstTabBarItemsAttributes = @{
  CYLTabBarItemTitle : @"首页",
  CYLTabBarItemImage : @"tabbar_hone_def",
  CYLTabBarItemSelectedImage : @"tabbar_hone_sel",
  };
  
  NSDictionary *secondTabBarItemsAttributes = @{
  CYLTabBarItemTitle : @"动态",
  CYLTabBarItemImage : @"tabbar_laoxianhui_def",
  CYLTabBarItemSelectedImage : @"tabbar_laoxianhui_sel",
  };
  
  NSDictionary *thirdTabBarItemsAttributes = @{
  CYLTabBarItemTitle : @"短视频",
  CYLTabBarItemImage : @"tabbar_jinxuang_def",
  CYLTabBarItemSelectedImage : @"tabbar_jinxuang_sel",
  };
  
  NSDictionary *forthTabBarItemsAttributes = @{
  CYLTabBarItemTitle : @"好友",
  CYLTabBarItemImage : @"tabbar_haoyou_def",
  CYLTabBarItemSelectedImage : @"tabbar_haoyou_sel",
  };
  
  NSDictionary *fifthTabBarItemsAttributes = @{
  CYLTabBarItemTitle : @"我的",
  CYLTabBarItemImage : @"tabbar_my_def",
  CYLTabBarItemSelectedImage : @"tabbar_my_sel",
  };
  
    NSArray *tabBarItemsAttributes = @[
                                       firstTabBarItemsAttributes,
                                       secondTabBarItemsAttributes,
                                       thirdTabBarItemsAttributes,
                                       forthTabBarItemsAttributes,
                                       fifthTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}

- (void)customizeTabBarAppearance {
    
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSFontAttributeName] = AdaptedFont(XYFont_B);
    normalAttrs[NSForegroundColorAttributeName] = ColorHex(XYTextColor_5B5B5B);
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = ColorHex(XYTextColor_FF5672);
    
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:ColorHex(XYThemeColor_B)];

}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    
    if ([control cyl_isTabButton]) {
        animationView = [control cyl_tabImageView];
    }
    
    if ([control cyl_isPlusButton]) {
        animationView = CYLExternPlusButton.imageView;
    }
    
    [self addScaleAnimationOnView:animationView repeatCount:1];
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.duration = 1;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}
@end
