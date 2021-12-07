//
//  XYSecurityPolicy.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYSecurityPolicy.h"
#import "AFNetworking.h"

@interface XYSecurityPolicy ()

@property (readwrite, nonatomic, assign) XYSSLPinningMode SSLPinningMode;

@end

@implementation XYSecurityPolicy

+ (instancetype)policyWithPinningMode:(XYSSLPinningMode)pinningMode {
    XYSecurityPolicy *securityPolicy = [[XYSecurityPolicy alloc] init];
    if (securityPolicy) {
        securityPolicy.SSLPinningMode           = pinningMode;
        securityPolicy.allowInvalidCertificates = NO;
        securityPolicy.validatesDomainName      = YES;
    }
    return securityPolicy;
}

@end
