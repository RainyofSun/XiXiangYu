//
//  XYProfileDataManager.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/6/3.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseTableViewDataSource.h"
#import "XYProfileInfo.h"

@interface XYProfileDataManager : XYBaseTableViewDataSource

@property (nonatomic,weak) id target;

@property (nonatomic, assign) BOOL isAddedDynamicModule;

@property (nonatomic, strong, readonly) XYProfileInfo *profileInfo;

- (void)fetchDataWithBlock:(void(^)(BOOL ret))block;

- (void)fetchUserInfoWithBlock:(void(^)(BOOL needRefresh, XYError *error))block;

- (void)logoutWithBlock:(XYNetworkRespone)block;

@end
