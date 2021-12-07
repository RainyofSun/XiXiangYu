//
//  XYProfessBottomView.h
//  Xiangyu
//
//  Created by Kang on 2021/6/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface XYProfessBottomItemView : UIView
@property(nonatomic,strong)UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *arrowView;
@end
@interface XYProfessBottomView : UIView
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)XYProfessBottomItemView *myHeartView;
@property(nonatomic,strong)XYProfessBottomItemView *toMyHeartView;
@end

NS_ASSUME_NONNULL_END
