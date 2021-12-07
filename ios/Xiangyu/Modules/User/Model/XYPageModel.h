//
//  XYPageModel.h
//  Xiangyu
//
//  Created by Kang on 2021/6/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYPageModel : NSObject
@property (nonatomic,strong) NSNumber *pageSize;
@property (nonatomic,strong) NSNumber *pageCount;
@property (nonatomic,strong) NSNumber *pageIndex;
@end

NS_ASSUME_NONNULL_END
