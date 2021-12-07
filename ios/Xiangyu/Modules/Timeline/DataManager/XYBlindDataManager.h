//
//  XYBlindDataManager.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import <Foundation/Foundation.h>
#import "XYBlindProfileModel.h"
#import "XYClaimInfoModel.h"
@interface XYBlindDataManager : NSObject

@property (nonatomic,strong) XYBlindProfileModel *model;
@property(nonatomic,strong)XYClaimInfoModel *claimModel;
@property (nonatomic,copy) NSArray <XYBlindGiftModel *> *giftList;

@property (nonatomic, strong) YYTextLayout * profileLayout;

@property (nonatomic, strong) YYTextLayout * introductionLayout;

@property (nonatomic,strong) NSAttributedString *likesAttrString;

@property (nonatomic,strong) NSNumber *userId;

@property (nonatomic,strong) NSNumber *blindId;

- (void)fetchUserInfoWithBlock:(void(^)(XYError * error))block;

- (void)followUserWithBlock:(void(^)(XYError * error))block;

@end
