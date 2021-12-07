//
//  XYDynamicsFabulousAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYDynamicsFabulousAPI.h"

@implementation XYDynamicsFabulousAPI
{
  NSNumber *dynamicId_;
}
- (instancetype)initWithDynamicId:(NSNumber *)dynamicId {
    if (self = [super init]) {
      dynamicId_ = dynamicId;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Dynamic/DynamicFabulous";
}

- (id)requestParameters {
    return @{
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            @"dynamicId": dynamicId_ ?: @(0),
            };
}
@end
