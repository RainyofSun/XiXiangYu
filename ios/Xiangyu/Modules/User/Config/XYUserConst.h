//
//  XYUserConst.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/12/2.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XYCheckCodeType) {
    XYCheckCodeTypeDefault = 1,
    XYCheckCodeTypeRegister,
    XYCheckCodeTypeModifyPassword
};

#pragma mark - 当前操作用户

XY_EXTERN NSString *const CurrentUserMobileKeyName;

#pragma mark - 数据库表名

XY_EXTERN NSString *const UserInfoTableName;

#pragma mark - 常量字符串

XY_EXTERN NSString *const XYLogin_VerifyMobileNULLError;

XY_EXTERN NSString *const XYLogin_VerifyMobileError;

XY_EXTERN NSString *const XYLogin_VerifyCodeNULLError;

XY_EXTERN NSString *const XYLogin_VerifyCodeError;

XY_EXTERN NSString *const XYLogin_VerifyPwdNULLError;

XY_EXTERN NSString *const XYLogin_VerifyPwdError;

XY_EXTERN NSString *const XYLogin_VerifySexNULLError;

XY_EXTERN NSString *const XYLogin_VerifyNickNameNULLError;

XY_EXTERN NSString *const XYLogin_VerifyNickNameError;
