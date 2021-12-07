//
//  XYProfessGetProfess.m
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
#import "XYProfessGetProfess.h"

@implementation XYProfessGetProfess
- (NSString *)requestMethod {
    return @"api/v1/Profess/GetProfess";
}
- (id)requestParameters {
    return @{
            @"userId":  [XYUserService service].fetchLoginUser.userId ?: @"",
            };
}
@end

@implementation XYProfessQueryXdList
{
  NSNumber *opType_;
  NSUInteger page_;
}
- (instancetype)initWithOpType:(NSNumber *)opType page:(NSInteger)page{
  if (self = [super init]) {
    opType_ = opType;
    page_ = page;
  }
  return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Profess/QueryXdList";
}
- (id)requestParameters {
    return @{
            @"userId":  [XYUserService service].fetchLoginUser.userId ?: @"",
            @"opType":opType_?:@(0),
            @"page":@{
                @"pageIndex": @(page_),
                @"pageSize":@(20)
            }
            };
}
@end
