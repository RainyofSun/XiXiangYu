//
//  XYBindAccountAPI.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBindAccountAPI.h"

@implementation XYBindAccountAPI
{
  NSUInteger type_;
  NSString *relateId_;
  NSString *mobile_;
  NSString *code_;
  NSString *thirdToken_;
}
- (instancetype)initWithType:(NSUInteger)type
                    relateId:(NSString *)relateId
                  thirdToken:(NSString *)thirdToken
                      mobile:(NSString *)mobile
                        code:(NSString *)code {
    if (self = [super init]) {
      type_ = type;
      relateId_ = relateId;
      mobile_ = mobile;
      thirdToken_=thirdToken;
      code_ = code;
    }
    return self;
}
- (NSString *)requestMethod {
  return @"api/v1/User/BindAccount";
        //  @"api​/v1​/User​/BindAccount";
  //"api/v1/User/BindAccount"
  //"api​/v1​/User​/BindAccount"

  
}

- (id)requestParameters {
    return @{@"thirdType": @(type_) ?: @(0),
             @"thirdId": relateId_ ?: @"",
             @"thirdToken": thirdToken_ ?: @"",
             @"mobile": mobile_ ?: @"",
             @"code": code_ ?: @"",
             };
}
@end
