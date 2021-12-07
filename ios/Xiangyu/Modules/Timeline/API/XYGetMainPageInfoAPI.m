//
//  XYGetMainPageInfoAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYGetMainPageInfoAPI.h"

@implementation XYGetMainPageInfoAPI
{
  NSNumber *userId_;
}

- (instancetype)initWithUserId:(NSNumber *)userId {
    if (self = [super init]) {
      userId_ = userId;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/ShortVideo/GetHisPage";
}

- (id)requestParameters {
    return @{
            @"destUserId": userId_ ?: @(0),
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            };
}
@end
