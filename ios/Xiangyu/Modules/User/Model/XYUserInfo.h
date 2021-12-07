//
//  XYUserInfo.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/11/15.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYUserInfo : NSObject

@property (nonatomic,copy) NSString *islogin;

@property (nonatomic, strong) NSNumber *isFirst;

@property (nonatomic,copy) NSString * mobile;

@property (nonatomic,copy) NSString *realName;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,copy) NSString *headPortrait;

@property (nonatomic,strong) NSNumber *sex;

@property (nonatomic,strong) NSNumber *goldBalance;

@property (nonatomic,strong) NSNumber *balance;

@property (nonatomic,copy) NSString *province;

@property (nonatomic,copy) NSString *city;

@property (nonatomic,copy) NSString *area;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,copy) NSString *birthdate;

@property (nonatomic,copy) NSString *token;

@property (nonatomic,strong) NSNumber *status;

@property (nonatomic,copy) NSString *invitationCode;

@property (nonatomic,copy) NSString *imLoginSign;

@property (nonatomic,copy) NSString *education;

@end
