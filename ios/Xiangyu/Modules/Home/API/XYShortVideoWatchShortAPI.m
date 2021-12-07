//
//  XYShortVideoWatchShortAPI.m
//  Xiangyu
//
//  Created by Kang on 2021/7/6.
//
//------made in china-------
/**   The code comes frome breakfly
 *
 *       ┏┓　　 ┏┓
 *     ┏━┛┻━━━━┛┻┓
 * 　　┃　  　━　 ┃
 * 　　┃ 　 ^    ^ ┃
 * 　　┃　　　 ┻　 ┃
 * 　　┗━━━━━━━━━┛
 *
 * --------萌萌哒-------
 */
#import "XYShortVideoWatchShortAPI.h"

@implementation XYShortVideoWatchShortAPI
{
  NSNumber *Id_;

}
- (instancetype)initWithId:(NSNumber *)Id{
    if (self = [super init]) {
      Id_ = Id;
    }
    return self;
}
- (NSString *)requestMethod {
    return @"api/v1/ShortVideo/WatchShort";
}

- (id)requestParameters {
    return @{
            @"userId": [[XYUserService service] fetchLoginUser].userId ?: @(0),
            @"id":Id_?:@(0),
         
            };
}
@end
