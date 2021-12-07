//
//  XYImageTokenAPI.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/25.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYImageTokenAPI.h"

@implementation XYImageTokenAPI
{
  NSString *key_;
}
- (instancetype)initWithKey:(NSString *)key {
  if (self = [super init]) {
    key_ = key;
  }
  return self;
}

- (NSString *)requestMethod {
    return @"api/v1/Platform/GetQiNiuToken";
}

- (id)requestParameters {
  return @{@"key":key_ ?: @""};
}

@end
