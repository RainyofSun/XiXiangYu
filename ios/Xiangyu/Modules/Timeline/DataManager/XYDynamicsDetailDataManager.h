//
//  XYDynamicsDetailDataManager.h
//  Xiangyu
//
//  Created by dimon on 09/02/2021.
//

#import <Foundation/Foundation.h>
#import "XYDynamicsModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickUrlBlock)(NSString * url);
typedef void(^ClickPhoneNumBlock)(NSString * phoneNum);

@interface XYDynamicsDetailDataManager : NSObject

@property (nonatomic,strong) XYDynamicsModel *dynamicsModel;

@property (nonatomic,assign) CGFloat headerHeight;

@property (nonatomic, copy) NSArray <XYLikesUserModel *> *likesUserArray;

@property (nonatomic, copy) NSMutableArray <XYCommentModel *> *commentsArray;

@property(nonatomic,strong)YYTextLayout * detailLayout;

@property(nonatomic,copy)ClickUrlBlock clickUrlBlock;

@property(nonatomic,copy)ClickPhoneNumBlock clickPhoneNumBlock;

- (void)layoutViewData;

- (void)followUserWithBlock:(void(^)(XYError * error))block;

- (void)deleteDynamicWithBlock:(void(^)(XYError * error))block;

- (void)deleteCommentWithIndex:(NSUInteger)index block:(void(^)(XYError * error))block;

- (void)postCommont:(NSString *)commont block:(void(^)(XYError * error))block;

- (void)fetchNewPageDataWithLikesErrorBlock:(void(^)(XYError * error))likesErrorBlock
                          commentErrorBlock:(void(^)(XYError * error))commentErrorBlock
                                 completion:(void(^)(void))completion;

- (void)fetchNextPageDataWithBlock:(void(^)(BOOL needRefresh, XYError * error))block;
@end

NS_ASSUME_NONNULL_END
