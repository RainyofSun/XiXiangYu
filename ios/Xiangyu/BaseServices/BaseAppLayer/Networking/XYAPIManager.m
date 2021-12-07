//
//  XYAPIManager.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYAPIManager.h"
#import "AFNetworking.h"
#import "XYBaseAPI.h"
#import "XYConfig.h"
#import "XYRPCProtocol.h"
#import "XYAPIBatchAPIRequests.h"
#import <pthread.h>
#import "XYSecurityPolicy.h"
#import "XYNetworkErrorObserverProtocol.h"

static dispatch_queue_t XY_api_task_creation_queue() {
    static dispatch_queue_t XY_api_task_creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XY_api_task_creation_queue =
        dispatch_queue_create("xm.XY.networking.durandal.api.creation", DISPATCH_QUEUE_SERIAL);
    });
    return XY_api_task_creation_queue;
}

static XYAPIManager *sharedXYAPIManager       = nil;

@interface XYAPIManager ()

@property (nonatomic, strong) NSCache *sessionManagerCache;
@property (nonatomic, strong) NSCache *sessionTasksCache;
@property (nonatomic, strong) NSMutableSet<id<XYNetworkErrorObserverProtocol>> *errorObservers;

@end

@implementation XYAPIManager

#pragma mark - Init
+ (XYAPIManager *)sharedXYAPIManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedXYAPIManager = [[self alloc] init];
    });
    return sharedXYAPIManager;
}

- (instancetype)init {
    if (!sharedXYAPIManager) {
        sharedXYAPIManager                    = [super init];
        sharedXYAPIManager.configuration      = [[XYConfig alloc]init];
        sharedXYAPIManager.errorObservers     = [[NSMutableSet alloc]init];
    }
    return sharedXYAPIManager;
}

- (NSCache *)sessionManagerCache {
    if (!_sessionManagerCache) {
        _sessionManagerCache = [[NSCache alloc] init];
    }
    return _sessionManagerCache;
}

- (NSCache *)sessionTasksCache {
    if (!_sessionTasksCache) {
        _sessionTasksCache = [[NSCache alloc] init];
    }
    return _sessionTasksCache;
}

