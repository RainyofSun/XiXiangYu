//
//  NSString+Checker.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/26.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "NSString+Checker.h"

@implementation NSString (Checker)

- (NSString *)formateDateWithFormate:(NSString *)formate {
    NSDate * nowDate = [NSDate date];
  NSDate * needFormatDate = [NSDate dateWithString:self format:formate];
  
    NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];

    NSString *dateStr = @"";
    
    if (time<=60) {  //// 1分钟以内的
        dateStr = @"刚刚";
    }else if(time<=60*60){  ////  一个小时以内的
        
        int mins = time/60;
        dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
        
    }else if(time<=60*60*24){   //// 在两天内的
      NSString * need_yMd = [needFormatDate stringWithFormat:@"yyyy年MM月dd日"];
      NSString *now_yMd = [nowDate stringWithFormat:@"yyyy年MM月dd日"];
        
      
        if ([need_yMd isEqualToString:now_yMd]) {
            //// 在同一天
          dateStr = [NSString stringWithFormat:@"今天 %@",[needFormatDate stringWithFormat:@"HH:mm"]];
        }else{
            ////  昨天
            dateStr = [NSString stringWithFormat:@"昨天 %@",[needFormatDate stringWithFormat:@"HH:mm"]];
        }
    }else {
        
        NSString * yearStr = [needFormatDate stringWithFormat:@"yyyy"];
        NSString *nowYear = [nowDate stringWithFormat:@"yyyy"];
        
        if ([yearStr isEqualToString:nowYear]) {
            ////  在同一年
            dateStr = [needFormatDate stringWithFormat:@"MM月dd日"];
        }else{
            dateStr = [needFormatDate stringWithFormat:@"yyyy年MM月dd日"];
        }
    }
    
    return dateStr;
    
}

- (BOOL)isMatchingNickname {
    if (!self.isNotBlank) return NO;
    
    if (self.length >= 1 && self.length <= 10) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)randomCreatChineseWithNum:(NSInteger)num {
    
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);

    NSString *string = @"";
    for (int i = 0; i < num; i ++) {
        NSInteger randomH = 0xA1+arc4random()%(0xFE - 0xA1+1);
        NSInteger randomL = 0xB0+arc4random()%(0xF7 - 0xB0+1);
        NSInteger number = (randomH<<8)+randomL;
        NSData *data = [NSData dataWithBytes:&number length:2];
        NSString *characters = [[NSString alloc] initWithData:data encoding:gbkEncoding];
        string = [string stringByAppendingString:characters];
    }

    return string;

}

- (BOOL)isMatchingUserName {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5]{1,20}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
    
}

- (BOOL)isMatchingIdcard {
    NSString *pattern = @"(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
}

- (BOOL)isMatchingPhoneNumber {

    if ([self length] != 11) {
        return NO;
    }
    
//    /**
//     * 规则 -- 更新日期 2017-03-30
//     * 手机号码: 13[0-9], 14[5,7,9], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
//     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
//     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
//     * 电信号段: 133,149,153,170,173,177,180,181,189
//     *
//     * [数据卡]: 14号段以前为上网卡专属号段，如中国联通的是145，中国移动的是147,中国电信的是149等等。
//     * [虚拟运营商]: 170[1700/1701/1702(电信)、1703/1705/1706(移动)、1704/1707/1708/1709(联通)]、171（联通）
//     * [卫星通信]: 1349
//     */
//
//    /**
//     * 中国移动：China Mobile
//     * 134,135,136,137,138,139,147(数据卡),150,151,152,157,158,159,170[5],178,182,183,184,187,188
//     */
//    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(17[8])|(18[2-4,7-8]))\\d{8}|(170[5])\\d{7}$";
//
//    /**
//     * 中国联通：China Unicom
//     * 130,131,132,145(数据卡),155,156,170[4,7-9],171,175,176,185,186
//     */
//    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[156])|(18[5,6]))\\d{8}|(170[4,7-9])\\d{7}$";
//
//    /**
//     * 中国电信：China Telecom
//     * 133,149(数据卡),153,170[0-2],173,177,180,181,189
//     */
//    NSString *CT_NUM = @"^((133)|(149)|(153)|(17[3,7])|(18[0,1,9]))\\d{8}|(170[0-2])\\d{7}$";
//
//    NSPredicate *pred_CM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM_NUM];
//    NSPredicate *pred_CU = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU_NUM];
//    NSPredicate *pred_CT = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT_NUM];
//    BOOL isMatch_CM = [pred_CM evaluateWithObject:self];
//    BOOL isMatch_CU = [pred_CU evaluateWithObject:self];
//    BOOL isMatch_CT = [pred_CT evaluateWithObject:self];
//    if (isMatch_CM || isMatch_CT || isMatch_CU) {
//        return YES;
//    }
    
    return YES;
 
}

- (BOOL)isMatchingPassword {
    if (!self.isNotBlank) return NO;
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
    
}

- (BOOL)isMatchingCheckCode {
    if (!self.isNotBlank) return NO;
    if (self.length == 6) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isMatchingAssociationName {
    if (!self.isNotBlank) return NO;
    if (self.length >= 8 && self.length <= 30) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isMatchingGreenhouseName {
    if (!self.isNotBlank) return NO;
    if (self.length >= 8 && self.length <= 30) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isMatchingContentText {
    if (!self.isNotBlank) return NO;
    if (self.length > 8 && self.length <= 200) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isMatchingRemarkText {
    if (!self.isNotBlank) return NO;
    if (self.length > 0 && self.length <= 100) {
        return YES;
    } else {
        return NO;
    }
}

@end
