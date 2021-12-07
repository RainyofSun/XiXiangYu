//
//  XYDeleteCommentAPI.m
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import "XYDeleteCommentAPI.h"

@implementation XYDeleteCommentAPI
{
  NSNumber *dynamicId_;
  NSNumber *commentId_;
}

- (instancetype)initWithDynamicId:(NSNumber *)dynamicId commentId:(NSNumber *)commentId {
    if (self = [super init]) {
      dynamicId_ = dynamicId;
      commentId_ = commentId;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/Dynamic/DelCommentVideo";
}

- (id)requestParameters {
    return @{
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            @"dynamicId": dynamicId_ ?: @(0),
            @"id": commentId_ ?: @(0),
            };
}
@end
