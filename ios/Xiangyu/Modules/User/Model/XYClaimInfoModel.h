//
//  XYClaimInfoModel.h
//  Xiangyu
//
//  Created by Kang on 2021/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYClaimInfoModel : NSObject
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,strong) NSString *orderNo;
@property (nonatomic,strong) NSString *education;
@property (nonatomic, copy) NSString * educationName;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSNumber *status;
@property (nonatomic,strong) NSNumber *startHeight;
@property (nonatomic,strong) NSNumber *endAge;
@property (nonatomic,strong) NSNumber *salaryStart;
@property (nonatomic,strong) NSNumber *sort;
@property (nonatomic,strong) NSString *dwellCity;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *town;
@property (nonatomic,strong) NSString *twoIndustry;
@property (nonatomic,strong) NSNumber *isDel;
@property (nonatomic,strong) NSNumber *isTop;
@property (nonatomic,strong) NSNumber *salaryEnd;
@property (nonatomic,strong) NSNumber *endHeight;
@property (nonatomic,strong) NSNumber *startAge;
@property (nonatomic,strong) NSString *oneIndustry;
@property (nonatomic,strong) NSString *dwellArea;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *resource;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *dwellProvince;

@property(nonatomic,strong)NSString *dwelladdress;
@property(nonatomic,strong)NSString *address;
@end

NS_ASSUME_NONNULL_END
