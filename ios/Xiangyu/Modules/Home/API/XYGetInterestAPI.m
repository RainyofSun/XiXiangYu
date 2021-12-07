//
//  XYGetInterestAPI.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import "XYGetInterestAPI.h"

@implementation XYGetInterestAPI
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
    return @"api/v1/User/GetInterest";
}

- (id)requestParameters {
  return @{@"userId":userId_ ?: @(0)};
}

@end
