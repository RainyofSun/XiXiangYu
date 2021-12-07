//
//  XYTimelineVideoDataManager.h
//  Xiangyu
//
//  Created by dimon on 23/02/2021.
//

#import <Foundation/Foundation.h>
#import "XYTimelineVideoModel.h"
#import "GKDYVideoModel.h"

@interface XYTimelineVideoDataManager : NSObject

@property (nonatomic,strong) NSNumber *userID;

@property(nonatomic,strong) NSMutableArray <XYTimelineVideoModel *> * videos;

@property(nonatomic,strong) NSMutableArray <XYTimelineVideoModel *> * likesVideos;

- (void)fetchNewDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block;

- (void)fetchNextPageDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block;


- (void)fetchLikesNewDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block;

- (void)fetchLikesNextPageDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block;

- (void)deleteVideoWithIndex:(NSUInteger)index block:(void(^)(XYError * error))block;

- (GKDYVideoModel *)createVideoDataWithIndex:(NSUInteger)index;

- (GKDYVideoModel *)createLikesVideoDataWithIndex:(NSUInteger)index;

@end
