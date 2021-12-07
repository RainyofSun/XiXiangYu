//
//  XYBlindProfileModel.h
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import <Foundation/Foundation.h>

@interface XYBlindProfileModel : NSObject
@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, copy) NSString * headPortrait;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, strong) NSNumber * sex;
@property (nonatomic, copy) NSString * province;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * area;
@property (nonatomic, copy) NSString * town;
@property (nonatomic, copy) NSString * townName;

@property (nonatomic, strong) NSNumber * age;
@property (nonatomic, strong) NSNumber * isFollow;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, strong) NSNumber * distance;
@property (nonatomic, strong) NSNumber * height;

@property (nonatomic, copy) NSArray <NSString *> * images;
@property (nonatomic, strong) NSNumber * weight;
@property (nonatomic, copy) NSString * education;
@property (nonatomic, copy) NSString * educationName;
@property (nonatomic, strong) NSNumber * isCar;
@property (nonatomic, strong) NSNumber * isHouse;

@property (nonatomic, copy) NSString * dwellProvince;
@property (nonatomic, copy) NSString * dwellCity;
@property (nonatomic, copy) NSString * dwellArea;
@property (nonatomic, copy) NSString * oneIndustry;
@property (nonatomic, copy) NSString * twoIndustry;
@property (nonatomic, copy) NSString * intentionDate;
@property (nonatomic, copy) NSString * claimStr;
@property (nonatomic, copy) NSString * jobs;

@property (nonatomic, copy) NSString * disposition;
@property (nonatomic, copy) NSNumber * salaryStart;
@property (nonatomic, copy) NSNumber * salaryEnd;

@property (nonatomic, strong) NSNumber * isFriend;
@property (nonatomic, strong) NSNumber * follow;

@property (nonatomic,assign) CGFloat remarkHeight;
@property (nonatomic,assign) CGFloat profileInfoHeight;


@property(nonatomic,strong)NSArray *itemData;
@end

@interface XYBlindGiftModel : NSObject

@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, copy) NSString * orderNo;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSNumber * destUserId;
@property (nonatomic, copy) NSString * giftName;
@property (nonatomic, copy) NSString * giftIconUrl;
@property (nonatomic, strong) NSNumber * giftNum;
@property (nonatomic, strong) NSNumber * giftAmt;
@property (nonatomic, strong) NSNumber * payType;
@property (nonatomic, copy) NSString * payTime;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * headPortrait;
@property (nonatomic, copy) NSString * animation;
@property (nonatomic, strong) NSNumber * type;//1.短视频 2.相亲

@end
