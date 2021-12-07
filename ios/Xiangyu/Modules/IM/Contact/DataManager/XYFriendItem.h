//
//  XYFriendItem.h
//  Xiangyu
//
//  Created by dimon on 04/02/2021.
//

#import <Foundation/Foundation.h>

@interface XYFriendDataReq : NSObject

@property (nonatomic, strong) NSNumber * latitude;

@property (nonatomic, strong) NSNumber * longitude;

@property (nonatomic, copy) NSString * province;

@property (nonatomic, copy) NSString * city;

@property (nonatomic, copy) NSString * area;

@property (nonatomic, copy) NSString * dwellProvince;

@property (nonatomic, copy) NSString * dwellCity;

@property (nonatomic, copy) NSString * dwellArea;

@property (nonatomic, copy) NSString * town;

@property (nonatomic, copy) NSNumber * oneIndustry;

@property (nonatomic, copy) NSNumber * twoIndustry;

@property (nonatomic, strong) NSString * middleSchool;
@property (nonatomic, strong) NSString * middleTime;
@property (nonatomic, strong) NSString * highSchool;
@property (nonatomic, strong) NSString * highTime;
@property (nonatomic, strong) NSNumber * startAge;

@property (nonatomic, strong) NSNumber * endAge;

@property (nonatomic, strong) NSNumber * startHeight;

@property (nonatomic, strong) NSNumber * endHeight;

@property (nonatomic, copy) NSString * education;

@property (nonatomic, strong) NSNumber * distance;

@property (nonatomic, strong) NSNumber * sex;

@property (nonatomic, copy) NSString * keyword;


@end

@interface XYFriendItem : NSObject

@property (nonatomic, copy) NSString * headPortrait;

@property (nonatomic, copy) NSString * nickName;

@property (nonatomic, copy) NSString * oneIndustry;

@property (nonatomic, copy) NSString * twoIndustry;

@property (nonatomic, copy) NSString * provinceName;

@property (nonatomic, copy) NSString * cityName;

@property (nonatomic, copy) NSString * areaName;

@property (nonatomic, copy) NSString * province;

@property (nonatomic, copy) NSString * city;

@property (nonatomic, copy) NSString * area;

@property (nonatomic, strong) NSNumber * distance;

@property (nonatomic, strong) NSNumber * userId;

@property (nonatomic, strong) NSNumber * sex;

@property (nonatomic, strong) NSNumber * isFriend;

@end

