//
//  XYDynamicsAPI.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYBaseAPI.h"

@interface XYRecommendDynamicsAPI : XYBaseAPI

- (instancetype)initWithType:(NSUInteger)type
                     provice:(NSString *)province
                        city:(NSString *)city
                        page:(NSUInteger)page   subjectId:(NSNumber*)subjectId;

@end

@interface XYMyDynamicsAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId page:(NSUInteger)page;

@end

@interface XYOthersDynamicsAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId page:(NSUInteger)page;

@end

