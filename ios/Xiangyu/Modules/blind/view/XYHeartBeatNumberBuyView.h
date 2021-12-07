//
//  XYHeartBeatNumberBuyView.h
//  Xiangyu
//
//  Created by Kang on 2021/7/5.
//

#import "FWPopupBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYHeartBeatNumberBuyView : FWPopupBaseView
@property(nonatomic,strong)NSArray *conf;

@property (nonatomic,copy) void(^successBlock)(id item);
@end

NS_ASSUME_NONNULL_END
