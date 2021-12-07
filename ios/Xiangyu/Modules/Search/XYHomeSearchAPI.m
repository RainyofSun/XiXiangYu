//
//  XYFollowAPI.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYHomeSearchAPI.h"

@implementation XYHomeSearchAPI
{
  NSNumber *userId_;
  NSString *words_;
}
- (instancetype)initWithUserId:(NSNumber *)userId words:(NSString *)words {
    if (self = [super init]) {
      userId_ = userId;
      words_ = words;
    }
    return self;
}

- (NSString *)requestMethod {
    return @"api/v1/User/HomeSearch";
}

- (id)requestParameters {
  return @{@"userId":userId_ ?: @(0),
           @"keyword":words_ ?: @"",
          };
}
@end
