//
//  XYHotTopicView.h
//  Xiangyu
//
//  Created by Kang on 2021/7/12.
//

#import <UIKit/UIKit.h>
#import "XYTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYHotTopicView : UIView
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *closeBtn;

@property(nonatomic,strong)XYTopicModel *__nullable model;
@end

NS_ASSUME_NONNULL_END
