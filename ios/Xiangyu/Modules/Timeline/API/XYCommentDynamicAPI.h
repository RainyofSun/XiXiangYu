//
//  XYCommentDynamicAPI.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYCommentDynamicAPI : XYBaseAPI

- (instancetype)initWithDynamicId:(NSNumber *)dynamicId destUserId:(NSNumber *)destUserId commentBody:(NSString *)commentBody;

@end

NS_ASSUME_NONNULL_END
