//
//  XYCarNeedScreenView.h
//  Xiangyu
//
//  Created by Kang on 2021/7/2.
//

#import "FWPopupBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYCarNeedScreenView : FWPopupBaseView

@property(nonatomic,strong)NSDictionary *dic;

@property (nonatomic,copy) void(^selectedBlock)(NSDictionary *item);
@end

NS_ASSUME_NONNULL_END
