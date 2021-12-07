//
//  XYGetBannerListAPI.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import "XYGetBannerListAPI.h"

@implementation XYGetBannerListAPI
{
  NSNumber *showType_;
}
- (instancetype)initWithshowType:(NSNumber *)showType {
    if (self = [super init]) {
      showType_ = showType;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Platform/GetBannerList";
}

- (id)requestParameters {
  return @{@"showType":showType_ ?: @(0)};
}

@end
