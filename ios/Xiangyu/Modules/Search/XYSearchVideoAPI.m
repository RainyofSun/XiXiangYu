//
//  XYTimelineVideoAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYSearchVideoAPI.h"

@implementation XYSearchAuthorVideoAPI
{
  NSNumber *userId_;
  NSString *keyword_;
  NSUInteger page_;
}

- (instancetype)initWithUserId:(NSNumber *)userId keyword:(NSString *)keyword page:(NSUInteger)page {
    if (self = [super init]) {
      userId_ = userId;
      keyword_ = keyword;
      page_ = page;
    }
    return self;
}

- (NSString *)requestMethod {
    return @"api/v1/ShortVideo/SearchAuthor";
}

- (id)requestParameters {
    return @{
            @"userId": userId_ ?: @(0),
            @"keyword": keyword_ ?: @"",
            @"page":@{
                @"pageIndex": @(page_),
                @"pageSize":@(10)
            }
            };
}
@end

@implementation XYSearchProductVideoAPI
{
  NSNumber *userId_;
  NSString *keyword_;
  NSUInteger page_;
}

- (instancetype)initWithUserId:(NSNumber *)userId keyword:(NSString *)keyword page:(NSUInteger)page {
    if (self = [super init]) {
      userId_ = userId;
      keyword_ = keyword;
      page_ = page;
    }
    return self;
}

- (NSString *)requestMethod {
    return @"api/v1/ShortVideo/SearchVideo";
}

- (id)requestParameters {
    return @{
            @"userId": userId_ ?: @(0),
            @"keyword": keyword_ ?: @"",
            @"page":@{
                @"pageIndex": @(page_),
                @"pageSize":@(10)
            }
            };
}
@end
