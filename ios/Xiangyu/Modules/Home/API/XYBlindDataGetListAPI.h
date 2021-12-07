//
//  XYBlindDataGetListAPI.h
//  Xiangyu
//
//  Created by Kang on 2021/6/29.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYBlindDataGetListAPI : XYBaseAPI
- (instancetype)initWithData:(NSDictionary *)data page:(NSUInteger)page;
@end
@interface XYBlindDataGetMyListAPI : XYBaseAPI
- (instancetype)initWithData:(NSDictionary *)data page:(NSUInteger)page;
@end
NS_ASSUME_NONNULL_END
