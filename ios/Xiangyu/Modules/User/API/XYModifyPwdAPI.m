//
//  XYModifyPwdAPI.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/16.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYModifyPwdAPI.h"

@implementation XYModifyPwdAPI
{
    NSString *new_;
    NSString *old_;
}
- (instancetype)initWithNew:(NSString *)newpwd old:(NSString *)old {
    if (self = [super init]) {
        new_ = newpwd;
        old_ = old;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"service-user/password/update";
}

- (id)requestParameters {
    return @{
            @"old": old_ ?: @"",
            @"latest": new_ ?: @""
            };
}
@end
