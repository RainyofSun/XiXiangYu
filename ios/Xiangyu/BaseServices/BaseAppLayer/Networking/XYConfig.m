//
//  XYConfig.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYConfig.h"
#import "XYAPIDefines.h"

NSString * XYDefaultGeneralErrorString            = @"服务器连接错误，请稍候重试呦~";
NSString * XYDefaultFrequentRequestErrorString    = @"请求太快喽, 请稍后重试呦~";
NSString * XYDefaultNetworkNotReachableString     = @"您的网络未连接，请连接网络后点击重试呦~";

@implementation XYConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.generalErrorTypeStr                  = XYDefaultGeneralErrorString;
        self.frequentRequestErrorStr              = XYDefaultFrequentRequestErrorString;
        self.networkNotReachableErrorStr          = XYDefaultNetworkNotReachableString;
        self.isNetworkingActivityIndicatorEnabled = YES;
        self.isErrorCodeDisplayEnabled            = YES;
        self.maxHttpConnectionPerHost             = MAX_HTTP_CONNECTION_PER_HOST;
        self.baseUrlStr = XY_SERVICE_HOST;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    XYConfig *config                  = [[XYConfig allocWithZone:zone] init];
    config.generalErrorTypeStr         = self.generalErrorTypeStr;
    config.frequentRequestErrorStr     = self.frequentRequestErrorStr;
    config.networkNotReachableErrorStr = self.networkNotReachableErrorStr;
    config.isErrorCodeDisplayEnabled   = self.isErrorCodeDisplayEnabled;
    config.baseUrlStr                  = self.baseUrlStr;
    config.userAgent                   = self.userAgent;
    config.maxHttpConnectionPerHost    = self.maxHttpConnectionPerHost;
    return config;
}

@end
