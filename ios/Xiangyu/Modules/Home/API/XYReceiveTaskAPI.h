//
//  XYFollowAPI.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYReceiveTaskAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId taskId:(NSNumber *)taskId;

@end

NS_ASSUME_NONNULL_END
