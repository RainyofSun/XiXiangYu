//
//  WebViewController.h
//  HangZhan
//
//  Created by GQLEE on 2019/3/12.
//  Copyright © 2019年 GQLEE. All rights reserved.
//

#import "GKNavigationBarViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : GKNavigationBarViewController

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) NSString *dataDec;
@property (nonatomic, strong) NSString *type;

@end

NS_ASSUME_NONNULL_END
