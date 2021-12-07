//
//  XYUserService.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/16.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYUserService.h"
#import "XYUserConst.h"
#import "TUIKit.h"
#import "XYIMService.h"
#import "XYProfileInfoAPI.h"

#import "XYProfileDetailAPI.h"
static XYUserService *instance = nil;
static XYUserInfo *currentUser = nil;

@implementation XYUserService
+ (XYUserService *)service {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)start {
    [self creatUserTable];
    
    XYUserInfo *userInfo = [self fetchHandleUser];
    
    if (userInfo && userInfo.islogin && [userInfo.islogin isEqualToString:@"1"]) {
        currentUser = userInfo;
        [[NSNotificationCenter defaultCenter] postNotificationName:XYLoginNotificationName object:nil];
    }
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserStatus:) name:TUIKitNotification_TIMUserStatusListener object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kickoutCurrentUser) name:XYKickoutNotificationName object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:XYUpdateUserInfoNotificationName object:nil];
}

- (BOOL)isLogin {
    if (currentUser) {
        if (currentUser.islogin.isNotBlank) {
            return YES;
        } else {
            currentUser = nil;
            return NO;
        }
    } else {
        return NO;
    }
}

- (XYUserInfo *)fetchLoginUser {
    if (currentUser) {
        if (!currentUser.islogin.isNotBlank) {
            currentUser = nil;
        }
    }
    return currentUser;
}

- (XYUserInfo *)fetchHandleUser {
    if (currentUser) {
        return currentUser;
    }
    NSString *userMobile = [[NSUserDefaults standardUserDefaults] valueForKey:CurrentUserMobileKeyName];
  __block NSArray *array = nil;
    if (userMobile.isNotBlank) {
      [[XYFMDB sharedDatabase] inDatabase:^{
        array = [[XYFMDB sharedDatabase] queryTable:UserInfoTableName object:[XYUserInfo class] whereFormat:[NSString stringWithFormat:@"where mobile = '%@'",userMobile]];
      }];
        if (array.count > 0) {
            return array.firstObject;
        }
        
    }
    return nil;
}

- (void)loginUser:(XYUserInfo *)user
    isNeedPerfect:(BOOL)isNeedPerfect
        withBlock:(void(^)(BOOL success))block {
    
    @synchronized (self) {
      [[XYIMService shareService] loginIMWithIdentifier:user.userId.stringValue sign:user.imLoginSign block:^(BOOL ret) {
        if (ret) {
          user.islogin = isNeedPerfect ? @"2" : @"1";
          [[NSUserDefaults standardUserDefaults] setValue:user.mobile forKey:CurrentUserMobileKeyName];
          [[NSUserDefaults standardUserDefaults] synchronize];
          
          __block BOOL cResult;
          __block BOOL iResult;
          __block NSArray *array;
            cResult = [self creatUserTable];
            
          [[XYFMDB sharedDatabase] inDatabase:^{
            array = [[XYFMDB sharedDatabase] queryTable:UserInfoTableName object:[XYUserInfo class] whereFormat:[NSString stringWithFormat:@"where mobile = '%@'",user.mobile]];
          }];
            
            if (array && array.count > 0) {
              [[XYFMDB sharedDatabase] inDatabase:^{
                iResult = [[XYFMDB sharedDatabase] updateTable:UserInfoTableName object:user whereFormat:[NSString stringWithFormat:@"where mobile = '%@'",user.mobile]];
              }];
            } else {
              [[XYFMDB sharedDatabase] inDatabase:^{
                iResult = [[XYFMDB sharedDatabase] insertTable:UserInfoTableName object:user distinct:NO];
              }];
            }
          
          if (cResult && iResult) {
              currentUser = user;
              [[NSNotificationCenter defaultCenter] postNotificationName:XYLoginNotificationName object:nil];
          }
          if (block) block(cResult && iResult);

        } else {
          if (block) block(NO);
        }
      }];
    }
}

- (void)kickoutCurrentUser {
  [self logoutUserWithBlock:nil];
}

- (void)logoutUserWithBlock:(void(^)(BOOL success))block {
    NSString *mobile = [[NSUserDefaults standardUserDefaults] valueForKey:CurrentUserMobileKeyName];
    if (!mobile.isNotBlank) {
        if (block) block(YES);
        return;
    }
    if (!currentUser) {
        if (block) block(YES);
        return;
    }
    
    @synchronized (self) {
      [[V2TIMManager sharedInstance] logout:^{
        [[TUILocalStorage sharedInstance] logout];
        [self cleanUserDataWithMobile:mobile block:block];
      } fail:^(int code, NSString *msg) {
        [[TUILocalStorage sharedInstance] logout];
        [self cleanUserDataWithMobile:mobile block:block];
      }];
    }
}

