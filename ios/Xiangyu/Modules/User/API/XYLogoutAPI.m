//
//  XYLogoutAPI.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/16.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYLogoutAPI.h"

@implementation XYLogoutAPI
{
    NSNumber *userId_;
}
- (instancetype)initWithUserId:(NSNumber *)userId {
    if (self = [super init]) {
        userId_ = userId;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/Account/SignOut";
}

- (id)requestParameters {
    return @{
        @"userId": userId_ ?: @(0),
    };
}
@end
