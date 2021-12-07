//
//  XYDeleteVideoAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYDeleteVideoAPI.h"

@implementation XYDeleteVideoAPI
{
  NSNumber *userId_;
  NSNumber *videoId_;
}

- (instancetype)initWithUserId:(NSNumber *)userId videoId:(NSNumber *)videoId {
    if (self = [super init]) {
      userId_ = userId;
      videoId_ = videoId;
    }
    return self;
}

- (NSString *)requestMethod {
    return @"api/v1/ShortVideo/DelVideo";
}

- (id)requestParameters {
    return @{
            @"userId": userId_ ?: @(0),
            @"id": videoId_ ?: @(0),
            };
}
@end
