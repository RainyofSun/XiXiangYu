//
//  XYSendHeartBeatView.h
//  Xiangyu
//
//  Created by Kang on 2021/7/4.
//

#import "FWPopupBaseView.h"
#import "XYBlindDataItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYSendHeartBeatView : FWPopupBaseView
@property(nonatomic,strong)NSArray *texts;
@property(nonatomic,strong)NSArray *conf;
@property(nonatomic,strong)NSNumber *heartNum;
@property(nonatomic,strong)XYBlindDataItemModel *model;

@property(nonatomic,copy)void(^block)(XYError *error) ;
@end

NS_ASSUME_NONNULL_END
