//
//  XYDynamicsLikesUserAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYDeleteDynamicsAPI.h"

@implementation XYDeleteDynamicsAPI
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
    return @"api/v1/Dynamic/DelMyDynamic";
}

- (id)requestParameters {
    return @{
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            @"id": dynamicId_ ?: @(0),
            };
}
@end
