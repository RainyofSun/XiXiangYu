//
//  NSString+Checker.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/26.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Checker)

+ (NSString *)randomCreatChineseWithNum:(NSInteger)num;

- (NSString *)formateDateWithFormate:(NSString *)formate;

/** 匹配昵称 */
- (BOOL)isMatchingNickname;

/** 匹配用户姓名 */
- (BOOL)isMatchingUserName;

/** 匹配身份证 */
- (BOOL)isMatchingIdcard;

/** 匹配手机号码 */
- (BOOL)isMatchingPhoneNumber;

/** 匹配密码 */
- (BOOL)isMatchingPassword;

/** 匹配验证码 */
- (BOOL)isMatchingCheckCode;

/** 匹配协会名称 */
- (BOOL)isMatchingAssociationName;

/** 匹配大棚名称 */
- (BOOL)isMatchingGreenhouseName;

/** 匹配评论、投诉、意见反馈内容 */
- (BOOL)isMatchingContentText;

/** 匹配备注内容 */
- (BOOL)isMatchingRemarkText;

@end
