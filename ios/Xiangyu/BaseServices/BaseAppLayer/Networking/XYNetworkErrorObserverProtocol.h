//
//  XYNetworkErrorObserverProtocol.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYError.h"

@protocol XYNetworkErrorObserverProtocol <NSObject>

/**
 *  XY发生HTTP层网络错误时，通过该函数进行监控回调
 *
 *  @param error 网络错误的Error
 */
- (void)networkHTTPErrorWithErrorInfo:(nonnull NSError *)error;

/**
 *  XY发生业务系统层网络错误时，通过该函数进行监控回调
 *
 *  @param error 网络错误的Error
 */
- (void)networkSystemErrorWithErrorInfo:(nonnull XYError *)error;
@end
