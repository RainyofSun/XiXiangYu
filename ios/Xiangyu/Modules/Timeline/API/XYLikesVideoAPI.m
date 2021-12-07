//
//  XYLikesVideoAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYLikesVideoAPI.h"

@implementation XYLikesVideoAPI
{
  NSNumber *userId_;
  NSNumber *isMyQuery_;
  NSUInteger page_;
}

- (instancetype)initWithUserId:(NSNumber *)userId isMyQuery:(NSNumber *)isMyQuery page:(NSUInteger)page {
    if (self = [super init]) {
      userId_ = userId;
      isMyQuery_ = isMyQuery;
      page_ = page;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/ShortVideo/GetMyFabulousVideo";
}

- (id)requestParameters {
    return @{
            @"userId": userId_ ?: @(0),
            @"isMyQuery": isMyQuery_ ?: @(NO),
            @"page":@{
                @"pageIndex": @(page_),
                @"pageSize":@(20)
            }
            };
}
@end
