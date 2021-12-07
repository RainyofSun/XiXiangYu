//
//  XYBindPhoneViewController.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/24.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "GKNavigationBarViewController.h"
#import "XYBindPhoneView.h"

@interface XYBindPhoneViewController : GKNavigationBarViewController

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *thirdToken;

@property (nonatomic,copy) NSString *thirdId;

@property (nonatomic,assign) BindPhoneType bindType;

@end
