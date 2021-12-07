//
//  XYQuerySubTownAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYQuerySubTownAPI.h"

@implementation XYQuerySubTownAPI
{
  NSNumber *cityCode_;
}

- (instancetype)initWithCityCode:(NSNumber *)cityCode {
    if (self = [super init]) {
      cityCode_ = cityCode;
    }
    return self;
}

- (NSString *)requestMethod {
    return @"api/v1/Platform/GetTownList";
}

- (id)requestParameters {
    return @{@"code": cityCode_ ?: @(0)};
}

@end

