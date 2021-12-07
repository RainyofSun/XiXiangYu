//
//  XYError.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/22.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYError.h"

@implementation XYError
+ (instancetype)clientErrorWithCode:(NSString *)code msg:(NSString *)msg {
    XYError *e = [[self alloc] init];
    e.code = code;
    e.msg = msg;
    return e;
}
@end

