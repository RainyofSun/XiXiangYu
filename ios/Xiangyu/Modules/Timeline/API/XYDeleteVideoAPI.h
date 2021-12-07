//
//  XYDeleteVideoAPI.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYDeleteVideoAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId videoId:(NSNumber *)videoId;

@end

NS_ASSUME_NONNULL_END
