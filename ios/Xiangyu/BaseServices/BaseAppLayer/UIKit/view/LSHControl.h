//
//  LSHControl.h
//  MovieProject
//
//  Created by qianfeng on 14-11-1.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIButton+Helper.h"
#import "UIViewAdditions.h"

@interface LSHControl : NSObject

#pragma mark --创建Label
+(UILabel *)createLabelFromFont:(UIFont *)font textColor:(UIColor *)color text:(NSString *)text;
+(UILabel*)createLabelFromFont:(UIFont *)font textColor:(UIColor *)color;
+(UILabel*)createLabelFromFont:(UIFont *)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment;
+(UILabel*)createLabelFromFont:(UIFont *)font textColor:(UIColor *)color numberOfLines:(NSInteger)numberOfLines;

+(UILabel*)createLabelWithFrame:(CGRect)frame backgoudColor:(UIColor *)color;

+(UILabel*)createLabelWithFrame:(CGRect)frame backgoudColor:(UIColor *)color tag:(NSInteger)tag;
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text;
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(UIFont*)font Text:(NSString*)text color:(UIColor*)color;
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(UIFont*)font Text:(NSString*)text color:(UIColor*)color tag:(NSInteger)tag;

+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(UIFont*)font Text:(NSString*)text color:(UIColor*)color textAlignment:(NSTextAlignment)alignment;
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(UIFont*)font Text:(NSString*)text color:(UIColor*)color textAlignment:(NSTextAlignment)alignment backgroundColor:(UIColor *)backgroundColor;
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(UIFont*)font Text:(NSString*)text color:(UIColor*)color textAlignment:(NSTextAlignment)alignment backgroundColor:(UIColor *)backgroundColor  cornerRadius:(CGFloat)cornerRadius;
+(UILabel *)createLabelWithFrame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text color:(UIColor *)color textAlignment:(NSTextAlignment)alignment numberOfLines:(NSInteger)numberOfLines;
+(UILabel *)createLabelWithFrame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text color:(UIColor *)color textAlignment:(NSTextAlignment)alignment numberOfLines:(NSInteger)numberOfLines tag:(NSInteger)tag;


#pragma mark --创建View

+(UIView*)viewWithFrame:(CGRect)frame;
+(UIView*)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color;
+(UIView*)viewWithBackgroundColor:(UIColor *)color;
+(UIView*)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color borderColor:(CGColorRef )borderColor borderWidth:(CGFloat)borderWidth ;
+(UIView*)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color viewTagValue:(NSInteger)tag;

#pragma mark --创建imageView
+(UIImageView*)createImageViewWithImageName:(NSString*)imageName;
+(UIImageView*)createImageViewWithImage:(UIImage*)image;
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName;
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName contentMode:(UIViewContentMode)contentMode;
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName imageTagValue:(NSInteger)tag;


#pragma mark --创建button


+(UIButton*)createButtonWithTitleFont:(UIFont *)font titleColor:(UIColor *)titleColor contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment;

+(UIButton*)createButtonWithTitleFont:(UIFont *)font titleColor:(UIColor *)titleColor contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment selectedTitleColor:(UIColor *)selectedColor borderColor:(CGColorRef )borderColor borderWidth:(CGFloat)borderWidth title:(NSString *)title;
+(UIButton*)createButtonWithTitleFont:(UIFont *)font titleColor:(UIColor *)titleColor contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets;
+(UIButton*)createButtonWithTitleFont:(UIFont *)font titleColor:(UIColor *)titleColor contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets title:(NSString *)title;
+(UIButton*)createButtonWithTitleFont:(UIFont *)font titleColor:(UIColor *)titleColor contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets title:(NSString *)title selectedTitleColor:(UIColor *)selectedColor;


+(UIButton*)createButtonWithFrame:(CGRect)frame Target:(id)target Action:(SEL)action Title:(NSString*)title titlColor:(UIColor *)color font:(UIFont *)textFont tag:(NSInteger)tag backgroundColor:(UIColor *)backgroudColor;
+(UIButton*)createButtonWithFrame:(CGRect)frame Target:(id)target Action:(SEL)action Title:(NSString*)title titlColor:(UIColor *)color font:(UIFont *)textFont tag:(NSInteger)tag;
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title;
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName selectedImage:(NSString *)selected Target:(id)target Action:(SEL)action Title:(NSString*)title tag:(NSInteger)tag;


+(UIButton *)createButtonWithFrame:(CGRect)frame buttonImage:(NSString *)imageName action:(ActionBlock)action;
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonImage:(NSString *)imageName selectedImage:(NSString *)selected action:(ActionBlock)action;

+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title action:(ActionBlock)action;
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonImage:(NSString *)imageName buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title action:(ActionBlock)action;
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor action:(ActionBlock)action;

