//
//  XYBlindGetGiftListAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYBlindGetGiftListAPI.h"

@implementation XYBlindGetGiftListAPI
{
  NSNumber *userId_;
  NSNumber *blindId_;
}

- (instancetype)initWithUserId:(NSNumber *)userId {
    if (self = [super init]) {
      userId_ = userId;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Gift/GetMyGiftList";
}

- (id)requestParameters {
    return @{
            @"userId": userId_ ?: @(0),
            @"queryType": @(2),
            @"page":@{
                @"pageIndex": @(1),
                @"pageSize":@(4)
            }
            };
}
@end
@implementation XYGetGiftMesAPI
{
  NSString *orderNo_;
}
- (instancetype)initWithOrderId:(NSString *)orderId{

  if (self = [super init]) {
    orderNo_ = orderId;
  }
  return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Gift/GetMsg";
}

- (id)requestParameters {
    return @{
            @"orderNo": orderNo_ ?: @(0),
            };
}
-(XYRequestMethodType)apiRequestMethodType{
  return XYRequestMethodTypeGET;
}
@end
@implementation XYProfessGetMesAPI

{
  NSString *orderNo_;
}
- (instancetype)initWithOrderId:(NSString *)orderId{

  if (self = [super init]) {
    orderNo_ = orderId;
  }
  return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Profess/GetMsg";
}

- (id)requestParameters {
    return @{
            @"orderNo": orderNo_ ?: @(0),
            };
}
-(XYRequestMethodType)apiRequestMethodType{
  return XYRequestMethodTypeGET;
}
@end
