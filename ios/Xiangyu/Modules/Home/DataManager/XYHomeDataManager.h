//
//  XYHomeDataManager.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import <Foundation/Foundation.h>
#import "XYInterestModel.h"
#import "XYHomeSectionInfo.h"
#import "XYLocationService.h"
#import "XYHomeSearchResultModel.h"

@interface XYHomeDataManager : NSObject

@property (nonatomic,weak) id target;

@property (nonatomic,strong) XYFormattedArea *currentArea;

@property (strong, nonatomic, readonly) NSMutableArray <XYHomeSectionInfo *>*models;

- (void)fetchViewDataWithBlock:(void(^)(BOOL ret))block;

- (void)sendLocationBatchAPIRequestsWithLocationHandler:(void(^)(NSString *cityName))locationHandler pageDataBlock:(void(^)(void))pageDataBlock;

- (void)switchLocationBatchAPIRequestsWithItem:(XYAddressItem *)item pageDataBlock:(void(^)(void))pageDataBlock;

- (void)fetchInterestDataWithBlock:(void(^)(NSArray <XYInterestItem *>* data))block;

- (void)fetchTaskListDataWithBlock:(void(^)(BOOL needRefresh))block;

- (void)fetchBannerDataWithBlock:(void(^)(BOOL needRefresh))block;

- (void)followUserId:(NSNumber *)userId block:(void(^)(NSUInteger index, NSDictionary *info, XYError *error))block;

- (void)searchWithWords:(NSString *)words block:(void(^)(XYHomeSearchResultModel* data))block;

- (void)receiveTaskWithIndex:(NSUInteger)index block:(void(^)(XYError *error))block;

//- (void)expandTaskCellDataWithIndexPath:(NSIndexPath *)indexPath block:(void(^)(void))block;

- (void)updatePushToken;

@end
