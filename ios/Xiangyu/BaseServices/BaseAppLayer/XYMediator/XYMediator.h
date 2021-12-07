//
//  XYMediator.h
//  Xiangyu
//
//  Created by 沈阳 on 2018/6/5.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYMediatorConst.h"

@interface XYMediator : NSObject

+ (instancetype)sharedInstance;

/**
 *  @note  远程调用入口
 *  @param url 请求地址
 *  @param completion 调用完成的回调
 *
 *  @return 方法调用的返回值
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;

/**
 *  @note   本地调用入口
 *  @param targetName 方法响应实体
 *  @param actionName 方法名称
 *  @param params 方法参数
 *  @param shouldCacheTarget 是否缓存Target
 *
 *  @return 方法调用的返回值
 */
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

/** 释放缓存的Target */
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;

@end