#pragma mark - Serializer
- (AFHTTPRequestSerializer *)requestSerializerForAPI:(XYBaseAPI *)api {
    NSParameterAssert(api);
    
    AFHTTPRequestSerializer *requestSerializer;
    if ([api apiRequestSerializerType] == XYRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
     // requestSerializer = [AFHTTPRequestSerializer serializer];
    } else {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    requestSerializer.cachePolicy          = [api apiRequestCachePolicy];
    requestSerializer.timeoutInterval      = [api apiRequestTimeoutInterval];
    NSDictionary *requestHeaderFieldParams = api.apiHttpHeaderDelegate
                                            ? [api.apiHttpHeaderDelegate apiRequestHTTPHeaderField]
                                            : [api apiRequestHTTPHeaderField];
    if (![[requestHeaderFieldParams allKeys] containsObject:@"User-Agent"] &&
        self.configuration.userAgent) {
        [requestSerializer setValue:self.configuration.userAgent forHTTPHeaderField:@"User-Agent"];
    }
    if (requestHeaderFieldParams) {
        [requestHeaderFieldParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    return requestSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializerForAPI:(XYBaseAPI *)api {
    NSParameterAssert(api);
    AFHTTPResponseSerializer *responseSerializer;
    if ([api apiResponseSerializerType] == XYResponseSerializerTypeHTTP) {
        responseSerializer = [AFHTTPResponseSerializer serializer];
    } else {
        responseSerializer = [AFJSONResponseSerializer serializer];
    }
    responseSerializer.acceptableContentTypes = [api apiResponseAcceptableContentTypes];
    return responseSerializer;
}

#pragma mark - Request Invoke Organize
- (NSString *)requestBaseUrlStringWithAPI:(XYBaseAPI *)api {
    NSParameterAssert(api);
    
    // 如果定义了自定义的RequestUrl, 则直接定义RequestUrl
    if ([api customRequestUrl]) {
        NSURL *url  = [NSURL URLWithString:[api customRequestUrl]];
        NSURL *root = [NSURL URLWithString:@"/" relativeToURL:url];
        return [NSString stringWithFormat:@"%@", root.absoluteString];
    }
    
    NSAssert(api.baseUrl != nil || self.configuration.baseUrlStr != nil,
             @"api baseURL 或者 self.configuration.baseurl不能均为空");
    
    NSString *baseUrl = api.baseUrl ? : self.configuration.baseUrlStr;
    
    // 在某些情况下，一些用户会直接把整个url地址写进 baseUrl
    // 因此，还需要对baseUrl 进行一次切割
    NSURL *theUrl = [NSURL URLWithString:baseUrl];
    NSURL *root   = [NSURL URLWithString:@"/" relativeToURL:theUrl];
    return [NSString stringWithFormat:@"%@", root.absoluteString];
}

// Request Url
- (NSString *)requestUrlStringWithAPI:(XYBaseAPI *)api {
    NSParameterAssert(api);
    
  NSString *baseUrlStr = [self requestBaseUrlStringWithAPI:api];
  
    // 如果定义了自定义的RequestUrl, 则直接定义RequestUrl
    if ([api customRequestUrl]) {
        return [[api customRequestUrl] stringByReplacingOccurrencesOfString:baseUrlStr withString:@""];
    }
  
    NSAssert(api.baseUrl != nil || self.configuration.baseUrlStr != nil,
             @"api baseURL 或者 self.configuration.baseurl不能均为空");
    
    if (api.rpcDelegate) {
        NSString *rpcRequestUrlStr = [api.rpcDelegate rpcRequestUrlWithAPI:api];
        return [rpcRequestUrlStr stringByReplacingOccurrencesOfString:baseUrlStr
                                                           withString:@""];
    }
//    return [NSString stringWithFormat:@"%@/%@",baseUrlStr,[api requestMethod] ? : @""];
  return [[api requestMethod] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}

// Request Protocol
- (id)requestParamsWithAPI:(XYBaseAPI *)api {
    NSParameterAssert(api);
    
    if (api.rpcDelegate) {
        return [api.rpcDelegate rpcRequestParamsWithAPI:api];
    } else {
        return [api requestParameters];
    }
}

#pragma mark - AFSessionManager
- (AFHTTPSessionManager *)sessionManagerWithAPI:(XYBaseAPI *)api {
    NSParameterAssert(api);
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForAPI:api];
    if (!requestSerializer) {
        // Serializer Error, just return;
        return nil;
    }
    
    // Response Part
    AFHTTPResponseSerializer *responseSerializer = [self responseSerializerForAPI:api];

    NSString *baseUrlStr = [self requestBaseUrlStringWithAPI:api];
    // AFHTTPSession
    AFHTTPSessionManager *sessionManager;
    sessionManager = [self.sessionManagerCache objectForKey:baseUrlStr];
    if (!sessionManager) {
        sessionManager = [self newSessionManagerWithBaseUrlStr:baseUrlStr];
        [self.sessionManagerCache setObject:sessionManager forKey:baseUrlStr];
    }
    
    sessionManager.requestSerializer     = requestSerializer;
    sessionManager.responseSerializer    = responseSerializer;
    sessionManager.securityPolicy        = [self securityPolicyWithAPI:api];
    
    return sessionManager;
}

- (AFHTTPSessionManager *)newSessionManagerWithBaseUrlStr:(NSString *)baseUrlStr {
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    if (self.configuration) {
        sessionConfig.HTTPMaximumConnectionsPerHost = self.configuration.maxHttpConnectionPerHost;
    } else {
        sessionConfig.HTTPMaximumConnectionsPerHost = MAX_HTTP_CONNECTION_PER_HOST;
    }
    return [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrlStr]
                                    sessionConfiguration:sessionConfig];
}

- (AFSecurityPolicy *)securityPolicyWithAPI:(XYBaseAPI *)api {
    NSUInteger pinningMode                  = api.apiSecurityPolicy.SSLPinningMode;
    AFSecurityPolicy *securityPolicy        = [AFSecurityPolicy policyWithPinningMode:pinningMode];
    securityPolicy.allowInvalidCertificates = api.apiSecurityPolicy.allowInvalidCertificates;
    securityPolicy.validatesDomainName      = api.apiSecurityPolicy.validatesDomainName;
    return securityPolicy;
}

#pragma mark - Response Handle
- (void)handleSuccWithResponse:(id)responseObject andAPI:(XYBaseAPI *)api {
    if (api.rpcDelegate) {
        id formattedResponseObj = [api.rpcDelegate rpcResponseObjReformer:responseObject withAPI:api];
        NSError *rpcError = [api.rpcDelegate rpcErrorWithFormattedResponse:formattedResponseObj withAPI:api];
        if (rpcError) {
            [self callAPICompletion:api obj:nil error:rpcError];
            return;
        }
        id rpcResult = [api.rpcDelegate rpcResultWithFormattedResponse:formattedResponseObj withAPI:api];
        [self callAPICompletion:api obj:rpcResult error:nil];
    } else {
        [self callAPICompletion:api obj:responseObject error:nil];
    }
}

- (void)handleFailureWithError:(NSError *)error andAPI:(XYBaseAPI *)api {
    
    // Error -999, representing API Cancelled
    if ([error.domain isEqualToString: NSURLErrorDomain] &&
        error.code == NSURLErrorCancelled) {
        [self callAPICompletion:api obj:nil error:error];
        return;
    }
    
    // Handle Networking Error
    NSString *errorTypeStr = self.configuration.generalErrorTypeStr;
    NSMutableDictionary *tmpUserInfo = [[NSMutableDictionary alloc]initWithDictionary:error.userInfo copyItems:NO];
    if (![[tmpUserInfo allKeys] containsObject:NSLocalizedFailureReasonErrorKey]) {
        [tmpUserInfo setValue: NSLocalizedString(errorTypeStr, nil) forKey:NSLocalizedFailureReasonErrorKey];
    }
    if (![[tmpUserInfo allKeys] containsObject:NSLocalizedRecoverySuggestionErrorKey]) {
        [tmpUserInfo setValue: NSLocalizedString(errorTypeStr, nil)  forKey:NSLocalizedRecoverySuggestionErrorKey];
    }
    // 加上 networking error code
    NSString *newErrorDescription = errorTypeStr;
    if (self.configuration.isErrorCodeDisplayEnabled) {
        newErrorDescription = [NSString stringWithFormat:@"%@ (N-%ld)", errorTypeStr, (long)error.code];
    }
    [tmpUserInfo setValue:NSLocalizedString(newErrorDescription, nil) forKey:NSLocalizedDescriptionKey];
    
    NSDictionary *userInfo = [tmpUserInfo copy];
    NSError *err = [NSError errorWithDomain:error.domain
                                       code:error.code
                                   userInfo:userInfo];
    
    [self callAPICompletion:api obj:nil error:err];
}

- (void)callAPICompletion:(XYBaseAPI *)api
                      obj:(id)obj
                    error:(NSError *)error {
    DLog(@"\n**** 请求    %@  开始 ****\n%@\n**** 请求    %@  结束 ****\n",api.requestMethod,((NSObject *)api.requestParameters).yy_modelToJSONString,api.requestMethod);
    if (error) {
      DLog(@"\n**** 异常  %@    开始 ****\n%@\n**** 异常    %@  结束 ****\n",api.requestMethod,error,api.requestMethod);
    } else {
        DLog(@"\n**** 响应    %@  开始 ****\n%@\n**** 响应    %@  结束 ****\n",api.requestMethod,((NSObject *)obj).yy_modelToJSONString,api.requestMethod);
    }
  NSString *hashKey       = [NSString stringWithFormat:@"%lu", (unsigned long)[api hash]];
  [self.sessionTasksCache removeObjectForKey:hashKey];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([api apiCompletionHandler]) {
                api.apiCompletionHandler([api apiResponseObjReformer:obj andError:error], error);
            }
            
            if ([api filterCompletionHandler]) {
                api.filterCompletionHandler([api apiBusinessObjReformer:obj andError:error], [api apiBusinessExceptionReformer:obj]);
            }
            
            if (error) {
                [self.errorObservers enumerateObjectsUsingBlock:^(id<XYNetworkErrorObserverProtocol> observer, BOOL * _Nonnull stop) {
                    [observer networkHTTPErrorWithErrorInfo:error];
                }];
            } else {
                XYError *bnsError = [api apiBusinessExceptionReformer:obj];
                if (bnsError) {
                    [self.errorObservers enumerateObjectsUsingBlock:^(id<XYNetworkErrorObserverProtocol> observer, BOOL * _Nonnull stop) {
                        [observer networkSystemErrorWithErrorInfo:bnsError];
                    }];
                }
            }
        });
    
}

#pragma mark - Send Batch Requests
- (void)sendBatchAPIRequests:(nonnull XYAPIBatchAPIRequests *)apis {
    NSParameterAssert(apis);
    
    NSAssert([[apis.apiRequestsSet valueForKeyPath:@"hash"] count] == [apis.apiRequestsSet count],
             @"Should not have same API");
    
    dispatch_group_t batch_api_group = dispatch_group_create();
    __weak typeof(self) weakSelf = self;
    [apis.apiRequestsSet enumerateObjectsUsingBlock:^(id api, BOOL * stop) {
        dispatch_group_enter(batch_api_group);
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        AFHTTPSessionManager *sessionManager = [strongSelf sessionManagerWithAPI:api];
        if (!sessionManager) {
            *stop = YES;
            dispatch_group_leave(batch_api_group);
        }
        sessionManager.completionGroup = batch_api_group;
        
        [strongSelf _sendSingleAPIRequest:api
                       withSessionManager:sessionManager
                       andCompletionGroup:batch_api_group];
    }];
    dispatch_group_notify(batch_api_group, dispatch_get_main_queue(), ^{
        if (apis.delegate) {
            [apis.delegate batchAPIRequestsDidFinished:apis];
        }
    });
}

#pragma mark - Send Request
- (void)sendAPIRequest:(nonnull XYBaseAPI *)api {
    NSParameterAssert(api);
    NSAssert(self.configuration, @"Configuration Can not be nil");
    
    dispatch_async(XY_api_task_creation_queue(), ^{
        AFHTTPSessionManager *sessionManager = [self sessionManagerWithAPI:api];
        if (!sessionManager) {
            return;
        }
        [self _sendSingleAPIRequest:api withSessionManager:sessionManager];
    });
}

- (void)_sendSingleAPIRequest:(XYBaseAPI *)api withSessionManager:(AFHTTPSessionManager *)sessionManager {
    [self _sendSingleAPIRequest:api withSessionManager:sessionManager andCompletionGroup:nil];
}

- (void)_sendSingleAPIRequest:(XYBaseAPI *)api
           withSessionManager:(AFHTTPSessionManager *)sessionManager
           andCompletionGroup:(dispatch_group_t)completionGroup {
    NSParameterAssert(api);
    NSParameterAssert(sessionManager);
    
    __weak typeof(self) weakSelf = self;
    NSString *requestUrlStr = [self requestUrlStringWithAPI:api];
    id requestParams        = [self requestParamsWithAPI:api];
    NSString *hashKey       = [NSString stringWithFormat:@"%lu", (unsigned long)[api hash]];
    
    if ([self.sessionTasksCache objectForKey:hashKey]) {
        NSString *errorStr     = self.configuration.frequentRequestErrorStr;
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey : errorStr
                                   };
        NSError *cancelError = [NSError errorWithDomain:NSURLErrorDomain
                                                   code:NSURLErrorCancelled
                                               userInfo:userInfo];
        [self callAPICompletion:api obj:nil error:cancelError];
     
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
        return;
    }
    
    SCNetworkReachabilityRef hostReachable = SCNetworkReachabilityCreateWithName(NULL, [sessionManager.baseURL.host UTF8String]);
    SCNetworkReachabilityFlags flags;
    BOOL success = SCNetworkReachabilityGetFlags(hostReachable, &flags);
    bool isReachable = success &&
    (flags & kSCNetworkFlagsReachable) &&
    !(flags & kSCNetworkFlagsConnectionRequired);
    if (hostReachable) {
        CFRelease(hostReachable);
    }
    if (!isReachable) {
        // Not Reachable
        NSString *errorStr     = self.configuration.networkNotReachableErrorStr;
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey : errorStr,
                                   NSLocalizedFailureReasonErrorKey : [NSString stringWithFormat:@"%@ unreachable", sessionManager.baseURL.host]
                                   };
        NSError *networkUnreachableError = [NSError errorWithDomain:NSURLErrorDomain
                                                               code:NSURLErrorCannotConnectToHost
                                                           userInfo:userInfo];
        [self callAPICompletion:api obj:nil error:networkUnreachableError];
      [self.sessionTasksCache removeObjectForKey:hashKey];
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
        return;
    }
    
    void (^successBlock)(NSURLSessionDataTask *task, id responseObject)
    = ^(NSURLSessionDataTask * task, id responseObject) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (strongSelf.configuration.isNetworkingActivityIndicatorEnabled) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        [strongSelf handleSuccWithResponse:responseObject andAPI:api];
        [strongSelf.sessionTasksCache removeObjectForKey:hashKey];
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
    };
    
    void (^failureBlock)(NSURLSessionDataTask * task, NSError * error)
    = ^(NSURLSessionDataTask * task, NSError * error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (strongSelf.configuration.isNetworkingActivityIndicatorEnabled) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
        [strongSelf handleFailureWithError:error andAPI:api];
        [strongSelf.sessionTasksCache removeObjectForKey:hashKey];
        if (completionGroup) {
            dispatch_group_leave(completionGroup);
        }
    };
    
    void (^apiProgressBlock)(NSProgress *progress)
    = api.apiProgressBlock ?
    ^(NSProgress *progress) {
        if (progress.totalUnitCount <= 0) {
            return;
        }
        api.apiProgressBlock(progress);
    } : nil;
    
    if ([[NSThread currentThread] isMainThread]) {
        [api apiRequestWillBeSent];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [api apiRequestWillBeSent];
        });
    }
    
    if (self.configuration.isNetworkingActivityIndicatorEnabled) {
        dispatch_async_on_main_queue(^{
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
    }
    NSURLSessionDataTask *dataTask;
    switch ([api apiRequestMethodType]) {
        case XYRequestMethodTypeGET:
        {
            dataTask =
          [sessionManager GET:requestUrlStr parameters:requestParams headers:nil progress:apiProgressBlock success:successBlock failure:failureBlock];
        }
            break;
        case XYRequestMethodTypeDELETE:
        {
            dataTask =
            [sessionManager DELETE:requestUrlStr parameters:requestParams headers:nil success:successBlock failure:failureBlock];
        }
            break;
        case XYRequestMethodTypePATCH:
        {
            dataTask =
            [sessionManager PATCH:requestUrlStr parameters:requestParams headers:nil success:successBlock failure:failureBlock];
        }
            break;
        case XYRequestMethodTypePUT:
        {
            dataTask =
            [sessionManager PUT:requestUrlStr parameters:requestParams headers:nil success:successBlock failure:failureBlock];
        }
            break;
        case XYRequestMethodTypeHEAD:
        {
            dataTask =
            [sessionManager HEAD:requestUrlStr
                      parameters:requestParams
                         headers:nil
                         success:^(NSURLSessionDataTask * _Nonnull task) {
                             if (successBlock) {
                                 successBlock(task, nil);
                             }
                         }
                         failure:failureBlock];
        }
            break;
        case XYRequestMethodTypePOST:
        {
            if (![api apiRequestConstructingBodyBlock]) {
                dataTask =
                [sessionManager POST:requestUrlStr
                          parameters:requestParams
                             headers:nil
                            progress:apiProgressBlock
                             success:successBlock
                             failure:failureBlock];
            } else {
                void (^block)(id <AFMultipartFormData> formData)
                = ^(id <AFMultipartFormData> formData) {
                    api.apiRequestConstructingBodyBlock((id<XYMultipartFormData>)formData);
                };
                dataTask =
                [sessionManager POST:requestUrlStr
                          parameters:requestParams
                             headers:nil
           constructingBodyWithBlock:block
                            progress:apiProgressBlock
                             success:successBlock
                             failure:failureBlock];
            }
        }
            break;
        default:
            dataTask =
            [sessionManager GET:requestUrlStr
                     parameters:requestParams
                        headers:nil
                       progress:apiProgressBlock
                        success:successBlock
                        failure:failureBlock];
            break;
    }
    if (dataTask) {
        [self.sessionTasksCache setObject:dataTask forKey:hashKey];
    }
    
    if ([[NSThread currentThread] isMainThread]) {
        [api apiRequestDidSent];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [api apiRequestDidSent];
        });
    }
}

- (void)cancelAPIRequest:(nonnull XYBaseAPI *)api {
    dispatch_async(XY_api_task_creation_queue(), ^{
        NSString *hashKey = [NSString stringWithFormat:@"%lu", (unsigned long)[api hash]];
        NSURLSessionDataTask *dataTask = [self.sessionTasksCache objectForKey:hashKey];
        [self.sessionTasksCache removeObjectForKey:hashKey];
        if (dataTask) {
            [dataTask cancel];
        }
    });
}

#pragma Network Error Observer -
- (void)registerNetworkErrorObserver:(nonnull id<XYNetworkErrorObserverProtocol>)observer {
    [self.errorObservers addObject:observer];
}


- (void)removeNetworkErrorObserver:(nonnull id<XYNetworkErrorObserverProtocol>)observer {
    if ([self.errorObservers containsObject:observer]) {
        [self.errorObservers removeObject:observer];
    }
}

@end
