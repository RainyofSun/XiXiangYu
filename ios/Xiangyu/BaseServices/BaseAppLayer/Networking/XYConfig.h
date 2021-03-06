//
//  XYConfig.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *XYDefaultGeneralErrorString;
FOUNDATION_EXPORT NSString *XYDefaultFrequentRequestErrorString;
FOUNDATION_EXPORT NSString *XYDefaultNetworkNotReachableString;

@interface XYConfig : NSObject<NSCopying>

/**
 *  出现网络请求时，为了给用户比较好的用户体验，而使用的错误提示文字
 *  默认为：XYDefaultGeneralErrorString
 */
@property (nonatomic, copy) NSString *generalErrorTypeStr;

/**
 *  用户频繁发送同一个请求，使用的错误提示文字
 *  默认为：XYDefaultFrequentRequestErrorString
 */
@property (nonatomic, copy) NSString *frequentRequestErrorStr;

/**
 *  网络请求开始时，会先检测相应网络域名的Reachability，如果不可达，则直接返回该错误文字
 *  默认为：XYDefaultNetworkNotReachableString
 */
@property (nonatomic, copy) NSString *networkNotReachableErrorStr;

/**
 *  出现网络请求错误时，是否在请求错误的文字后加上(code)
 *  默认为：YES
 */
@property (nonatomic, assign) BOOL isErrorCodeDisplayEnabled;

/**
 *  修改的baseUrlStr
 */
@property (nonatomic, copy, nullable) NSString *baseUrlStr;

/**
 *  UserAgent
 */
@property (nonatomic, copy, nullable) NSString *userAgent;

/**
 *  每个Host的最大连接数
 *  默认为2
 */
@property (nonatomic, assign) NSUInteger maxHttpConnectionPerHost;

/**
 *  NetworkingActivityIndicator
 *  Default by YES
 */
@property (nonatomic, assign) BOOL isNetworkingActivityIndicatorEnabled;

@end
NS_ASSUME_NONNULL_END
