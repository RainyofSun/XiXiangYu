//
//  XYBlindDateHelpMiAPI.h
//  Xiangyu
//
//  Created by Kang on 2021/7/1.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYBlindDateHelpMiAPI : XYBaseAPI
- (instancetype)initWithId:(NSNumber *)Id;
@end
///api/v1/BlindDate/GetProfessConf

@interface XYBlindDateProfessConfAPI : XYBaseAPI

@end

@interface XYBlindDateCreateProfessAPI : XYBaseAPI
- (instancetype)initWithId:(NSNumber *)blindDateId destUserId:(NSNumber *)destUserId content:(NSString *)content;
@end


@interface XYBlindDateGetProfessListAPI : XYBaseAPI
- (instancetype)initWithPage:(NSInteger)page;
@end

NS_ASSUME_NONNULL_END
