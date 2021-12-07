//
//  XYPlatSubjectGetListAPI.h
//  Xiangyu
//
//  Created by Kang on 2021/7/3.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYPlatSubjectGetListAPI : XYBaseAPI
- (instancetype)initWithPage:(NSInteger )page;
@end
@interface XYPlatGetSubjectAPI : XYBaseAPI
/**
 *  同BaseAPI apiRequestMethodType
 */
@property (nonatomic, assign) XYRequestMethodType      apiRequestMethodType;
- (instancetype)initWithId:(NSNumber *)Id;
@end



NS_ASSUME_NONNULL_END
