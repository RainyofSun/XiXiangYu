//
//  XYDynamicsAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYDynamicsAPI.h"

@implementation XYRecommendDynamicsAPI
{
    NSString *province_;
    NSString *city_;
    NSUInteger page_;
    NSUInteger type_;
  NSNumber *subjectId_;
}
- (instancetype)initWithType:(NSUInteger)type
                     provice:(NSString *)province
                        city:(NSString *)city
                        page:(NSUInteger)page
                   subjectId:(NSNumber*)subjectId
{
    if (self = [super init]) {
      province_ = province;
      city_ = city;
      page_ = page;
      type_ = type;
      subjectId_ = subjectId;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Dynamic/GetDynamicList";
}

- (id)requestParameters {
  
  NSDictionary *dic = @{
    @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
    @"queryType": @(type_),
    @"dwellProvince":province_ ?: @"",
    @"subjectId":subjectId_?:@(0),
    @"dwellCity":city_ ?: @"",
    @"page":@{
        @"pageIndex": @(page_),
        @"pageSize":@(20)
    }
    };
  
  return dic;
}
@end

@implementation XYMyDynamicsAPI
{
  NSNumber *userId_;
  NSUInteger page_;
}
- (instancetype)initWithUserId:(NSNumber *)userId page:(NSUInteger)page {
    if (self = [super init]) {
      userId_ = userId;
      page_ = page;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Dynamic/GetMyDynamicList";
}

- (id)requestParameters {
    return @{
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            @"page":@{
                @"pageIndex": @(page_),
                @"pageSize":@(20)
            }
            };
}
@end

@implementation XYOthersDynamicsAPI
{
  NSNumber *userId_;
  NSUInteger page_;
}
- (instancetype)initWithUserId:(NSNumber *)userId page:(NSUInteger)page {
    if (self = [super init]) {
      userId_ = userId;
      page_ = page;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Dynamic/GetHisPageDynList";
}

- (id)requestParameters {
    return @{
            @"destUserId": userId_ ?: @(0),
            @"page":@{
                @"pageIndex": @(page_),
                @"pageSize":@(20)
            }
            };
}
@end

