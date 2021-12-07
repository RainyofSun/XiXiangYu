//
//  XYTimelineVideoAPI.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYBaseAPI.h"

@interface XYSearchAuthorVideoAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId keyword:(NSString *)keyword page:(NSUInteger)page;

@end

@interface XYSearchProductVideoAPI : XYBaseAPI

- (instancetype)initWithUserId:(NSNumber *)userId keyword:(NSString *)keyword page:(NSUInteger)page;

@end
