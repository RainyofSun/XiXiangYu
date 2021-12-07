//
//  XYError.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/22.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYError : NSObject

@property (nonatomic,copy) NSString *code;

@property (nonatomic,copy) NSString *msg;

+ (instancetype)clientErrorWithCode:(NSString *)code msg:(NSString *)msg;

@end

