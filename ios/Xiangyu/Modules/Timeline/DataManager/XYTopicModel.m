//
//  XYTopicModel.m
//  Xiangyu
//
//  Created by Kang on 2021/7/3.
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
#import "XYTopicModel.h"

@implementation XYTopicModel

@end
@implementation XYTopicListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"list" : [XYTopicModel class] ,
              @"page" : [XYPageModel class]
    };
}
@end
