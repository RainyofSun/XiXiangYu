//
//  NSBundle+Extension.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/13.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject (Extension)

- (id)toSafeValue {
  if (self == nil) {
    return nil;
  }
  if ([self isKindOfClass:[NSNull class]]) {
    return @"";
  }
  
  return self;
}

- (instancetype)toSafeValueOfClass:(Class)cls {
  if (self == nil) {
    return nil;
  }
  
  if (![self isKindOfClass:cls] || [self isKindOfClass:[NSNull class]]) {
    return nil;
  }
  
  if ([self isKindOfClass:[NSString class]]) {
    return ((NSString *)self).isNotBlank ? self : @"";
  }
  
  return self;
}

@end
