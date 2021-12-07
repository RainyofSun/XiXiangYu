//
//  XYUserService.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/16.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYUserInfo.h"
#import "XYPerfectProfileModel.h"

@interface XYUserService : NSObject


+ (instancetype)service;

- (void)start;

/** 是否登录 */
- (BOOL)isLogin;

/** 获取当前登录用户 */
- (XYUserInfo *)fetchLoginUser;

/** 获取上次操作用户 */
- (XYUserInfo *)fetchHandleUser;

/** 登录用户 */
- (void)loginUser:(XYUserInfo *)user
    isNeedPerfect:(BOOL)isNeedPerfect
        withBlock:(void(^)(BOOL success))block;

- (void)fetchIsNeedPerfectInfoWithBlock:(void(^)(BOOL ret))block;

- (void)updateCurrentUserWithIsFirst:(NSNumber *)isFirst block:(void(^)(BOOL success))block;

- (void)updateCurrentUserWithStatus:(NSNumber *)status block:(void(^)(BOOL success))block;

- (void)updateNoNeedPerfectBlock:(void(^)(BOOL success, NSDictionary *info))block;

/** 登出当前用户，清空会话和密码 */
- (void)logoutUserWithBlock:(void(^)(BOOL success))block;

/** 用户被踢出系统，清空数据 */
- (void)kickoutCurrentUser;

//  

-(void)getUserInfoWithUserId:(NSNumber *)userId block:(void(^)(BOOL success,NSDictionary *info))block;


@end
