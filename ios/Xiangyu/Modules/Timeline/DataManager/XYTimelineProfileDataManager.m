//
//  XYTimelineProfileDataManager.m
//  Xiangyu
//
//  Created by dimon on 09/02/2021.
//

#import "XYTimelineProfileDataManager.h"
#import "XYGetMainPageInfoAPI.h"
#import "XYFollowAPI.h"

@import ImSDK;

@interface XYTimelineProfileDataManager ()

@end

@implementation XYTimelineProfileDataManager

- (void)fetchUserInfoWithBlock:(void(^)(XYError * error))block {

  XYGetMainPageInfoAPI *api = [[XYGetMainPageInfoAPI alloc] initWithUserId:self.userId];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (!error) {
      self.model = [XYTimelineProfileModel yy_modelWithDictionary:data];
      [[V2TIMManager sharedInstance] checkFriend:self.userId.stringValue
                                            succ:^(V2TIMFriendCheckResult *result) {
        if (result.relationType == V2TIM_FRIEND_RELATION_TYPE_BOTH_WAY) {
          self.model.isFriends = YES;
        } else {
          self.model.isFriends = NO;
        }
        if (block) block(nil);
      } fail:^(int code, NSString *desc) {
        self.model.isFriends = NO;
        if (block) block(nil);
      }];
    } else {
      if (block) block(error);
    }
  };
  [api start];
}

- (void)followUserWithBlock:(void(^)(XYError * error))block {
//# warning 参数不确定
  XYFollowAPI *api = [[XYFollowAPI alloc] initWithUserId:[[XYUserService service] fetchLoginUser].userId destUserId:self.userId operation:self.model.isFollow.integerValue == 1 ? @(2) : @(1) source:@(-10) dyId:@(0)];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (!error) {
      BOOL isFollow = self.model.isFollow.integerValue == 1;
      self.model.isFollow = isFollow ? @(0) : @(1);
      if (block) block(nil);
    } else {
      if (block) block(error);
    }
  };
  [api start];
}

@end
