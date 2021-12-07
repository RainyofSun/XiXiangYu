//
//  XYDynamicsModel.h
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import <Foundation/Foundation.h>

@interface XYTimelineProfileModel : NSObject

@property (nonatomic, strong) NSNumber * giftCount;
@property (nonatomic, copy) NSString * twoIndustry;
@property (nonatomic, copy) NSString * oneIndustry;
@property (nonatomic, strong) NSNumber * fansCount;
@property (nonatomic, strong) NSNumber * followCount;
@property (nonatomic, strong) NSNumber * sex;
@property (nonatomic, strong) NSNumber * likeCount;
@property (nonatomic, strong) NSNumber * isFollow;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, copy) NSString * province;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * area;
@property (nonatomic, copy) NSString * nickName;
@property (nonatomic, copy) NSString * headPortrait;

@property (nonatomic, assign) BOOL  isFriends;

@end