- (void)updateNoNeedPerfectBlock:(void(^)(BOOL success, NSDictionary *info))block {
  XYProfileInfoAPI *api = [[XYProfileInfoAPI alloc] initWithUserId:currentUser.userId];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (error) {
      if (block) block (NO, nil);
    } else {
      XYUserInfo *newInfo = [XYUserInfo yy_modelWithJSON:data];
      currentUser.islogin = @"1";
      currentUser.isFirst = @(0);
      currentUser.nickName = newInfo.nickName;
      currentUser.userId = newInfo.userId;
      currentUser.headPortrait = newInfo.headPortrait;
      currentUser.goldBalance = newInfo.goldBalance;
      currentUser.balance = newInfo.balance;
      currentUser.province = newInfo.province;
      currentUser.city = newInfo.city;
      currentUser.area = newInfo.area;
      currentUser.address = newInfo.address;
      
      __block NSArray *array = nil;
      [[XYFMDB sharedDatabase] inDatabase:^{
        array = [[XYFMDB sharedDatabase] queryTable:UserInfoTableName object:[XYUserInfo class] whereFormat:[NSString stringWithFormat:@"where mobile = '%@'",currentUser.mobile]];
      }];
      __block BOOL iResult;
      if (array && array.count > 0) {
        XYUserInfo *user = array.firstObject;
        user.islogin = @"1";
        user.isFirst = @(0);
        user.nickName = newInfo.nickName;
        user.userId = newInfo.userId;
        user.headPortrait = newInfo.headPortrait;
        user.goldBalance = newInfo.goldBalance;
        user.balance = newInfo.balance;
        user.province = newInfo.province;
        user.city = newInfo.city;
        user.area = newInfo.area;
        user.address = newInfo.address;
        
        [[XYFMDB sharedDatabase] inDatabase:^{
          iResult = [[XYFMDB sharedDatabase] updateTable:UserInfoTableName object:user whereFormat:[NSString stringWithFormat:@"where mobile = '%@'",currentUser.mobile]];
        }];
      } else {
          iResult = NO;
      }
      if (block) block(iResult, data);
    }
  };
  [api start];
}

- (void)updateUserInfo {
  XYProfileInfoAPI *api = [[XYProfileInfoAPI alloc] initWithUserId:currentUser.userId];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (!error) {
      XYUserInfo *newInfo = [XYUserInfo yy_modelWithJSON:data];
      currentUser.islogin = @"1";
      currentUser.isFirst = @(0);
      currentUser.nickName = newInfo.nickName;
      currentUser.userId = newInfo.userId;
      currentUser.headPortrait = newInfo.headPortrait;
      currentUser.goldBalance = newInfo.goldBalance;
      currentUser.balance = newInfo.balance;
      currentUser.province = newInfo.province;
      currentUser.city = newInfo.city;
      currentUser.area = newInfo.area;
      currentUser.address = newInfo.address;
      
      __block NSArray *array = nil;
      [[XYFMDB sharedDatabase] inDatabase:^{
        array = [[XYFMDB sharedDatabase] queryTable:UserInfoTableName object:[XYUserInfo class] whereFormat:[NSString stringWithFormat:@"where mobile = '%@'",currentUser.mobile]];
      }];
      if (array && array.count > 0) {
        XYUserInfo *user = array.firstObject;
        user.islogin = @"1";
        user.isFirst = @(0);
        user.nickName = newInfo.nickName;
        user.userId = newInfo.userId;
        user.headPortrait = newInfo.headPortrait;
        user.goldBalance = newInfo.goldBalance;
        user.balance = newInfo.balance;
        user.province = newInfo.province;
        user.city = newInfo.city;
        user.area = newInfo.area;
        user.address = newInfo.address;
        
        [[XYFMDB sharedDatabase] inDatabase:^{
          [[XYFMDB sharedDatabase] updateTable:UserInfoTableName object:user whereFormat:[NSString stringWithFormat:@"where mobile = '%@'",currentUser.mobile]];
        }];
      }
    }
  };
  [api start];
}

- (void)fetchIsNeedPerfectInfoWithBlock:(void(^)(BOOL ret))block {
  XYProfileInfoAPI *api = [[XYProfileInfoAPI alloc] initWithUserId:currentUser.userId];
  api.filterCompletionHandler = ^(NSDictionary * data, XYError * _Nullable error) {
    if (error) {
      if (block) block(YES);
    } else {
      id isPerfectDetail = data[@"isPerfectDetail"];
      if ([isPerfectDetail isKindOfClass:[NSNumber class]]) {
        if (block) block(((NSNumber *)isPerfectDetail).integerValue == 1);
      } else {
        if (block) block(YES);
      }
    }
  };
  [api start];
}

- (void)updateCurrentUserWithIsFirst:(NSNumber *)isFirst block:(void(^)(BOOL success))block {
  currentUser.isFirst = isFirst;
  __block NSArray *array = nil;
  [[XYFMDB sharedDatabase] inDatabase:^{
    array = [[XYFMDB sharedDatabase] queryTable:UserInfoTableName object:[XYUserInfo class] whereFormat:[NSString stringWithFormat:@"where mobile = '%@'",currentUser.mobile]];
  }];
  __block BOOL iResult;
  if (array && array.count > 0) {
    XYUserInfo *user = array.firstObject;
    user.isFirst = isFirst;
    [[XYFMDB sharedDatabase] inDatabase:^{
      iResult = [[XYFMDB sharedDatabase] updateTable:UserInfoTableName object:user whereFormat:[NSString stringWithFormat:@"where mobile = '%@'",currentUser.mobile]];
    }];
  } else {
      iResult = NO;
  }
  if (block) block(iResult);
}

