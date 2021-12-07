//
//  XYModifyPwdAPI.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/16.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseAPI.h"

@interface XYModifyPwdAPI : XYBaseAPI

- (instancetype)initWithNew:(NSString *)newpwd old:(NSString *)old;

@end
