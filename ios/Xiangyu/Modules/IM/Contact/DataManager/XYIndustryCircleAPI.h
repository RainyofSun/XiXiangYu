//
//  XYNearbyPeopleAPI.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYBaseAPI.h"
#import "XYFriendItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYIndustryCircleAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userID reqData:(XYFriendDataReq *)reqData page:(NSUInteger)page;

@end

NS_ASSUME_NONNULL_END
