//
//  XYBaseNavigationController.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/29.
//

#import "XYBaseNavigationController.h"

@interface XYBaseNavigationController ()

@end

@implementation XYBaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  if (self.viewControllers.count > 0) {
    viewController.hidesBottomBarWhenPushed = YES;
  } else {
      viewController.hidesBottomBarWhenPushed = NO;
  }
  [super pushViewController:viewController animated:animated];
}

@end
