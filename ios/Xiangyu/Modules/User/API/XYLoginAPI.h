//
//  XYLoginAPI.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseAPI.h"

@class XYLoginModel;
@interface XYLoginAPI : XYBaseAPI

- (instancetype)initWithLoginParams:(XYLoginModel *)params;

@end
