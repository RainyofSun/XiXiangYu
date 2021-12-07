//
//  XYWalletItemModel.m
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
#import "XYWalletItemModel.h"

@implementation XYWalletItemModel

@end
@implementation XYWalletItemModelList
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"list" : [XYWalletItemModel class] ,
              @"page" : [XYPageModel class]
    };
}
@end
