//
//  XYIndustryCircleDataManager.h
//  Xiangyu
//
//  Created by dimon on 04/02/2021.
//

#import <Foundation/Foundation.h>
#import "XYFriendItem.h"
#import "XYPlatformService.h"
#import "XYInterestModel.h"

@interface XYIndustryCircleDataManager : NSObject

@property (nonatomic, strong) NSArray <NSString *> *titleArray;

@property (nonatomic, strong) NSMutableArray <XYSchoolModel *> *juniorSchoolDatas;

@property (nonatomic, strong) NSMutableArray <XYSchoolModel *> *seniorSchoolDatas;

@property (nonatomic, strong) NSMutableArray *juniorSchoolNameDatas;

@property (nonatomic, strong) NSMutableArray *seniorSchoolNameDatas;

@property (nonatomic, strong) NSArray <XYIndustryModel *> *industryDatas;

@property (nonatomic, strong) NSMutableArray <XYInterestItem *> * friendsData;

@property (nonatomic, strong) XYFriendDataReq *reqParams;

- (void)fetchIndustryDataWithBlock:(void(^)(BOOL ret))block;

- (void)fetchJuniorSchoolDataWithBlock:(void(^)(BOOL ret))block;

- (void)fetchSeniorSchoolDataWithBlock:(void(^)(BOOL ret))block;

- (void)switchHomeTownWithProvice:(NSString *)provice city:(NSString *)city area:(NSString *)area WithBlock:(void(^)(BOOL needRefresh, XYError * error))block;

- (void)switchPresentAddressWithProvice:(NSString *)provice city:(NSString *)city area:(NSString *)area WithBlock:(void(^)(BOOL needRefresh, XYError * error))block;

- (void)switchJuniorSchoolWithIndex:(NSUInteger)index block:(void(^)(BOOL needRefresh, XYError * error))block;

- (void)switchSeniorSchoolWithIndex:(NSUInteger)index block:(void(^)(BOOL needRefresh, XYError * error))block;

- (void)switchIndustryWithOneIndex:(NSUInteger)oneIndex
                       secondIndex:(NSUInteger)secondIndex
                             block:(void(^)(BOOL needRefresh, XYError * error))block;

- (void)fetchNewDataWithBlock:(void(^)(BOOL needRefresh, XYError * error))block;

- (void)fetchNextDataWithBlock:(void(^)(BOOL needRefresh, XYError * error))block;

@end
