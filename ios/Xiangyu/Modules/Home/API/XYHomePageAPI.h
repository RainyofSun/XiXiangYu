//
//  XYHomePageAPI.h
//  Xiangyu
//
//  Created by dimon on 26/02/2021.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYHomePageAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId dwellProvince:(NSString *)dwellProvince dwellCity:(NSString *)dwellCity;

@end

NS_ASSUME_NONNULL_END
