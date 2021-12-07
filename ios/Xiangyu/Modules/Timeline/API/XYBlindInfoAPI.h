//
//  XYGetMainPageInfoAPI.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYBlindInfoAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId blindId:(NSNumber *)blindId;

@end

NS_ASSUME_NONNULL_END
