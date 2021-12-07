//
//  XYReceiveTaskAPI.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYReceiveTaskAPI.h"

@implementation XYReceiveTaskAPI
{
  NSNumber *userId_;
  NSNumber *taskId_;
}
- (instancetype)initWithUserId:(NSNumber *)userId taskId:(NSNumber *)taskId {
    if (self = [super init]) {
      userId_ = userId;
      taskId_ = taskId;
    }
    return self;
}

- (NSString *)requestMethod {
    return @"api/v1/Platform/ReceiveTask";
}

- (id)requestParameters {
  return @{@"userId":userId_ ?: @(0),
           @"taskId":taskId_ ?: @(0),
          };
}
@end
