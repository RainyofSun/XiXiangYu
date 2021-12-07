//
//  XYFetchCheckCodeAPI.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/7.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYFetchCheckCodeAPI.h"

@implementation XYFetchCheckCodeAPI
{
    NSString *mobile_;
    XYCheckCodeType type_;
}
- (instancetype)initWithMobile:(NSString *)mobile type:(XYCheckCodeType)type {
    if (self = [super init]) {
        mobile_ = mobile;
        type_ = type;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/User/SendSms";
}

- (id)requestParameters {
    return @{@"type": @(type_), @"phone": mobile_ ?: @""};
}

@end
