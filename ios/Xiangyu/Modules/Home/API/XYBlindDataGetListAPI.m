//
//  XYBlindDataGetListAPI.m
//  Xiangyu
//
//  Created by Kang on 2021/6/29.
//
//------made in china-------
/**   The code comes frome breakfly
 *
 *       ┏┓　　 ┏┓
 *     ┏━┛┻━━━━┛┻┓
 * 　　┃　  　━　 ┃
 * 　　┃ 　 ^    ^ ┃
 * 　　┃　　　 ┻　 ┃
 * 　　┗━━━━━━━━━┛
 *
 * --------萌萌哒-------
 */
#import "XYBlindDataGetListAPI.h"

@implementation XYBlindDataGetListAPI
{
  NSDictionary *data_;
  NSUInteger page_;
}
- (instancetype)initWithData:(NSDictionary *)data page:(NSUInteger)page {
    if (self = [super init]) {
      data_ = data;
      page_ = page;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/BlindDate/GetQueryList";
}

- (id)requestParameters {
  
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  if (data_) {
    [dic addEntriesFromDictionary:data_];
  }
  
  [dic addEntriesFromDictionary:@{
    @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
    @"sex": [[XYUserService service] fetchLoginUser].sex.integerValue ==2?@(2):@(1),
    @"page":@{
        @"pageIndex": @(page_),
        @"pageSize":@(20)
    }
    }];
    return dic;
}
@end
@implementation XYBlindDataGetMyListAPI
{
  NSDictionary *data_;
  NSUInteger page_;
}
- (instancetype)initWithData:(NSDictionary *)data page:(NSUInteger)page {
    if (self = [super init]) {
      data_ = data;
      page_ = page;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/BlindDate/GetMyList";
}

- (id)requestParameters {
  
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  if (data_) {
    [dic addEntriesFromDictionary:data_];
  }
  
  [dic addEntriesFromDictionary:@{
    @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
    @"sex": [[XYUserService service] fetchLoginUser].sex.integerValue ==2?@(1):@(2),
    @"page":@{
        @"pageIndex": @(page_),
        @"pageSize":@(20)
    }
    }];
    return dic;
}
@end
