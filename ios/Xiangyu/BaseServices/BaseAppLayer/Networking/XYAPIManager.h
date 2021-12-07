//
//  XYAPIManager.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYBaseAPI;
@class XYConfig;
@class XYAPIBatchAPIRequests;
@protocol XYNetworkErrorObserverProtocol;

@interface XYAPIManager : NSObject

@property (nonatomic, strong, nonnull) XYConfig *configuration;

// 单例
+ (nullable XYAPIManager *)sharedXYAPIManager;

/**
 *  发送API请求
 *
 *  @param api 要发送的api
 */
- (void)sendAPIRequest:(nonnull XYBaseAPI  *)api;

/**
 *  取消API请求
 *
 *  @description
 *      如果该请求已经发送或者正在发送，则无法取消
 *
 *  @param api 要取消的api
 */
- (void)cancelAPIRequest:(nonnull XYBaseAPI  *)api;

/**
 *  发送一系列API请求
 *
 *  @param apis 待发送的API请求集合
 */
- (void)sendBatchAPIRequests:(nonnull XYAPIBatchAPIRequests *)apis;

/**
 *  添加网络传输错误时的监控observer
 *
 *  @param observer 遵循XYNetworkingErrorObserverProtocol的observer
 */
- (void)registerNetworkErrorObserver:(nonnull id<XYNetworkErrorObserverProtocol>)observer;

/**
 *  删除网络传输错误时的监控observer
 *
 *  @param observer 遵循XYNetworkingErrorObserverProtocol的observer
 */
- (void)removeNetworkErrorObserver:(nonnull id<XYNetworkErrorObserverProtocol>)observer;

@end
