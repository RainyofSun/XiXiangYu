//
//  XYGetProfessModel.m
//  Xiangyu
//
//  Created by Kang on 2021/6/29.
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
#import "XYGetProfessModel.h"

@implementation XYGetProfessModel

@end
@implementation XYQueryXdListModel

@end
//

@implementation XYQueryXdListObjModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"list" : [XYQueryXdListModel class] ,
              @"page" : [XYPageModel class]
    };
}
@end
