//
//  XYRandomNickNameAPI.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/14.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYRandomNickNameAPI.h"

@implementation XYRandomNickNameAPI

- (NSString *)requestMethod {
    return @"api/v1/User/GetRandomNickName";
}

- (id)requestParameters {
  return @{@"sex":self.sex?:@(1)};
}
@end
