//
//  XYClientExceptionInterceptor.h
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/24.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYClientExceptionInterceptor : NSObject

+ (XYClientExceptionInterceptor *)interceptor;

- (void)activate;

@end
