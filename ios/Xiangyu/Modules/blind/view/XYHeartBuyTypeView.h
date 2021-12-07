//
//  XYHeartBuyTypeView.h
//  Xiangyu
//
//  Created by Kang on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYHeartBuyTypeView : UIView
@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *selectBtn;

+(instancetype)initWithImageName:(NSString *)name title:(NSAttributedString *)title;


@end

NS_ASSUME_NONNULL_END
