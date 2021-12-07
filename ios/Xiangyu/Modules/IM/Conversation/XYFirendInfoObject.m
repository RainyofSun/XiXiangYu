//
//  XYFirendInfoObject.m
//  Xiangyu
//
//  Created by Kang on 2021/7/14.
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
#import "XYFirendInfoObject.h"

@implementation XYFirendInfoObject
- (instancetype)initWithType:(NSInteger)type
                       title:(NSString *)title
                       value:(NSString *)value {

    self = [super init];
    if (self) {
        _type = type;
        _title = title;
        _value = value;
    }
    return self;
}
- (instancetype)initWithType:(NSInteger)type
                     infoObj:(NSDictionary *)infoObj {
    self = [super init];
    if (self) {
        _type = type;
        _infoObj = infoObj;
    }
    return self;
}
- (instancetype)initWithType:(NSInteger)type
                       title:(NSString *)title
                    switchOn:(BOOL )switchOn{
  self = [super init];
  if (self) {
      _type = type;
      _title = title;
      _switchOn = switchOn;
  }
  return self;
}
@end
