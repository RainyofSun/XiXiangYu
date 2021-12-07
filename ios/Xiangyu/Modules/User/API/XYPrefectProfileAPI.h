//
//  XYPrefectProfileAPI.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/7.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseAPI.h"

@class XYPerfectProfileModel;
@interface XYPrefectProfileAPI : XYBaseAPI

- (instancetype)initWithProfileParams:(XYPerfectProfileModel *)params userId:(NSNumber *)userId;

@end
