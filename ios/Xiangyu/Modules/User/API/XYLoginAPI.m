//
//  XYLoginAPI.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYLoginAPI.h"
#import "XYLoginModel.h"

@implementation XYLoginAPI
{
    XYLoginModel *requestParams_;
}
- (instancetype)initWithLoginParams:(XYLoginModel *)params {
    if (self = [super init]) {
        requestParams_ = params;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/User/Login";
}

- (id)requestParameters {
    return @{@"mobile": requestParams_.mobile ?: @"",
             @"code": requestParams_.checkCode ?: @"",
             };
}
@end
