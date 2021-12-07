//
//  NSUUID+Extension.m
//  TopjetPicking
//
//  Created by 沈阳 on 2017/8/9.
//  Copyright © 2017年 ShangHai Topjet Information & Technology Co. Ltd. All rights reserved.
//

#import "NSUUID+Extension.h"
#import "YYKeychain.h"

static NSString * const KeychainSerice_UUID = @"com.xianmeng.Xiangyu_service_UUID";
static NSString * const KeychainAcount_UUID = @"com.xianmeng.Xiangyu_acount_UUID";

@implementation NSUUID (Extension)
+ (NSString *)keychainUUID {
    NSError *queryError;
    NSString *UUIDString = [YYKeychain getPasswordForService:KeychainSerice_UUID account:KeychainAcount_UUID error:&queryError];
    if (UUIDString.isNotBlank && !queryError) {
        return UUIDString;
    } else {
        NSString *UUIDString = [UIDevice currentDevice].identifierForVendor.UUIDString;
        [YYKeychain setPassword:UUIDString forService:KeychainSerice_UUID account:KeychainAcount_UUID];
        
        return UUIDString;
    }
    
}
@end
