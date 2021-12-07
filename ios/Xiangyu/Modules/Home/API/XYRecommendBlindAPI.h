//
//  XYRecommendBlindAPI.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/27.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYRecommendBlindAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId
                           sex:(NSNumber *)sex
                      latitude:(NSNumber *)latitude
                     longitude:(NSNumber *)longitude
                     dwellCity:(NSString *)dwellCity;

@end

NS_ASSUME_NONNULL_END
