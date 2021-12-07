//
//  XYAddressItem.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/23.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XYAddressLevel) {
    XYAddressLevelFirst,
    XYAddressLevelSecond,
    XYAddressLevelThird
};

@interface XYAddressItem : NSObject

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, copy) NSString *firstLetter;

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic,assign) BOOL isSelected;

@end

@interface XYFormattedArea : NSObject

@property (nonatomic, assign) CGFloat latitude;

@property (nonatomic, assign) CGFloat longitude;

@property (nonatomic, copy) NSString *provinceCode;

@property (nonatomic, copy) NSString *provinceName;

@property (nonatomic, copy) NSString *cityCode;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *districtName;

@property (nonatomic, copy) NSString *townCode;

@property (nonatomic, copy) NSString *townName;

@property (nonatomic, copy) NSString *formattedAddress;

@end

@interface XYIPLocationModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *info;

@property (nonatomic, copy) NSString *infocode;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *adcode;

@property (nonatomic, copy) NSString *rectangle;

@end
