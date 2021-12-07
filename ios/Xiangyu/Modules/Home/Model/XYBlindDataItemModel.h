//
//  XYBlindDataItemModel.h
//  Xiangyu
//
//  Created by Kang on 2021/6/29.
//

#import <Foundation/Foundation.h>
#import "XYPageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYBlindDataItemModel : NSObject
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,strong) NSNumber *userId;
@property (nonatomic,strong) NSString *headPortrait;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSNumber *status;
@property (nonatomic,strong) NSNumber *sex;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *area;
@property (nonatomic,strong) NSString *town;
@property (nonatomic,strong) NSString *townName;
@property (nonatomic,strong) NSNumber *age;
@property (nonatomic,strong) NSNumber *isFollow;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSNumber *distance;
@property (nonatomic,strong) NSNumber *height;
@property (nonatomic,strong) NSNumber *weight;
@property (nonatomic,strong) NSString *resource;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSString *addressDec;
//
@end
@interface XYBlindDataItemListModel : NSObject
@property(nonatomic,strong)NSArray *list;
@property(nonatomic,strong)XYPageModel *page;
@end

NS_ASSUME_NONNULL_END
