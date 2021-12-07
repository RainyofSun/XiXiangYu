//
//  XYBlindGetGiftListAPI.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYBlindGetGiftListAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId;

@end
@interface XYGetGiftMesAPI : XYBaseAPI

- (instancetype)initWithOrderId:(NSString *)orderId;

@end
@interface XYProfessGetMesAPI : XYBaseAPI

- (instancetype)initWithOrderId:(NSString *)orderId;

@end
NS_ASSUME_NONNULL_END
