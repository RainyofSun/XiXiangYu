//
//  XYProfileInfoAPI.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYProfileInfoAPI.h"

@implementation XYProfileInfoAPI
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
    return @"api/v1/User/GetMyInfo";
}

- (id)requestParameters {
  return @{@"userId" : userId_ ?: @(0)};
}
//
@end
@implementation XYUpdateDetailAPI
{
  NSNumber *userId_;
  NSDictionary *data_;
}
- (instancetype)initWithUserId:(NSNumber *)userId data:(nonnull NSDictionary *)data{
    if (self = [super init]) {
      userId_ = userId;
      data_ = data;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/User/UpdateDetail";
}

- (id)requestParameters {
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  if (data_) {
    [dic setDictionary:data_];
  }
 
  [dic setValue:userId_ ?: @(0) forKey:@"userId"];
  
  
  return dic;
}

@end
