//
//  XYProfessGetProfess.h
//  Xiangyu
//
//  Created by Kang on 2021/6/29.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYProfessGetProfess : XYBaseAPI

@end
@interface XYProfessQueryXdList : XYBaseAPI
- (instancetype)initWithOpType:(NSNumber *)opType page:(NSInteger)page;
@end
NS_ASSUME_NONNULL_END
