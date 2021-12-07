//
//  XYPlatSubjectGetListAPI.m
//  Xiangyu
//
//  Created by Kang on 2021/7/3.
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
#import "XYPlatSubjectGetListAPI.h"

@implementation XYPlatSubjectGetListAPI
{
  NSInteger page_;
}
- (instancetype)initWithPage:(NSInteger )page{
  if (self = [super init]) {
    page_ = page;
  }
  return self;
}
- (NSString *)requestMethod {
    return @"api/v1/PlatSubject/GetList";
}
- (id)requestParameters {
    return @{@"pageIndex": @(page_),
             @"pageSize":@(20)
             
    };
}
@end
@implementation XYPlatGetSubjectAPI{
  NSNumber *Id_;
}
- (instancetype)initWithId:(NSNumber *)Id{
  if (self = [super init]) {
   Id_ = Id;
  }
  return self;
}
- (NSString *)requestMethod {
    return @"api/v1/PlatSubject/GetSubject";
}
-(XYRequestMethodType)apiRequestMethodType{
  return XYRequestMethodTypeGET;
}
- (id)requestParameters {
    return @{
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            @"id": Id_ ?: @(0),
            };
}
@end
