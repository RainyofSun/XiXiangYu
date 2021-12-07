//
//  XYNearbyPeopleAPI.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYNearbyPeopleAPI.h"

@implementation XYNearbyPeopleAPI
{
  NSNumber *userID_;
  NSUInteger page_;
  XYFriendDataReq *reqData_;
}
- (instancetype)initWithUserId:(NSNumber *)userID reqData:(XYFriendDataReq *)reqData page:(NSUInteger)page {
    if (self = [super init]) {
      userID_ = userID;
      page_ = page;
      reqData_ = reqData;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/User/GetPeopleNearby";
}

- (id)requestParameters {
  return @{@"userId" : userID_ ?: @(0),
           @"latitude" : reqData_.latitude ?: @(0),
           @"longitude" : reqData_.longitude ?: @(0),
           @"province" : reqData_.province ?: @"",
           @"city" : reqData_.city ?: @"",
           @"area" : reqData_.area ?: @"",
           @"town" : reqData_.town ?: @"",
           @"dwellCity" : reqData_.dwellCity ?: @"",
           @"oneIndustry" : reqData_.oneIndustry ?: @(0),
           @"twoIndustry" : reqData_.twoIndustry ?: @(0),
           @"middleSchool" : reqData_.middleSchool ?: @(0),
           @"highSchool" : reqData_.highSchool ?: @(0),
           @"sex" : reqData_.sex ?: @(-10),
           @"page" : @{@"pageIndex":@(page_),@"pageSize":@(10)},
  };
}
@end
