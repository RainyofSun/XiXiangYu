//
//  XYWechatLoginAPI.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYWechatLoginAPI.h"

@implementation XYWechatLoginAPI
{
    NSString *token_;
}
- (instancetype)initWithToken:(NSString *)token {
    if (self = [super init]) {
      token_ = token;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/User/WeChatLogin";
}

- (id)requestParameters {
    return @{@"openId": token_ ?: @"",
             };
}
@end