- (void)updateCurrentUserWithStatus:(NSNumber *)status block:(void(^)(BOOL success))block {
  currentUser.status = status;
  __block NSArray *array = nil;
  [[XYFMDB sharedDatabase] inDatabase:^{
    array = [[XYFMDB sharedDatabase] queryTable:UserInfoTableName object:[XYUserInfo class] whereFormat:[NSString stringWithFormat:@"where mobile = '%@'",currentUser.mobile]];
  }];
  __block BOOL iResult;
  if (array && array.count > 0) {
    XYUserInfo *user = array.firstObject;
    user.status = status;
    [[XYFMDB sharedDatabase] inDatabase:^{
      iResult = [[XYFMDB sharedDatabase] updateTable:UserInfoTableName object:user whereFormat:[NSString stringWithFormat:@"where mobile = '%@'",currentUser.mobile]];
    }];
  } else {
      iResult = NO;
  }
  if (block) block(iResult);
}

- (void)cleanUserDataWithMobile:(NSString *)mobile block:(void(^)(BOOL ret))block {
  __block NSArray *array = nil;
  [[XYFMDB sharedDatabase] inDatabase:^{
    array = [[XYFMDB sharedDatabase] queryTable:UserInfoTableName object:[XYUserInfo class] whereFormat:[NSString stringWithFormat:@"where mobile = '%@'",mobile]];
  }];
  __block BOOL iResult;
  if (array && array.count > 0) {
    XYUserInfo *user = array.firstObject;
    user.userId =  nil;
    user.realName = @"";
    user.nickName = @"";
    user.headPortrait = @"";
    user.sex = nil;
    user.isFirst = nil;
    user.goldBalance = nil;
    user.balance = nil;
    user.province = @"";
    user.city = @"";
    user.area = @"";
    user.address = @"";
    user.birthdate = @"";
    user.token = @"";
    user.invitationCode = @"";
    user.status = nil;
    user.islogin = nil;
    [[XYFMDB sharedDatabase] inDatabase:^{
      iResult = [[XYFMDB sharedDatabase] updateTable:UserInfoTableName object:user whereFormat:[NSString stringWithFormat:@"where mobile = '%@'",mobile]];
    }];
  } else {
      iResult = NO;
  }
  if (iResult) {
      currentUser = nil;
      [[NSNotificationCenter defaultCenter] postNotificationName:XYLogoutNotificationName object:nil];
  }
  if (block) block(iResult);

}

- (void)onUserStatus:(NSNotification *)notification {
    TUIUserStatus status = [notification.object integerValue];
    switch (status) {
        case TUser_Status_ForceOffline:{
          [self kickoutCurrentUser];
        }
            break;
        case TUser_Status_ReConnFailed:{
          DLog(@"连网失败");
        }
            break;
        case TUser_Status_SigExpired:{
          DLog(@"userSig过期");
          [self kickoutCurrentUser];
        }
            break;
        default:
            break;
    }
}

- (BOOL)creatUserTable {
  __block BOOL ret;
  [[XYFMDB sharedDatabase] inDatabase:^{
    ret = [[XYFMDB sharedDatabase] createTable:UserInfoTableName
                                         object:@{
                                                  @"islogin":SqlText,
                                                  @"mobile":SqlText,
                                                  @"isFirst":SqlInteger,
                                                  @"userId":SqlInteger,
                                                  @"status":SqlInteger,
                                                  @"realName":SqlText,
                                                  @"nickName":SqlText,
                                                  @"sex":SqlInteger,
                                                  @"province":SqlText,
                                                  @"city":SqlText,
                                                  @"area":SqlText,
                                                  @"address":SqlText,
                                                  @"birthdate":SqlText,
                                                  @"goldBalance":SqlInteger,
                                                  @"balance":SqlInteger,
                                                  @"headPortrait":SqlText,
                                                  @"invitationCode":SqlText,
                                                  @"imLoginSign":SqlText,
                                                  @"token":SqlText,
                                                  }
                                  uniqueColumns:@"mobile"];
  }];
  
  return ret;
}

-(void)getUserInfoWithUserId:(NSNumber *)userId block:(void (^)(BOOL, NSDictionary *info))block{
  
  XYProfileDetailAPI *api = [[XYProfileDetailAPI alloc]initWithUserId:userId?:@(0)];
 // @weakify(self);
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    if (block) {
      block(!error,data);
    }
   // @strongify(self);
    //self.InfoObject = [[XYFirendInfoObject alloc]initWithType:0 infoObj:data];;
   // obj.infoObj = data;
   // [self.tableView reloadData];
  };
  [api start];
  
}
@end
