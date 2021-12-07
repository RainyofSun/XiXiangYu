//
//  XYBlindItemBtn.h
//  Xiangyu
//
//  Created by Kang on 2021/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYBlindItemBtn : UIButton
-(instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName;

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString  *imageName;
@end

NS_ASSUME_NONNULL_END
