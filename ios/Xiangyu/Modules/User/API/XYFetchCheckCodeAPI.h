//
//  XYFetchCheckCodeAPI.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/7.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseAPI.h"
#import "XYUserConst.h"

@interface XYFetchCheckCodeAPI : XYBaseAPI

/** 获取验证码 */
- (instancetype)initWithMobile:(NSString *)mobile type:(XYCheckCodeType)type;

@end
