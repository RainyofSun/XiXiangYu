//
//  XYTimelineVideoAPI.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYTimelineVideoAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId isMyQuery:(NSNumber *)isMyQuery page:(NSUInteger)page;

@end

NS_ASSUME_NONNULL_END
