//
//  XYRecommendBlindAPI.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/27.
//

#import "XYRecommendBlindAPI.h"

@implementation XYRecommendBlindAPI
{
  NSNumber *userId_;
  NSNumber *sex_;
  NSNumber *latitude_;
  NSNumber *longitude_;
  NSString *dwellCity_;
}
- (instancetype)initWithUserId:(NSNumber *)userId sex:(NSNumber *)sex latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude dwellCity:(NSString *)dwellCity {
    if (self = [super init]) {
      userId_ = userId;
      sex_ = sex;
      latitude_ = latitude;
      longitude_ = longitude;
      dwellCity_ = dwellCity;
    }
    return self;
}

- (NSString *)requestMethod {
    return @"api/v1/BlindDate/GetQueryList";
}

- (id)requestParameters {
  return @{@"userId":userId_ ?: @(0),
           @"sex":sex_ ?: @(0),
           @"latitude":latitude_ ?: @(0.00),
           @"longitude":longitude_ ?: @(0.00),
           @"dwellCity":dwellCity_ ?: @"",
           @"page":@{@"pageIndex":@(1),@"pageSize":@(10)},
          };
}
@end
