//
//  XYBlindInfoAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYBlindInfoAPI.h"

@implementation XYBlindInfoAPI
{
  NSNumber *userId_;
  NSNumber *blindId_;
}

- (instancetype)initWithUserId:(NSNumber *)userId blindId:(NSNumber *)blindId {
    if (self = [super init]) {
      userId_ = userId;
      blindId_ = blindId;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/BlindDate/GetQueryDetail";
}

- (id)requestParameters {
    return @{
            @"userId": userId_ ?: @(0),
            @"id": blindId_ ?: @(0),
            };
}
@end
