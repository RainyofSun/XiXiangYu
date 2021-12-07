//
//  XYSearchVideoDataManager.h
//  Xiangyu
//
//  Created by dimon on 17/03/2021.
//

#import <Foundation/Foundation.h>
#import "XYTimelineVideoModel.h"
#import "XYFriendItem.h"
#import "GKDYVideoModel.h"

@interface XYSearchVideoDataManager : NSObject

@property (nonatomic, copy) NSString* words;

@property(nonatomic,strong) NSMutableArray <XYTimelineVideoModel *> * videos;

@property(nonatomic,strong) NSMutableArray <XYFriendItem *> * authors;

- (void)fetchProductNewDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block;

- (void)fetchProductNextPageDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block;

- (void)fetchAuthorNewDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block;

- (void)fetchAuthorNextPageDataWithBlock:(void(^)(BOOL isNeedRefresh, XYError * error))block;

- (GKDYVideoModel *)createPlayDataWithIndex:(NSUInteger)index;

@end

