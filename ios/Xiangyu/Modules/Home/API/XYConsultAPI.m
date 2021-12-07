//
//  XYConsultAPI.m
//  Xiangyu
//
//  Created by Kang on 2021/6/25.
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
#import "XYConsultAPI.h"

@implementation XYConsultAPI
{
  NSNumber *userId_;
  NSNumber *Id_;
}
- (instancetype)initWithUserId:(NSNumber *)userId Id:(NSNumber *)Id{
  if (self = [super init]) {
    userId_ = userId;
    Id_ = Id;
  }
  return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Consult/GetDetail";
}
- (id)requestParameters {
  return @{@"userId":userId_ ?: @(0),
           @"id":Id_ ?: @(0)
          };
}
@end
@implementation XYConsultCommentAPI

{
  NSNumber *userId_;
  NSNumber *Id_;
  NSString *content_;
}
- (instancetype)initWithUserId:(NSNumber *)userId Id:(NSNumber *)Id content:(NSString *)content{
  if (self = [super init]) {
    userId_ = userId;
    Id_ = Id;
    content_ = content;
  }
  return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Consult/Comment";
}
- (id)requestParameters {
  return @{@"userId":userId_ ?: @(0),
           @"consultId":Id_ ?: @(0),
           @"content":content_?:@"",
          };
}
-(XYRequestMethodType)apiRequestMethodType{
  return XYRequestMethodTypePOST;
}
@end
@implementation XYGetConsultCommentListAPI
{
  NSNumber *consultId_;
  NSUInteger page_;
}
- (instancetype)initWithConsultId:(NSNumber *)consultId page:(NSUInteger)page {
    if (self = [super init]) {
      consultId_ = consultId;
      page_ = page;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Consult/GetCommentList";
}

- (id)requestParameters {
    return @{
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            @"consultId": consultId_,
            @"page":@{
                @"pageIndex": @(page_),
                @"pageSize":@(20)
            }
            };
}
-(XYRequestMethodType)apiRequestMethodType{
  return XYRequestMethodTypePOST;
}
@end
@implementation XYConsultFabulousAPI
{
  NSNumber *consultId_;
}
- (instancetype)initWithConsultId:(NSNumber *)consultId {
    if (self = [super init]) {
      consultId_ = consultId;
   
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Consult/Fabulous";
}

- (id)requestParameters {
    return @{
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            @"consultId": consultId_,
      
            };
}
@end
