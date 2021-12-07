//
//  XYPrefectProfileDataManager.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/7.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYPerfectProfileModel.h"

@interface XYPrefectProfileDataManager : NSObject

@property (nonatomic,strong,readonly) XYPerfectProfileModel *perfectProfileModel;

- (void)submitProfileWithBlock:(XYNetworkRespone)block;

@end
