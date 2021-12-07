//
//  XYGeneralAPI.h
//  Pods
//
//  Created by 圣迪 on 15/12/10.
//
//

#import "XYBaseAPI.h"
#import "XYAPIDefines.h"

@class XYGeneralAPI;
NS_ASSUME_NONNULL_BEGIN

#pragma mark - XYObjReformerProtocol
@protocol XYObjReformerProtocol
/**
 *  一般用来进行JSON -> Model 数据的转换工作
 *   返回的id，如果没有error，则为转换成功后的Model数据；
 *    如果有error， 则直接返回传参中的responseObject
 *
 *  @param api 当前的api
 *  @param responseObject 请求的返回
 *  @param error          请求的错误
 *
 *  @return 整理过后的请求数据
 */
- (nullable id)apiResponseObjReformerWithGeneralAPI:(nonnull XYGeneralAPI *)api
                                  andResponseObject:(nonnull id)responseObject
                                           andError:(NSError * _Nullable)error;
@end

#pragma mark - XYGeneralAPI
@interface XYGeneralAPI : XYBaseAPI

/**
 *  XYAPI Protocol中的 requestMethod字段
 */
@property (nonatomic,   copy) NSString         *requestMethod;
/**
 *  安全协议设置
 */
@property (nonatomic, strong) XYSecurityPolicy *apiSecurityPolicy;

/**
 *  同BaseAPI apiRequestMethodType
 */
@property (nonatomic, assign) XYRequestMethodType      apiRequestMethodType;

/**
 *  同BaseAPI apiRequestSerializerType
 */
@property (nonatomic, assign) XYRequestSerializerType  apiRequestSerializerType;

/**
 *  同BaseAPI apiResponseSerializerType
 */
@property (nonatomic, assign) XYResponseSerializerType apiResponseSerializerType;

/**
 *  同BaseAPI apiRequestCachePolicy
 */
@property (nonatomic, assign) NSURLRequestCachePolicy   apiRequestCachePolicy;

/**
 *  同BaseAPI apiRequestTimeoutInterval
 */
@property (nonatomic, assign) NSTimeInterval            apiRequestTimeoutInterval;

/**
 *  XYAPI Protocol中的 RequestParameters字段
 */
@property (nonatomic, strong, nullable) id           requestParameters;

/**
 *  同BaseAPI apiRequestHTTPHeaderField
 */
@property (nonatomic, strong, nullable) NSDictionary *apiRequestHTTPHeaderField;

/**
 *  同BaseAPI apiResponseAcceptableContentTypes
 */
@property (nonatomic, strong, nullable) NSSet        *apiResponseAcceptableContentTypes;

/**
 *  同BaseAPI apiAddtionalRPCParams
 */
@property (nonatomic, strong, nullable) NSDictionary *apiAddtionalRPCParams;

/**
 *  同BaseAPI customRequestUrl
 */
@property (nonatomic, copy,   nullable) NSString     *customRequestUrl;

/**
 *  同BaseAPI apiAddtionalRequestFunction
 */
@property (nonatomic, copy,   nullable) NSString     *apiAddtionalRequestFunction;

/**
 *  同BaseAPI apiRequestWillBeSent
 */
@property (nonatomic, copy, nullable) void (^apiRequestWillBeSentBlock)();

/**
 *  同BaseAPI apiRequestDidSent
 */
@property (nonatomic, copy, nullable) void (^apiRequestDidSentBlock)();

/**
 *  一般用来进行JSON -> Model 数据的转换工作
 *   返回的id，如果没有error，则为转换成功后的Model数据；
 *    如果有error， 则直接返回传参中的responseObject
 *
 *  注意：
 *   这里与XYAPI Protocol中的apiResponseObjReformer 有重合。
 *   这里的block 主要给 XYGeneralAPI 使用
 *
 *  @param responseObject 请求的返回
 *  @param error          请求的错误
 *
 *  @return 整理过后的请求数据
 */
@property (nonatomic, copy, nullable) id _Nullable (^apiResponseObjReformerBlock)(id responseObject, NSError * _Nullable error);

/**
 *  进行JSON -> Model 数据的转换工作的Delegate
 *   功能与apiResponseObjReformerBlock相同
 *
 *   提供该Delegate主要用于Reformer的不相关代码的解耦工作
 *
 *  注意：
 *   如果apiResponseObjReformerBlock 同时设置，以本Delegate为主
 */
@property (nonatomic, weak, nullable) id<XYObjReformerProtocol> objReformerDelegate;

- (nullable instancetype)init;
- (nullable instancetype)initWithRequestMethod:(NSString *)requestMethod;

@end
NS_ASSUME_NONNULL_END
