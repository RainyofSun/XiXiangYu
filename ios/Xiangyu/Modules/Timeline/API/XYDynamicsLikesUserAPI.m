//
//  XYDynamicsLikesUserAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYDynamicsLikesUserAPI.h"

@implementation XYDynamicsLikesUserAPI
{
    NSNumber *dynamicId_;
  NSInteger page_;
}

- (instancetype)initWithDynamicId:(NSNumber *)dynamicId page:(NSInteger)page {
    if (self = [super init]) {
      dynamicId_ = dynamicId;
      page_ = page;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Dynamic/GetFabulousList";
}

- (id)requestParameters {
    return @{
      
            @"dynamicId": dynamicId_ ?: @(0),
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            @"page":@{
                @"pageIndex": @(page_),
                @"pageSize":@(20)
            }
            };
}
@end
