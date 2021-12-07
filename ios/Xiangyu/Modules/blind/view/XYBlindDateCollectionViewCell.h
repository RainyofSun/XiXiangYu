//
//  XYBlindDateCollectionViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
//

#import <UIKit/UIKit.h>
#import "XYHomeBaseCell.h"
#import "XYBlindDataItemModel.h"
#import "XYHeartBeatView.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYBlindDateCollectionViewCell : XYHomeBaseCell
@property(nonatomic,strong)XYBlindDataItemModel *model;

@property(nonatomic,strong)XYHeartBeatView *beatView;
@end

NS_ASSUME_NONNULL_END
