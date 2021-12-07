//
//  XYQQLoginAPI.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseAPI.h"

@interface XYBindAccountAPI : XYBaseAPI

- (instancetype)initWithType:(NSUInteger)type
                    relateId:(NSString *)relateId
                  thirdToken:(NSString *)thirdToken
                      mobile:(NSString *)mobile
                        code:(NSString *)code;

@end
