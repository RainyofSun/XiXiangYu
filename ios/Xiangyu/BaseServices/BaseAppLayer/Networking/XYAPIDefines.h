//
//  XYAPIDefines.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#ifndef XYAPIDefines_h
#define XYAPIDefines_h

// 网络请求类型
typedef NS_ENUM(NSUInteger, XYRequestMethodType) {
    XYRequestMethodTypeGET     = 0,
    XYRequestMethodTypePOST    = 1,
    XYRequestMethodTypeHEAD    = 2,
    XYRequestMethodTypePUT     = 3,
    XYRequestMethodTypePATCH   = 4,
    XYRequestMethodTypeDELETE  = 5
};

// 请求的序列化格式
typedef NS_ENUM(NSUInteger, XYRequestSerializerType) {
    XYRequestSerializerTypeHTTP    = 0,
    XYRequestSerializerTypeJSON    = 1
};

// 请求返回的序列化格式
typedef NS_ENUM(NSUInteger, XYResponseSerializerType) {
    XYResponseSerializerTypeHTTP    = 0,
    XYResponseSerializerTypeJSON    = 1
};

/**
 *  SSL Pinning
 */
typedef NS_ENUM(NSUInteger, XYSSLPinningMode) {
    /**
     *  不校验Pinning证书
     */
    XYSSLPinningModeNone,
    /**
     *  校验Pinning证书中的PublicKey.
     *  知识点可以参考
     *  https://en.wikipedia.org/wiki/HTTP_Public_Key_Pinning
     */
    XYSSLPinningModePublicKey,
    /**
     *  校验整个Pinning证书
     */
    XYSSLPinningModeCertificate,
};

// XY 默认的请求超时时间
#define XY_API_REQUEST_TIME_OUT     30
#define MAX_HTTP_CONNECTION_PER_HOST 5


#endif /* XYAPIDefines_h */
