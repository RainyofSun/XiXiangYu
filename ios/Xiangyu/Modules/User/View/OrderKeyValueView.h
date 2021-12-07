//
//  OrderKeyValueView.h
//  XieXie
//
//  Created by Apple on 2020/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderKeyValueView : UIView
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *valueLabel;

+(instancetype)initWithTitleLabel:(NSString *)title
                        valueLabel:(NSString *)value;




@end

NS_ASSUME_NONNULL_END
