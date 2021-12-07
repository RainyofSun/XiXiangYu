//
//  CustomTCommonPendencyCellData.h
//  Xiangyu
//
//  Created by Kang on 2021/6/3.
//

#import "TCommonPendencyCellData.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^backBlock)(id   obj);
@interface CustomTCommonPendencyCellData : TCommonPendencyCellData
-(void)agreeWithBlock:(backBlock)block;
@end

NS_ASSUME_NONNULL_END
