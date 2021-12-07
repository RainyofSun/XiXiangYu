//
//  XYTopicDetailTopView.h
//  Xiangyu
//
//  Created by Kang on 2021/7/4.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "XYTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYTopicDetailTopView : UIView<SDCycleScrollViewDelegate>
@property(nonatomic,strong)SDCycleScrollView *imgScrollView ;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *hotLabel;
@property(nonatomic,strong)UILabel *remarkLabel;

@property(nonatomic,strong)XYTopicModel *model;
@end

NS_ASSUME_NONNULL_END
