//
//  XYFollowAPI.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYFollowAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId destUserId:(NSNumber *)destUserId operation:(NSNumber *)operation source:(NSNumber *)source dyId:(NSNumber *)dyId ;

@end

NS_ASSUME_NONNULL_END
