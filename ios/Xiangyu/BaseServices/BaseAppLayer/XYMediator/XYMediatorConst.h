//
//  XYMediatorConst.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/6/5.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XYMediatorTargetName(_name_) [XYMediatorTargetPrefix stringByAppendingString:(_name_)]

#define XYMediatorActionName(_name_) [XYMediatorActionPrefix stringByAppendingString:(_name_)]

#define XYMediatorActionNativeMethod(method) Action_native##method

#define XYMediatorActionMethod(method) Action_##method

#define XYMediatorActionNotFoundMethod Action_notFoundWithParams:(NSDictionary *)params

#define XYMediatorActionNoResponeMethod Action_noResponeWithParams:(NSDictionary *)params

/** 本地调用方法前缀 */
XY_EXTERN NSString *const XYMediatorNative;

/** 方法调用返回结果的key */
XY_EXTERN NSString *const XYMediatorBlockResult;

/** target前缀 */
XY_EXTERN NSString *const XYMediatorTargetPrefix;

/** action前缀 */
XY_EXTERN NSString *const XYMediatorActionPrefix;

/** 没有找到的方法名 */
XY_EXTERN NSString *const XYMediatorNotFoundAction;

/** 没有响应的方法名 */
XY_EXTERN NSString *const XYMediatorNoResponeAction;

/** 无响应原始参数key */
XY_EXTERN NSString *const XYMediatorNoResponeParams;

/** 无响应targetString */
XY_EXTERN NSString *const XYMediatorNoResponeTarget;

/** 无响应的方法名 */
XY_EXTERN NSString *const XYMediatorNoResponeSelector;
