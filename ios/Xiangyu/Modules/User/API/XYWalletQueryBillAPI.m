//
//  XYWalletQueryBillAPI.m
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
#import "XYWalletQueryBillAPI.h"

@implementation XYWalletQueryBillAPI
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
    return @"api/v1/Wallet/QueryBills";
}
- (id)requestParameters {
    return @{
            @"userId":  [XYUserService service].fetchLoginUser.userId ?: @"",
            @"page":@{
                @"pageIndex": @(page_),
                @"pageSize":@(20)
            }
            };
}
@end
//
@implementation XYWalletApplyCashAPI
{
  NSNumber *amt_;
  NSString *openId_;
  NSNumber *payChannel_;
}
- (instancetype)initWithAmt:(NSNumber*)amt openId:(NSString *)openId payChannel:(NSNumber *)payChannel{
  if (self = [super init]) {

    amt_ = amt;
    openId_ = openId;
    payChannel_ = payChannel;
  }
  return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Wallet/ApplyCash";
}
- (id)requestParameters {
    return @{
            @"userId":  [XYUserService service].fetchLoginUser.userId ?: @"",
            @"amt":amt_?:@(0),
            @"openId":openId_?:@"",
            @"payChannel":payChannel_?:@(0),
            };
}
@end
///api/v1/Wallet/GetOAuth2Url
@implementation XYWalletOAuth2UrlAPI
- (NSString *)requestMethod {
    return @"api/v1/Wallet/GetOAuth2Url";
}
-(XYRequestMethodType)apiRequestMethodType{
  return XYRequestMethodTypeGET;
}
@end
@implementation XYWalletSuperHeartCountAPI
- (NSString *)requestMethod {
    return @"api/v1/Wallet/GetSuperHeartCount";
}
- (id)requestParameters {
    return @{
            @"userId":  [XYUserService service].fetchLoginUser.userId ?: @"",
            
            };
}
@end
