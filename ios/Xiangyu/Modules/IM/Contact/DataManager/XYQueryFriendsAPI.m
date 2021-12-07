//
//  XYQueryFriendsAPI.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYQueryFriendsAPI.h"

@implementation XYQueryFriendsAPI
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
    return @"api/v1/User/GetFriends";
}

- (id)requestParameters {
  return @{@"userId" : userID_ ?: @(0),
           @"province" : reqData_.province ?: @"",
           @"city" : reqData_.city ?: @"",
           @"area" : reqData_.area ?: @"",
           @"town" : reqData_.town ?: @"",
           @"oneIndustry" : reqData_.oneIndustry ?: @(0),
           @"twoIndustry" : reqData_.twoIndustry ?: @(0),
           @"startAge" : reqData_.startAge ?: @(0),
           @"endAge" : reqData_.endAge ?: @(0),
           @"keyword" : reqData_.keyword ?: @"",
           @"middleSchool" : reqData_.middleSchool ?: @(0),
           @"highSchool" : reqData_.highSchool ?: @(0),
           @"page" : @{@"pageIndex":@(page_),@"pageSize":@(10)},
  };
}
@end
