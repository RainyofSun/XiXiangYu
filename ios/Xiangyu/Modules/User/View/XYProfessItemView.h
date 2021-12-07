//
//  XYProfessItemView.h
//  Xiangyu
//
//  Created by Kang on 2021/6/28.
//

#import <UIKit/UIKit.h>
#import "XYGetProfessModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYProfessItemView : UIView
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *valueLabel;
@end
@interface XYProfessTopView : UIView
@property(nonatomic,strong)XYProfessItemView*myHeart;
@property(nonatomic,strong)XYProfessItemView*toMyHeart;

@property(nonatomic,strong)XYGetProfessModel *model;
@end
NS_ASSUME_NONNULL_END
