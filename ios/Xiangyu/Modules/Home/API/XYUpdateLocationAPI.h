//
//  XYUpdateLocationAPI.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYUpdateLocationAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude;

@end

NS_ASSUME_NONNULL_END
