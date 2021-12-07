//
//  XYWalletItemModel.h
//  Xiangyu
//
//  Created by Kang on 2021/6/29.
//

#import <Foundation/Foundation.h>
#import "XYPageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYWalletItemModel : NSObject
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,strong) NSString *orderNo;
@property (nonatomic,strong) NSNumber *billType;
@property (nonatomic,strong) NSNumber *inOrOut;
@property (nonatomic,strong) NSNumber *amt;

@property (nonatomic,strong) NSNumber *balance;
@property (nonatomic,strong) NSNumber *payType;
@property (nonatomic,strong) NSNumber *currencyType;
@property (nonatomic,strong) NSNumber *isRefund;
 
@property (nonatomic,strong) NSString *remark;

@property (nonatomic,strong) NSString *createTime;
@end
@interface XYWalletItemModelList : NSObject
@property (nonatomic,strong) NSArray *list;
@property (nonatomic,strong) XYPageModel *page;
@end
//
NS_ASSUME_NONNULL_END
