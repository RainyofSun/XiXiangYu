//
//  CustomTCommonPendencyCellData.m
//  Xiangyu
//
//  Created by Kang on 2021/6/3.
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
#import "CustomTCommonPendencyCellData.h"
#import "V2TIMManager.h"
#import "TIMUserProfile+DataProvider.h"
#import "Toast/Toast.h"
#import "THelper.h"
@implementation CustomTCommonPendencyCellData
-(void)agreeWithBlock:(backBlock)block{
  [[V2TIMManager sharedInstance] acceptFriendApplication:self.application type:V2TIM_FRIEND_ACCEPT_AGREE_AND_ADD succ:^(V2TIMFriendOperationResult *result) {
      [THelper makeToast:@"已同意好友申请"];
    if (block) {
      block(nil);
    }
  } fail:^(int code, NSString *msg) {
      [THelper makeToastError:code msg:msg];
  }];
}
@end
