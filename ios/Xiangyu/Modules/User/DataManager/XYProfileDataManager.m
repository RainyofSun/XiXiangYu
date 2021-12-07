//
//  XYProfileDataManager.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/6/3.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYProfileDataManager.h"
#import "XYProfileSectionItem.h"
#import "XYLogoutAPI.h"
#import "XYUserService.h"
#import "XYProfileInfoAPI.h"
#import "XYPlatformService.h"

@interface XYProfileDataManager ()

@property (nonatomic, strong, readwrite) XYProfileInfo *profileInfo;

@end

@implementation XYProfileDataManager

- (instancetype)init {
    if (self = [super init]) {
        self.sections = @[].mutableCopy;
    }
    return self;
}

- (void)fetchDataWithBlock:(void(^)(BOOL ret))block {
    NSMutableArray *data = @[@{
                              @"headerInfo":@{@"className":@"XYProfileHeaderView",
                                              @"height":@"313",
                                              @"lock":@(1),
                                              @"picURL":@"default_avatar",
                                              @"name":@"**",
                                              @"level":@"0",
                                              @"status":@"0",
                                              @"identity":@"",
                                              @"heart":@"心动",
                                              @"heartCount":@"0",
                                              @"gift":@"礼物",
                                              @"giftCount":@"0",
                                              @"friends":@"好友",
                                              @"friendsCount":@"0",
                                              @"attention":@"关注",
                                              @"attentionCount":@"0",
                                              @"fans":@"粉丝",
                                              @"fansCount":@"0",
                                              @"like":@"点赞",
                                              @"likeCount":@"0",
                                              @"target":self.target ?: @"",
                                              },
                              @"footerInfo":@{},
                              @"items":@[]
                              },
                      @{
                      @"headerInfo":@{},
                      @"footerInfo":@{},
                      @"items":@[
                      @{@"cellClass":@"XYProfileNormalCell",
                        @"cellHeight":@"52",
                        @"picURL":@"icon_20_fabu",
                        @"title":@"我的发布",
                        @"status":@"",
                        @"withCordis":@(1),
                        @"withLine":@(YES),
                        @"target":self.target ?: @"",
                        },
                      @{@"cellClass":@"XYProfileNormalCell",
                        @"cellHeight":@"52",
                        @"picURL":@"icon_20_yaoqin",
                        @"title":@"我的邀请",
                        @"status":@"",
                        @"withCordis":@(0),
                        @"withLine":@(YES),
                        @"target":self.target ?: @"",
                        },
                      @{@"cellClass":@"XYProfileNormalCell",
                        @"cellHeight":@"52",
                        @"picURL":@"icon_20_guangao",
                        @"title":@"广告发布",
                        @"status":@"",
                        @"withCordis":@(0),
                        @"withLine":@(YES),
                        @"target":self.target ?: @"",
                        },
                      @{@"cellClass":@"XYProfileNormalCell",
                        @"cellHeight":@"52",
                        @"picURL":@"icon_20_yiji",
                        @"title":@"意见反馈",
                        @"status":@"",
                        @"withCordis":@(0),
                        @"withLine":@(YES),
                        @"target":self.target ?: @"",
                        },
                      @{@"cellClass":@"XYProfileNormalCell",
                        @"cellHeight":@"52",
                        @"picURL":@"icon_20_kefu",
                        @"title":@"客服中心",
                        @"status":@"",
                        @"withCordis":@(0),
                        @"withLine":@(YES),
                        @"target":self.target ?: @"",
                        },
                      @{@"cellClass":@"XYProfileNormalCell",
                        @"cellHeight":@"52",
                        @"picURL":@"icon_20_shezi",
                        @"title":@"设置",
                        @"status":@"",
                        @"withCordis":@(2),
                        @"target":self.target ?: @"",
                        },
                      ]
                      },
    ].mutableCopy;
    
    NSArray *profileData = [NSArray yy_modelArrayWithClass:[XYProfileSectionItem class] json:data];
    
    [self.sections addObjectsFromArray:profileData];
    
    if (block) block(YES);
}

