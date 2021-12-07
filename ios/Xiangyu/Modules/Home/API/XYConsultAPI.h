//
//  XYConsultAPI.h
//  Xiangyu
//
//  Created by Kang on 2021/6/25.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYConsultAPI : XYBaseAPI
/**
 *  同BaseAPI apiRequestMethodType
 */
@property (nonatomic, assign) XYRequestMethodType      apiRequestMethodType;
- (instancetype)initWithUserId:(NSNumber *)userId Id:(NSNumber *)Id;
@end
@interface XYConsultCommentAPI : XYBaseAPI
/**
 *  同BaseAPI apiRequestMethodType
 */
@property (nonatomic, assign) XYRequestMethodType      apiRequestMethodType;
- (instancetype)initWithUserId:(NSNumber *)userId Id:(NSNumber *)Id content:(NSString *)content;
@end

@interface XYGetConsultCommentListAPI : XYBaseAPI
/**
 *  同BaseAPI apiRequestMethodType
 */
@property (nonatomic, assign) XYRequestMethodType      apiRequestMethodType;
- (instancetype)initWithConsultId:(NSNumber *)consultId page:(NSUInteger)page ;
@end

@interface XYConsultFabulousAPI : XYBaseAPI
- (instancetype)initWithConsultId:(NSNumber *)consultId;
@end
NS_ASSUME_NONNULL_END
