//
//  XYDynamicsLikesUserAPI.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYDynamicsLikesUserAPI : XYBaseAPI

- (instancetype)initWithDynamicId:(NSNumber *)dynamicId page:(NSInteger)page;

@end

NS_ASSUME_NONNULL_END
