//
//  XYAddFriendsResponeAPI.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYAddFriendsResponeAPI.h"

@implementation XYAddFriendsResponeAPI
{
  NSNumber *userID_;
  NSNumber *destUserId_;
}
- (instancetype)initWithUserId:(NSNumber *)userID destUserId:(NSNumber *)destUserId {
    if (self = [super init]) {
      userID_ = userID;
      destUserId_ = destUserId;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/User/EndFriend";
}

- (id)requestParameters {
  return @{@"userId" : userID_ ?: @(0),
           @"destUserId" : destUserId_ ?: @(0)};
}
@end
@implementation XYBlindDateReachObjAPI
{
  NSNumber *userID_;
  NSNumber *destUserId_;
}
- (instancetype)initWithUserId:(NSNumber *)userID destUserId:(NSNumber *)destUserId {
    if (self = [super init]) {
      userID_ = userID;
      destUserId_ = destUserId;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/BlindDate/ReachObj";
}

- (id)requestParameters {
  return @{@"userId" : userID_ ?: @(0),
           @"destUserId" : destUserId_ ?: @(0)};
}
@end
