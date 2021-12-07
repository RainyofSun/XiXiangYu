//
//  XYUpdateLocationAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYUpdateLocationAPI.h"

@implementation XYUpdateLocationAPI
{
  NSNumber *userId_;
  NSNumber *latitude_;
  NSNumber *longitude_;
}
- (instancetype)initWithUserId:(NSNumber *)userId latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude {
    if (self = [super init]) {
      userId_ = userId;
      latitude_ = latitude;
      longitude_ = longitude;
    }
    return self;
}

- (NSString *)requestMethod {
    return @"api/v1/User/UpdatePosition";
}

- (id)requestParameters {
  return @{@"userId":userId_ ?: @(0),@"latitude":latitude_ ?: @(0.00),@"longitude":longitude_ ?: @(0.00)};
}

@end
