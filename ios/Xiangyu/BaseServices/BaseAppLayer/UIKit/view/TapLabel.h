//
//  TapLabel.h
//  ZuU
//
//  Created by Apple on 2020/1/13.
//  Copyright © 2020 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TapLabel : UIView
+(instancetype)createViewWithTitleColor:(UIColor *)textColor font:(UIFont *)font;
+(instancetype)createViewWithTitleColor:(UIColor *)textColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor;
//+(instancetype)createViewWithTitleColor:(UIColor *)textColor font:(UIFont *)font;

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,assign)CGFloat setoff;
@property(nonatomic,assign)BOOL isRedNum;

@property(nonatomic,strong)NSString *text;
@end

NS_ASSUME_NONNULL_END
