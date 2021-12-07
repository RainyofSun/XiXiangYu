//
//  XYProfileInfo.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYProfileInfo : NSObject

@property (nonatomic,copy) NSString *headPortrait;

@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,strong) NSNumber *status;

@property (nonatomic,strong) NSNumber *goldBalance;

@property (nonatomic,strong) NSNumber *friends;

@property (nonatomic,strong) NSNumber *follow;

@property (nonatomic,strong) NSNumber *fans;

@property (nonatomic,strong) NSNumber *appreciate;

@property (nonatomic,strong) NSNumber *giftCount;

// 1.0.2 新增两个字短。钱包、心动
@property (nonatomic,strong) NSNumber *balance;
@property (nonatomic,strong) NSNumber *allXdCount;
//-----

@property (nonatomic,strong) NSNumber *backOrders;

@property (nonatomic,strong) NSNumber *stayGoods;

@property (nonatomic,strong) NSNumber *goodsComplete;

@property (nonatomic,strong) NSNumber *isPush;

@property (nonatomic,strong) NSNumber *isFirst;

@end

NS_ASSUME_NONNULL_END
