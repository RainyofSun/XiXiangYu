//
//  XYTabbarConfig.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/5/26.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYTabbarConfig : NSObject

+ (XYTabbarConfig *)sharedConfig;

- (void)releaseViewControllers;

@property (nonatomic, readonly, strong) CYLTabBarController *tabBarController;

@end
