//
//  XYPlatformDataAPI.m
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/18.
//

#import "XYPlatformDataAPI.h"

@implementation XYSwitchAPI

- (id)requestParameters {
  return @{};
}

- (XYRequestMethodType)apiRequestMethodType {
    return XYRequestMethodTypePOST;
}

- (NSString *)requestMethod {
    return @"api/v1/Platform/GetSwitch";
}

@end

@implementation XYCharacterAPI

- (XYRequestMethodType)apiRequestMethodType {
    return XYRequestMethodTypeGET;
}

- (NSString *)requestMethod {
    return @"json/character.json";
}

@end

@implementation XYPositionAPI

- (XYRequestMethodType)apiRequestMethodType {
    return XYRequestMethodTypeGET;
}

- (NSString *)requestMethod {
    return @"json/position.json";
}

@end

@implementation XYHeightAPI

- (XYRequestMethodType)apiRequestMethodType {
    return XYRequestMethodTypeGET;
}

- (NSString *)requestMethod {
    return @"json/height.json";
}

@end

@implementation XYDeuAPI

- (XYRequestMethodType)apiRequestMethodType {
    return XYRequestMethodTypeGET;
}

- (NSString *)requestMethod {
    return @"json/deu.json";
}

@end

@implementation XYSalaryAPI

- (XYRequestMethodType)apiRequestMethodType {
    return XYRequestMethodTypeGET;
}

- (NSString *)requestMethod {
    return @"json/salary.json";
}

@end

@implementation XYShopAPI

- (XYRequestMethodType)apiRequestMethodType {
    return XYRequestMethodTypeGET;
}

- (NSString *)requestMethod {
    return @"json/shop.json";
}

@end

@implementation XYIndustryAPI

- (XYRequestMethodType)apiRequestMethodType {
    return XYRequestMethodTypePOST;
}

- (NSString *)requestMethod {
    return @"api/v1/Platform/GetIndustryList";
}

@end

@implementation XYSchoolAPI
{
  NSString *provice_;
  NSString *city_;
  NSString *area_;
  NSNumber *type_;
}
- (instancetype)initWithProvice:(NSString *)provice
                           city:(NSString *)city
                           area:(NSString *)area
                           type:(NSNumber *)type {
  if (self = [super init]) {
    provice_ = provice;
    city_ = city;
    area_ = area;
    type_ = type;
  }
  return self;
}

- (id)requestParameters {
  return @{@"province":provice_ ?: @"",@"city":city_ ?: @"",@"area":area_ ?: @"", @"type":type_ ?: @(1)};
}

- (XYRequestMethodType)apiRequestMethodType {
    return XYRequestMethodTypePOST;
}

- (NSString *)requestMethod {
    return @"api/v1/Platform/GeSchoolList";
}

@end

@implementation XYRatesConfigAPI

{
  NSUInteger type_;
}
- (instancetype)initWithType:(NSUInteger)type {
  if (self = [super init]) {
    type_ = type;
  }
  return self;
}

- (id)requestParameters {
  return @{@"type":@(type_) ?: @(0)};
}

- (XYRequestMethodType)apiRequestMethodType {
    return XYRequestMethodTypePOST;
}

- (NSString *)requestMethod {
    return @"api/v1/Platform/GetRatesConfList";
}

@end

