//
//  XYHomeSearchResultModel.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import <Foundation/Foundation.h>
#import "XYFriendItem.h"
#import "XYTimelineVideoModel.h"
#import "XYDynamicsModel.h"


@interface XYDemandModel : NSObject

@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSNumber * majorType;
@property (nonatomic, strong) NSNumber * viceType;

@property (nonatomic, copy) NSString * twoIndustryName;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * linkName;
@property (nonatomic, copy) NSString * phone;
@property (nonatomic, copy) NSString * area;

@end

@interface XYActivityModel : NSObject

@property (nonatomic, strong) NSNumber * id;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, strong) NSNumber * majorType;
@property (nonatomic, strong) NSNumber * viceType;

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * validityStart;
@property (nonatomic, copy) NSString * validityEnd;
@property (nonatomic, copy) NSString * resource;

@end

@interface XYHomeSearchResultModel : NSObject

@property (nonatomic,copy) NSArray <XYFriendItem *> *users;

@property (nonatomic,copy) NSArray <XYTimelineVideoModel *> *shortVideo;

@property (nonatomic,copy) NSArray <XYDynamicsModel *> *dynamic;

@property (nonatomic,copy) NSArray <XYDemandModel *> *demand;

@property (nonatomic,copy) NSArray <XYActivityModel *> *activity;

@end