- (void)fetchUserInfoWithBlock:(void(^)(BOOL needRefresh, XYError *error))block {
  [[XYUserService service] updateNoNeedPerfectBlock:^(BOOL success, NSDictionary *info) {
    if (success) {
      self.profileInfo = [XYProfileInfo yy_modelWithDictionary:info];
     
      
      [[XYPlatformService shareService] fetchOnlineSwitchWithBlock:^(BOOL status) {
          if (!status) {
            NSDictionary *userInfoDict = @{
              @"headerInfo":@{@"className":@"XYProfileHeaderView",
                              @"height":@"313",
                              @"picURL":self.profileInfo.headPortrait ?: @"",
                              @"lock":@(0),
                              @"name":self.profileInfo.nickName ?: @"",
                              @"status":self.profileInfo.status.integerValue == 2 ? @"2" : @"0",
                              @"level":self.profileInfo.status.integerValue == 2 ? @"1" : @"0",
                              @"identity":[NSString stringWithFormat:@"ID：%@",self.profileInfo.userId ?: @""],
                              @"heart":@"心动",
                              @"heartCount":self.profileInfo.allXdCount.stringValue?:@"0",
                          @"gift":@"礼物",
                              @"giftCount":self.profileInfo.giftCount.stringValue ?: @"0",
                              @"friends":@"好友",
                              @"friendsCount":self.profileInfo.friends.stringValue ?: @"0",
                              @"attention":@"关注",
                              @"attentionCount":self.profileInfo.follow.stringValue ?: @"0",
                              @"fans":@"粉丝",
                              @"fansCount":self.profileInfo.fans.stringValue ?: @"0",
                              @"like":@"点赞",
                              @"likeCount":self.profileInfo.appreciate.stringValue ?: @"0",
                              @"target":self.target ?: @"",
                              },
              @"footerInfo":@{},
              @"items":@[]
            };
            XYProfileSectionItem *userInfoItem = [XYProfileSectionItem yy_modelWithDictionary:userInfoDict];
            [self.sections replaceObjectAtIndex:0 withObject:userInfoItem];
            NSDictionary *orderDict = @{
            @"headerInfo":@{},
            @"footerInfo":@{},
            @"items":@[
                    @{@"cellClass":@"XYProfileOrderCell",
                      @"cellHeight":@"114",
                      @"target":self.target ?: @"",
                      },
                    ]
            };
            
            NSDictionary *giftDict = @{
            @"headerInfo":@{},
            @"footerInfo":@{},
            @"items":@[
                    @{@"cellClass":@"XYProfileGiftCell",
                      @"cellHeight":@"87",
                      @"target":self.target ?: @"",
                      @"info":@{
                          @"goldBalance":self.profileInfo.goldBalance ?: @(0),
                          @"balance":self.profileInfo.balance ?: @(0),
                      }
                      },
                    ]
            };
            XYProfileSectionItem *orderItem = [XYProfileSectionItem yy_modelWithDictionary:orderDict];
            XYProfileSectionItem *giftItem = [XYProfileSectionItem yy_modelWithDictionary:giftDict];
            if (self.isAddedDynamicModule) {
              [self.sections replaceObjectAtIndex:1 withObject:orderItem];
              [self.sections replaceObjectAtIndex:2 withObject:giftItem];
            } else {
              [self.sections insertObject:orderItem atIndex:1];
              [self.sections insertObject:giftItem atIndex:2];
              self.isAddedDynamicModule = YES;
            }
          }else{
            NSDictionary *userInfoDict = @{
              @"headerInfo":@{@"className":@"XYProfileHeaderView",
                              @"height":@"313",
                              @"picURL":self.profileInfo.headPortrait ?: @"",
                              @"lock":@(1),
                              @"name":self.profileInfo.nickName ?: @"",
                              @"status":self.profileInfo.status.integerValue == 2 ? @"2" : @"0",
                              @"level":self.profileInfo.status.integerValue == 2 ? @"1" : @"0",
                              @"identity":[NSString stringWithFormat:@"ID：%@",self.profileInfo.userId ?: @""],
                              @"heart":@"心动",
                              @"heartCount":self.profileInfo.allXdCount.stringValue?:@"0",
                          @"gift":@"礼物",
                              @"giftCount":self.profileInfo.giftCount.stringValue ?: @"0",
                              @"friends":@"好友",
                              @"friendsCount":self.profileInfo.friends.stringValue ?: @"0",
                              @"attention":@"关注",
                              @"attentionCount":self.profileInfo.follow.stringValue ?: @"0",
                              @"fans":@"粉丝",
                              @"fansCount":self.profileInfo.fans.stringValue ?: @"0",
                              @"like":@"点赞",
                              @"likeCount":self.profileInfo.appreciate.stringValue ?: @"0",
                              @"target":self.target ?: @"",
                              },
              @"footerInfo":@{},
              @"items":@[]
            };
            XYProfileSectionItem *userInfoItem = [XYProfileSectionItem yy_modelWithDictionary:userInfoDict];
            [self.sections replaceObjectAtIndex:0 withObject:userInfoItem];
          }
        
          if (block) {
            block(YES, nil);
          }
      }];
    } else {
      if (block) block(NO, ClientExceptionUndefined());
    }
  }];
//  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
//  XYProfileInfoAPI *api = [[XYProfileInfoAPI alloc] initWithUserId:user.userId];
//  api.filterCompletionHandler = ^(NSDictionary *  _Nullable data, XYError * _Nullable error) {
//    if (error) {
//      if (block) block(NO, error);
//    } else {
//      self.profileInfo = [XYProfileInfo yy_modelWithDictionary:data];
//      NSDictionary *userInfoDict = @{
//        @"headerInfo":@{@"className":@"XYProfileHeaderView",
//                        @"height":@"313",
//                        @"picURL":self.profileInfo.headPortrait ?: @"",
//                        @"name":self.profileInfo.nickName ?: @"",
//                        @"level":self.profileInfo.status.integerValue == 2 ? @"1" : @"0",
//                        @"identity":[NSString stringWithFormat:@"ID：%@",self.profileInfo.userId],
//                        @"friends":@"好友",
//                        @"friendsCount":self.profileInfo.friends.stringValue,
//                        @"attention":@"关注",
//                        @"attentionCount":self.profileInfo.follow.stringValue,
//                        @"fans":@"粉丝",
//                        @"fansCount":self.profileInfo.fans.stringValue,
//                        @"like":@"点赞",
//                        @"likeCount":self.profileInfo.appreciate.stringValue,
//                        @"target":self.target ?: @"",
//                        },
//        @"footerInfo":@{},
//        @"items":@[]
//      };
//      XYProfileSectionItem *userInfoItem = [XYProfileSectionItem yy_modelWithDictionary:userInfoDict];
//      [self.sections replaceObjectAtIndex:0 withObject:userInfoItem];
//
//      [[XYPlatformService shareService] fetchOnlineSwitchWithBlock:^(BOOL status) {
//          if (!status) {
//
//            NSDictionary *orderDict = @{
//            @"headerInfo":@{},
//            @"footerInfo":@{},
//            @"items":@[
//                    @{@"cellClass":@"XYProfileOrderCell",
//                      @"cellHeight":@"114",
//                      @"target":self.target ?: @"",
//                      },
//                    ]
//            };
//
//            NSDictionary *giftDict = @{
//            @"headerInfo":@{},
//            @"footerInfo":@{},
//            @"items":@[
//                    @{@"cellClass":@"XYProfileGiftCell",
//                      @"cellHeight":@"87",
//                      @"target":self.target ?: @"",
//                      @"info":@{
//                          @"goldBalance":self.profileInfo.goldBalance ?: @(0),
//                          @"giftCount":self.profileInfo.giftCount ?: @(0),
//                      }
//                      },
//                    ]
//            };
//            XYProfileSectionItem *orderItem = [XYProfileSectionItem yy_modelWithDictionary:orderDict];
//            XYProfileSectionItem *giftItem = [XYProfileSectionItem yy_modelWithDictionary:giftDict];
//            if (self.isAddedDynamicModule) {
//              [self.sections replaceObjectAtIndex:1 withObject:orderItem];
//              [self.sections replaceObjectAtIndex:2 withObject:giftItem];
//            } else {
//              [self.sections insertObject:orderItem atIndex:1];
//              [self.sections insertObject:giftItem atIndex:2];
//              self.isAddedDynamicModule = YES;
//            }
//          }
//
//          if (block) {
//            block(YES, nil);
//          }
//      }];
//    }
//  };
//  [api start];
}

- (void)logoutWithBlock:(XYNetworkRespone)block {
    XYUserInfo *user = [XYUserService service].fetchLoginUser;
    if (!user || !user.userId) {
        if (block) block(nil,ClientExceptionUndefined());
        return;
    }
    
    XYLogoutAPI *api = [[XYLogoutAPI alloc] initWithUserId:user.userId];
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
        if (error) {
            if (block) block(nil,error);
            return;
        }
        [[XYUserService service] logoutUserWithBlock:^(BOOL success) {
            if (success) {
                if (block) block(data,error);
            } else {
                if (block) block(nil,ClientExceptionSave());
            }
        }];
    };
    [api start];
}
@end
