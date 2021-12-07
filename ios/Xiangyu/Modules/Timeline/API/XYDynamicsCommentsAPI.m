//
//  XYDynamicsCommentsAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYDynamicsCommentsAPI.h"

@implementation XYDynamicsCommentsAPI
{
  NSNumber *dynamicId_;
  NSUInteger page_;
}
- (instancetype)initWithDynamicId:(NSNumber *)dynamicId page:(NSUInteger)page {
    if (self = [super init]) {
      dynamicId_ = dynamicId;
      page_ = page;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Dynamic/GetCommentList";
}

- (id)requestParameters {
    return @{
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            @"dynamicId": dynamicId_,
            @"page":@{
                @"pageIndex": @(page_),
                @"pageSize":@(20)
            }
            };
}
@end
