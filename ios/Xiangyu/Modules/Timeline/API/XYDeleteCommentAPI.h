//
//  XYDeleteCommentAPI.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYDeleteCommentAPI : XYBaseAPI

- (instancetype)initWithDynamicId:(NSNumber *)dynamicId commentId:(NSNumber *)commentId;

@end

NS_ASSUME_NONNULL_END
