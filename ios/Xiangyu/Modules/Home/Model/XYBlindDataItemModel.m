//
//  XYBlindDataItemModel.m
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
#import "XYBlindDataItemModel.h"

@implementation XYBlindDataItemModel
-(NSString *)addressDec{
  if (!_addressDec) {
    
    //NSString *cityN =[[XYAddressService sharedService] queryAreaNameWithAdcode:self.city];
    
    NSString *areaN =[[XYAddressService sharedService] queryCityAreaNameWithAdcode:self.area];
    if (areaN) {
      _addressDec = [NSString stringWithFormat:@"%@",areaN];
    }
    
  }
  return _addressDec;
}
@end
@implementation XYBlindDataItemListModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{ @"list" : [XYBlindDataItemModel class] ,
              @"page" : [XYPageModel class]
    };
}
@end
