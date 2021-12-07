//
//  XYTimelineProfileDataManager.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import <Foundation/Foundation.h>
#import "XYTimelineProfileModel.h"

@interface XYTimelineProfileDataManager : NSObject

@property (nonatomic,strong) XYTimelineProfileModel *model;

@property (nonatomic,strong) NSNumber *userId;

- (void)fetchUserInfoWithBlock:(void(^)(XYError * error))block;

- (void)followUserWithBlock:(void(^)(XYError * error))block;

@end
