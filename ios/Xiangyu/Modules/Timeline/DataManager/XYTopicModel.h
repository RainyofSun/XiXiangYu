//
//  XYTopicModel.h
//  Xiangyu
//
//  Created by Kang on 2021/7/3.
//

#import <Foundation/Foundation.h>
#import "XYPageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYTopicModel : NSObject
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *remark;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSNumber *releaseCount;
@property (nonatomic,strong) NSNumber *readCount;
@property (nonatomic,strong) NSNumber *fiery;
@property (nonatomic,strong) NSNumber *isNew;
@property (nonatomic,strong) NSString *createTime;
@end
@interface XYTopicListModel : NSObject
@property(nonatomic,strong)NSArray *list;
@property(nonatomic,strong)XYPageModel *page;
@end
NS_ASSUME_NONNULL_END
