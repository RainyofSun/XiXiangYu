//
//  XYProfessConfManager.m
//  Xiangyu
//
//  Created by Kang on 2021/7/5.
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
#import "XYProfessConfManager.h"
#import "XYBlindDateHelpMiAPI.h"
@implementation XYProfessConfManager
- (void)releaseProfessConfWithBlock:(void(^)(XYError *error))block{
  XYBlindDateProfessConfAPI *api = [[XYBlindDateProfessConfAPI alloc]init];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
   
    self.texts = [data objectForKey:@"texts"];
    self.conf = [data objectForKey:@"conf"];
    self.superHeartCount = [data objectForKey:@"superHeartCount"];
    if (block) block(error);
    
  };
  [api start];
  
}
@end
