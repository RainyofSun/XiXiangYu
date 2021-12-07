//
//  XYProfileInfoAPI.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYProfileInfoAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId;

@end

@interface XYUpdateDetailAPI : XYBaseAPI
- (instancetype)initWithUserId:(NSNumber *)userId data:(NSDictionary *)data;

@end
//
NS_ASSUME_NONNULL_END
