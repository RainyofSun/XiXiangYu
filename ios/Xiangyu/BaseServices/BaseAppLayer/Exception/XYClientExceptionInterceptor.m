//
//  XYClientExceptionInterceptor.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/24.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYClientExceptionInterceptor.h"
#import "XYAPIManager.h"
#import "XYNetworkErrorObserverProtocol.h"

static XYClientExceptionInterceptor *instance = nil;

@interface XYClientExceptionInterceptor () <XYNetworkErrorObserverProtocol>

@end

@implementation XYClientExceptionInterceptor
#pragma mark - Init
+ (XYClientExceptionInterceptor *)interceptor {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)activate {
    [[XYAPIManager sharedXYAPIManager] registerNetworkErrorObserver:self];
}

#pragma mark - XYNetworkErrorObserverProtocol
- (void)networkHTTPErrorWithErrorInfo:(nonnull NSError *)error {
    
    switch (error.code) {
        case NSURLErrorCannotConnectToHost:
            [XYToast showNotReachable];
            break;
        case NSURLErrorTimedOut:
            [XYToast showWeakNetwork];
            break;
        default:
            XYToastText(error.userInfo[NSLocalizedDescriptionKey]);
            break;
    }
}

- (void)networkSystemErrorWithErrorInfo:(nonnull XYError *)error {
  if ([error.code isEqualToString:@"401"]) {
    [[NSNotificationCenter defaultCenter] postNotificationName:XYKickoutNotificationName object:nil];
  } else {
    if (![error.msg isEqualToString:@"请开启定位后重试"]) {
      XYToastText(error.msg);
    }
  }
}
@end
