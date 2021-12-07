//
//  XYFollowAPI.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYFollowAPI.h"

@implementation XYFollowAPI
{
  NSNumber *userId_;
  NSNumber *destUserId_;
  NSNumber *operation_;
  NSNumber *source_;
  NSNumber *dyId_;
}
- (instancetype)initWithUserId:(NSNumber *)userId destUserId:(NSNumber *)destUserId operation:(NSNumber *)operation source:(NSNumber *)source dyId:(NSNumber *)dyId {
    if (self = [super init]) {
      userId_ = userId;
      destUserId_ = destUserId;
      operation_ = operation;
      source_ = source;
      dyId_ = dyId;
    }
    return self;
}

- (NSString *)requestMethod {
    return @"api/v1/User/SetFollow";
}

- (id)requestParameters {
  return @{@"userId":userId_ ?: @(0),
           @"destUserId":destUserId_ ?: @(0),
           @"operation":operation_ ?: @(0),
           @"source":source_ ?: @(-10),
           @"dyId":dyId_ ?: @(0),
          };
}
@end
