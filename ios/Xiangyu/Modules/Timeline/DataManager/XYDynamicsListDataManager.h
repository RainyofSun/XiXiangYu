//
//  XYDynamicsListDataManager.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import <Foundation/Foundation.h>
#import "XYDynamicLayout.h"

typedef NS_ENUM(NSInteger, XYDynamicsViewType) {
  XYDynamicsViewType_Recommend  = 1,
  XYDynamicsViewType_Attention  = 2,
  XYDynamicsViewType_Mine  = 3,
  XYDynamicsViewType_Others  = 4,
  XYDynamicsViewType_None  = 5,
};

@interface XYDynamicsListDataManager : NSObject

@property (nonatomic,strong) NSNumber *hisUserId;

@property (nonatomic, assign) XYDynamicsViewType dataType;
@property (nonatomic, strong) XYFormattedArea *area;
@property(nonatomic,strong) NSMutableArray <XYDynamicLayout *> * layoutsArr;

@property(nonatomic,strong) NSArray <NSDictionary *> * bannerData;

- (void)insertDynamics:(NSArray <XYDynamicsModel *> *)dynamics;

- (void)fetchNewDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block;

- (void)fetchNextPageDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block;

- (void)thunmbDynamicsWithIndex:(NSUInteger)index block:(void(^)(XYDynamicLayout *layout, XYError * error))block;

- (void)followUserWithIndex:(NSUInteger)index block:(void(^)(XYDynamicLayout *layout, XYError * error))block;

- (void)deleteDynamicWithIndex:(NSUInteger)index block:(void(^)(XYError * error))block;

- (void)fetchBannerDataWithBlock:(void(^)(NSArray *imageUrls))block;

@end
