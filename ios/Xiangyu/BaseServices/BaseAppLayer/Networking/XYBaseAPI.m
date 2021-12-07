//
//  XYBaseAPI.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseAPI.h"
#import "AFNetworking.h"
#import "XYAPIManager.h"
#import "XYRPCProtocol.h"
#import "XYSecurityPolicy.h"
#import "NSUUID+Extension.h"
#import "XYAppVersion.h"
#import "XYUserService.h"

@implementation XYBaseAPI

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)customRequestUrl {
    return nil;
}

- (nullable NSString *)apiAddtionalRequestFunction {
    return nil;
}

- (nullable NSDictionary *)apiAddtionalRPCParams {
    return nil;
}

- (nullable NSString *)requestMethod {
    return nil;
}

- (nullable id)requestParameters {
    return @{};
}

- (nullable id)apiResponseObjReformer:(id)responseObject andError:(NSError * _Nullable)error {
    return responseObject;
}

- (nullable id)apiBusinessObjReformer:(id)responseObject andError:(NSError * _Nullable)error {
    if (error) {
        return nil;
    }
    if (!responseObject) {
        return nil;
    }
    
    id respone = responseObject[@"result"];
    if (!respone) {
        return nil;
    }
    
    return respone;
}

- (XYError *)apiBusinessExceptionReformer:(id)responseObject {
    
    if (!responseObject || ![responseObject isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSNumber *sys_code = responseObject[@"code"];
    NSNumber *sys_msg = responseObject[@"msg"];
    if (!sys_code && !sys_msg) {
        return nil;
    } else {
        if (sys_code.integerValue == 200) {
            return nil;
        } else {
          XYHiddenLoading;
            NSDictionary *userInfo = @{@"code" : sys_code.stringValue,@"msg" : sys_msg};
            return ClientExceptionNetworking(userInfo);
        }
    }
}

- (XYRequestMethodType)apiRequestMethodType {
    return XYRequestMethodTypePOST;
}

- (XYRequestSerializerType)apiRequestSerializerType {
    return XYRequestSerializerTypeJSON;
}

- (XYResponseSerializerType)apiResponseSerializerType {
    return XYResponseSerializerTypeJSON;
}

- (NSURLRequestCachePolicy)apiRequestCachePolicy {
    return NSURLRequestUseProtocolCachePolicy;
}

- (NSTimeInterval)apiRequestTimeoutInterval {
    return XY_API_REQUEST_TIME_OUT;
}

- (nullable NSDictionary *)apiRequestHTTPHeaderField {
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  NSUInteger timeStamp13 = ([[NSDate date] timeIntervalSince1970]*1000);
  
  NSString *token = user.token ?: @"";
  NSString *timestamp = @(timeStamp13).stringValue ?: @"";
  NSString *randomstr = @"ABCDEFGHIJKLMNO";
  NSString *version = [XYAppVersion currentVersion] ?: @"";
  NSString *source = @"ios";
  NSString *deviceversion = [@([UIDevice systemVersion]) stringValue] ?: @"";
  NSString *devicename = [UIDevice currentDevice].machineModelName ?: @"";
  NSString *deviceid = [NSUUID keychainUUID] ?: @"";
  

  NSMutableDictionary *dict_M = @{@"token" : token,
                                  @"timestamp" : timestamp,
                                  @"randomstr" : randomstr,
                                  @"version" : version,
                                  @"source" : source,
                                  @"deviceversion" : deviceversion,
                                  @"devicename" : devicename,
                                  @"deviceid" : deviceid,
  }.mutableCopy;

  NSString *signString = [NSString stringWithFormat:@"token=%@&timestamp=%@&randomstr=%@&version=%@&source=%@&deviceversion=%@&devicename=%@&deviceid=%@&key=%@",token,timestamp,randomstr,version,source,deviceversion,devicename,deviceid,XY_REQ_KEY];

  [dict_M setValue:signString ? signString.md5String : @"" forKey:@"sign"];
  [dict_M setValue:@"application/json; charset=utf-8" forKey:@"Content-Type"];
  return dict_M.copy;
}

- (nullable NSSet *)apiResponseAcceptableContentTypes {
    return [NSSet setWithObjects:
            @"text/json",
            @"text/html",
            @"application/json",
            @"text/javascript", nil];
}

/**
 *  为了方便，在Debug模式下使用None来保证用Charles之类可以抓到HTTPS报文
 *  Production下，则用Pinning Certification PublicKey 来防止中间人攻击
 */
- (nonnull XYSecurityPolicy *)apiSecurityPolicy {
    XYSecurityPolicy *securityPolicy;
#ifdef DEBUG
    securityPolicy = [XYSecurityPolicy policyWithPinningMode:XYSSLPinningModeNone];
#else
    securityPolicy = [XYSecurityPolicy policyWithPinningMode:XYSSLPinningModePublicKey];
#endif
    return securityPolicy;
}

- (void)apiRequestWillBeSent {
    return;
}

- (void)apiRequestDidSent {
    return;
}


- (void)start {
    [[XYAPIManager sharedXYAPIManager] sendAPIRequest:((XYBaseAPI *)self)];
}

- (void)cancel {
    [[XYAPIManager sharedXYAPIManager] cancelAPIRequest:((XYBaseAPI *)self)];
}

- (NSUInteger)hash {
    NSMutableString *hashStr = [NSMutableString stringWithFormat:@"%@ %@ %@ %@",
                                [self requestMethod], [self requestParameters], [self baseUrl], [self customRequestUrl]];
    return [hashStr hash];
}

-(BOOL)isEqualToAPI:(XYBaseAPI *)api {
    return [self hash] == [api hash];
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:[XYBaseAPI class]]) return NO;
    return [self isEqualToAPI:(XYBaseAPI *) object];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"BaseUrl:%@\nCustomUrl:%@", [self baseUrl], [self customRequestUrl]];
}

@end
