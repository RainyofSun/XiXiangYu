//
//  XYBannerModel.h
//  Xiangyu
//
//  Created by Kang on 2021/7/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYBannerModel : NSObject
@property(nonatomic,strong)NSNumber *id;
@property(nonatomic,strong)NSNumber *showType;
@property(nonatomic,strong)NSNumber *skipType;
@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,strong)NSNumber *isDel;

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,strong)NSString *jumpLink;
@property(nonatomic,strong)NSString *startTime;
@property(nonatomic,strong)NSString *endTime;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *content;
@end

@interface XYBannerModelList : NSObject

@end

NS_ASSUME_NONNULL_END
