//
//  XYAuthAPI.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYAuthAPI.h"

@implementation XYAuthAPI
{
  NSDictionary *data_;
}

- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super init]) {
      data_ = data;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/User/SubmitAuth";
}

- (id)requestParameters {
  return data_ ?: @{};
}
@end
