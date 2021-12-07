//
//  XYHomePageAPI.m
//  Xiangyu
//
//  Created by dimon on 26/02/2021.
//

#import "XYHomePageAPI.h"

@implementation XYHomePageAPI
{
  NSNumber *userId_;
  NSString *dwellProvince_;
  NSString *dwellCity_;
}
- (instancetype)initWithUserId:(NSNumber *)userId dwellProvince:(NSString *)dwellProvince dwellCity:(NSString *)dwellCity {
    if (self = [super init]) {
      userId_ = userId;
      dwellProvince_ = dwellProvince;
      dwellCity_ = dwellCity;
    }
    return self;
}

- (NSString *)requestMethod {
    return @"api/v1/User/GetHomePage";
}

- (id)requestParameters {
  return @{@"userId":userId_ ?: @(0),@"dwellProvince":dwellProvince_ ?: @"",@"dwellCity":dwellCity_ ?: @""};
}
@end
