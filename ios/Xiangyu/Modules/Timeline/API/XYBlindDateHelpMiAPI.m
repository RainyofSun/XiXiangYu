//
//  XYBlindDateHelpMiAPI.m
//  Xiangyu
//
//  Created by Kang on 2021/7/1.
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
#import "XYBlindDateHelpMiAPI.h"

@implementation XYBlindDateHelpMiAPI
{
  NSNumber *Id_;
}
- (instancetype)initWithId:(NSNumber *)Id {
    if (self = [super init]) {
     Id_ = Id;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/BlindDate/HelpMi";
}

- (id)requestParameters {
    return @{
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            @"id": Id_ ?: @(0),
            };
}
@end
///api/v1/BlindDate/GetProfessConf

@implementation XYBlindDateProfessConfAPI
- (NSString *)requestMethod {
    return @"api/v1/BlindDate/GetProfessConf";
}

- (id)requestParameters {
    return @{
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            };
}
@end
@implementation XYBlindDateCreateProfessAPI
{
  NSNumber *blindDateId_;
  NSNumber *destUserId_;
  NSString *content_;
}
- (instancetype)initWithId:(NSNumber *)blindDateId destUserId:(NSNumber *)destUserId content:(NSString *)content{
  if (self = [super init]) {
    blindDateId_ = blindDateId;
    destUserId_ = destUserId;
    content_ = content;
  }
  return self;
}

- (NSString *)requestMethod {
    return @"api/v1/BlindDate/CreateProfess";
}
- (id)requestParameters {
    return @{
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            @"destUserId": destUserId_ ?: @(0),
            @"blindDateId": blindDateId_ ?: @(0),
            @"content": content_ ?: @"",
            };
}
@end

@implementation XYBlindDateGetProfessListAPI
{

  NSUInteger page_;
}
- (instancetype)initWithPage:(NSInteger)page{
  if (self = [super init]) {
  
    page_ = page;
  }
  return self;
}
- (NSString *)requestMethod {
    return @"api/v1/BlindDate/GetProfessList";
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
///
