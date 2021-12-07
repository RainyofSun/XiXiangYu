//
//  XYPrefectProfileAPI.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/7.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYPrefectProfileAPI.h"
#import "XYPerfectProfileModel.h"

@implementation XYPrefectProfileAPI
{
  XYPerfectProfileModel *requestParams_;
  NSNumber *userId_;
}
- (instancetype)initWithProfileParams:(XYPerfectProfileModel *)params userId:(NSNumber *)userId {
    if (self = [super init]) {
      requestParams_ = params;
      userId_ = userId;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/User/UpdateUser";
}

- (id)requestParameters {
  NSMutableDictionary *dict = requestParams_ ? ((NSDictionary *)(requestParams_.yy_modelToJSONObject)).mutableCopy : @{}.mutableCopy;
  [dict setValue:userId_ forKey:@"userId"];
  return dict.copy;
}
@end
