//
//  XYAddressService.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/23.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYAddressItem.h"

@interface XYAddressService : NSObject

+ (instancetype)sharedService;

- (void)start;

- (NSArray *)queryProvince;

- (void)queryCityWithBlock:(void(^)(NSArray *data , NSArray <NSString *> *indexTitles))block;

- (NSArray *)querySubAreaWithAdcode:(NSString *)adcode;

- (NSArray *)queryCityWithWords:(NSString *)words;

- (NSArray *)querySubAreaWithAdcode:(NSString *)adcode level:(XYAddressLevel)level;

- (XYAddressItem *)queryModelWithAdcode:(NSString *)adcode;

- (NSString *)queryAreaNameWithAdcode:(NSString *)adcode;

- (NSString *)queryFormattNameWithAdcode:(NSString *)adcode;

- (NSString *)queryCityAreaNameWithAdcode:(NSString *)adcode;

- (void)queryTownWithAreacode:(NSString *)areaCode block:(void(^)(NSArray *data))block;

@end
