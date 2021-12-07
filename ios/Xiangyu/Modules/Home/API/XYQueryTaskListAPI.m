//
//  XYQueryTaskListAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYQueryTaskListAPI.h"

@implementation XYQueryTaskListAPI
{
  NSNumber *userId_;
}
- (instancetype)initWithUserId:(NSNumber *)userId {
    if (self = [super init]) {
      userId_ = userId;
    }
    return self;
}

- (NSString *)requestMethod {
    return @"api/v1/Platform/GetTaskList";
}

- (id)requestParameters {
  return @{@"userId":userId_ ?: @(0)};
}

@end
