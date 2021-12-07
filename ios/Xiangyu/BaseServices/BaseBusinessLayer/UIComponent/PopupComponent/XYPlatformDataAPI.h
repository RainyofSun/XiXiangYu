//
//  XYPlatformDataAPI.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/18.
//

#import "XYBaseAPI.h"

@interface XYSwitchAPI : XYBaseAPI

@end

@interface XYCharacterAPI : XYBaseAPI

@end

@interface XYPositionAPI : XYBaseAPI

@end

@interface XYHeightAPI : XYBaseAPI

@end

@interface XYDeuAPI : XYBaseAPI

@end

@interface XYSalaryAPI : XYBaseAPI

@end

@interface XYShopAPI : XYBaseAPI

@end

@interface XYIndustryAPI : XYBaseAPI

@end

@interface XYSchoolAPI : XYBaseAPI

- (instancetype)initWithProvice:(NSString *)provice
                           city:(NSString *)city
                           area:(NSString *)area
                           type:(NSNumber *)type;

@end

@interface XYRatesConfigAPI : XYBaseAPI

- (instancetype)initWithType:(NSUInteger)type;

@end
