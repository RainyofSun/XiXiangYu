//
//  XYCommentDynamicAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYCommentDynamicAPI.h"

@implementation XYCommentDynamicAPI
{
  NSNumber *dynamicId_;
  NSNumber *destUserId_;
  NSString *commentBody_;
}

- (instancetype)initWithDynamicId:(NSNumber *)dynamicId destUserId:(NSNumber *)destUserId commentBody:(NSString *)commentBody {
    if (self = [super init]) {
      dynamicId_ = dynamicId;
      destUserId_ = destUserId;
      commentBody_ = commentBody;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Dynamic/CommentDynamic";
}

- (id)requestParameters {
    return @{
            @"dynamicId": dynamicId_ ?: @(0),
            @"destUserId": destUserId_ ?: @(0),
            @"commentBody": commentBody_ ?: @"",
            };
}
@end
