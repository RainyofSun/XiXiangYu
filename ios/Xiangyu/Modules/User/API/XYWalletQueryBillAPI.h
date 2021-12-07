//
//  XYWalletQueryBillAPI.h
//  Xiangyu
//
//  Created by Kang on 2021/6/29.
//

#import "XYBaseAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYWalletQueryBillAPI : XYBaseAPI
- (instancetype)initWithPage:(NSInteger)page;
@end
@interface XYWalletApplyCashAPI : XYBaseAPI
- (instancetype)initWithAmt:(NSNumber*)amt openId:(NSString *)openId payChannel:(NSNumber *)payChannel;
@end
///api/v1/Wallet/GetOAuth2Url
@interface XYWalletOAuth2UrlAPI : XYBaseAPI
@property (nonatomic, assign) XYRequestMethodType      apiRequestMethodType;
@end
///api/v1/Wallet/GetSuperHeartCount
@interface XYWalletSuperHeartCountAPI : XYBaseAPI

@end
NS_ASSUME_NONNULL_END
