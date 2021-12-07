//
//  XYAPIBatchAPIRequests.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYBaseAPI;
@class XYAPIBatchAPIRequests;

@protocol XYAPIBatchAPIRequestsProtocol <NSObject>

/**
 *  Batch Requests 全部调用完成之后调用
 *
 *  @param batchApis batchApis
 */
- (void)batchAPIRequestsDidFinished:(nonnull XYAPIBatchAPIRequests *)batchApis;

@end

@interface XYAPIBatchAPIRequests : NSObject

/**
 *  Batch 执行的API Requests 集合
 */
@property (nonatomic, strong, readonly, nullable) NSMutableSet *apiRequestsSet;

/**
 *  Batch Requests 执行完成之后调用的delegate
 */
@property (nonatomic, weak, nullable) id<XYAPIBatchAPIRequestsProtocol> delegate;

/**
 *  将API 加入到BatchRequest Set 集合中
 *
 *  @param api
 */
- (void)addAPIRequest:(nonnull XYBaseAPI *)api;

/**
 *  将带有API集合的Sets 赋值
 *
 *  @param apis
 */
- (void)addBatchAPIRequests:(nonnull NSSet *)apis;

/**
 *  开启API 请求
 */
- (void)start;

@end
