//
//  XYClientExceptionParser.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/16.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYClientExceptionParser.h"

@implementation XYClientExceptionParser

XYError * ClientExceptionNULL(void) {
    return [XYError clientErrorWithCode:@"XY0000" msg:@"暂无相关数据~"];
}

XYError * ClientExceptionUndefined(void) {
    return [XYError clientErrorWithCode:@"XY1000" msg:@"发生未知错误~"];
}

XYError * ClientExceptionParser() {
    return [XYError clientErrorWithCode:@"XY1001" msg:@"数据解析出错喽~"];
}

XYError * ClientExceptionSave() {
    return [XYError clientErrorWithCode:@"XY1002" msg:@"数据存储出错喽~"];
}

XYError * ClientExceptionNotLogin() {
    return [XYError clientErrorWithCode:@"XY1003" msg:@"请先登录~"];
}

XYError * ClientExceptionSystem(NSError *error) {
    return [XYError clientErrorWithCode:[@(error.code) stringValue]
                                    msg:error.userInfo[NSLocalizedDescriptionKey]];
}

XYError * ClientExceptionNetworking(NSDictionary *info) {
    return [XYError clientErrorWithCode:info[@"code"] ?: @"" msg:info[@"msg"] ?: @""];
}

@end
