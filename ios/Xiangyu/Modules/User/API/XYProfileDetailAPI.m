//
//  XYProfileDetailAPI.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYProfileDetailAPI.h"

@implementation XYProfileDetailAPI
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
    return @"api/v1/User/GetDetail";
}

- (id)requestParameters {
  return @{@"userId" : userId_ ?: @(0)};
}
@end