+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonImage:(NSString *)imageName selectedImage:(NSString *)selected buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor;
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonImage:(UIImage *)buttonImage selectedImage:(UIImage *)selectedImage buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor selectedColor:(UIColor *)selectedColor;
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonImage:(NSString *)imageName selectedImage:(NSString *)selected buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor action:(ActionBlock)action;


+(UIButton *)createButtonWithFrame:(CGRect)frame;
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonImage:(NSString *)imageName;
+(UIButton *)createButtonWithFrame:(CGRect)frame Image:(UIImage *)image;
+(UIButton *)createButtonWithFrame:(CGRect)frame Image:(UIImage *)image action:(ActionBlock)block;
+(UIButton *)createButtonWithButtonImage:(UIImage *)image;
+(UIButton *)createButtonWithButtonImage:(UIImage *)image selectedImage:(UIImage *)selectedImage;
+(UIButton *)createButtonWithButtonImage:(UIImage *)image action:(ActionBlock)action;

+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title;
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor;
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment;
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor backgorudColor:(UIColor *)backgorudColor;
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor backgorudColor:(UIColor *)backgorudColor  contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment;
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor backgorudColor:(UIColor *)backgorudColor borderColor:(CGColorRef )borderColor borderWidth:(CGFloat)borderWidth;


#pragma mark ----- 创建tableView -----
+(UITableView *)createTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate;
+(UITableView *)createTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style backgroudColor:(UIColor *)backgroudColor  dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate;
+(UITableView *)createTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style backgroudColor:(UIColor *)backgroudColor  dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle;

/**
 *   处理 cell上 textfield或者 textView键盘弹出问题
 *
 *   @param frame
 *   @param style
 *   @param backgroudColor
 *   @param dataSource
 *   @param delegate
 *   @param separatorStyle
 *
 *   @return 
 */
/*+(TPKeyboardAvoidingTableView *)createTPKeyboardAvoidingTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style backgroudColor:(UIColor *)backgroudColor  dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle;*/

#pragma mark ----- 创建UICollectionView -----


+(UICollectionView *)createCollectionViewFromFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout dataSource:(id<UICollectionViewDataSource>)dataSource delegate:(id<UICollectionViewDelegate>)delegate ;

+(UICollectionView *)createCollectionViewFromFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout dataSource:(id<UICollectionViewDataSource>)dataSource delegate:(id<UICollectionViewDelegate>)delegate backgroudColor:(UIColor *)backgroudColor;

#pragma mark --创建UITextField
+(UITextField *)creatTextfieldWithFrame:(CGRect)frame textfieldTextFont:(UIFont *)font textFieldTextColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment;

+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder textfieldTextFont:(UIFont *)font textFieldTextColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment;

+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder
                       placeholderColor:(UIColor *)placeholderColor textfieldTextFont:(UIFont *)font textFieldTextColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment;

+(UITextField *)creatTextfieldWithFrame:(CGRect)frame textfieldTextFont:(UIFont *)font textFieldTextColor:(UIColor *)textColor;

+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder textfieldTextFont:(UIFont *)font textFieldTextColor:(UIColor *)textColor;



+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder placeholderColor:(UIColor *)placeholderColor textfieldTextFont:(UIFont *)font textFieldTextColor:(UIColor *)textColor;



+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder delegate:(id<UITextFieldDelegate>)delegate textfieldTextFont:(UIFont *)font clearButtonMode:(UITextFieldViewMode)clearButtonMode;

+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder delegate:(id<UITextFieldDelegate>)delegate textfieldTextFont:(UIFont *)font clearButtonMode:(UITextFieldViewMode)clearButtonMode keyboardType:(UIKeyboardType)keyboardType;


+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder delegate:(id<UITextFieldDelegate>)delegate textfieldTextFont:(UIFont *)font clearButtonMode:(UITextFieldViewMode)clearButtonMode keyboardType:(UIKeyboardType)keyboardType textColor:(UIColor *)color;

+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font;

//适配器的方法  扩展性方法
//现有方法，已经在工程里面存在，如果修改工程内所有方法，工作量巨大，就需要使用适配器的方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName;

#pragma mark 创建UIScrollView
+(UIScrollView*)makeScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size;

#pragma mark 创建UIPageControl
+(UIPageControl*)makePageControlWithFram:(CGRect)frame;

#pragma mark 创建UISlider
+(UISlider*)makeSliderWithFrame:(CGRect)rect AndImage:(UIImage*)image;

#pragma mark 创建时间转换字符串
+(NSString *)stringFromDateWithHourAndMinute:(NSDate *)date;

#pragma mark --判断导航的高度64or44
+(float)isIOS7;

#pragma mark 内涵图需要的方法
+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval;

+ (CGFloat)textHeightWithString:(NSString *)text width:(CGFloat)width fontSize:(NSInteger)fontSize;

+ (NSString *)addOneByIntegerString:(NSString *)integerString;

@end
