//
//  LSHControl.m
//  MovieProject
//
//  Created by qianfeng on 14-11-1.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "LSHControl.h"

#define IOS7   [[UIDevice currentDevice]systemVersion].floatValue>=7.0

@implementation LSHControl

#pragma mark ----  create Label  ----------

+(UILabel *)createLabelFromFont:(UIFont *)font textColor:(UIColor *)color text:(NSString *)text{

    UILabel *label=[[UILabel alloc]init];
    label.font=font;
    label.textColor=color;
    label.text = text;
    return label;
}

+(UILabel *)createLabelFromFont:(UIFont *)font textColor:(UIColor *)color{

    UILabel *label=[[UILabel alloc]init];
    label.font=font;
    label.textColor=color;
    
    return label;
}

+(UILabel *)createLabelFromFont:(UIFont *)font textColor:(UIColor *)color textAlignment:(NSTextAlignment )textAlignment{
 
    UILabel *label=[LSHControl createLabelFromFont:font textColor:color];
    label.textAlignment=textAlignment;
    return label;
}

+(UILabel *)createLabelFromFont:(UIFont *)font textColor:(UIColor *)color numberOfLines:(NSInteger)numberOfLines{
 
    UILabel *label=[LSHControl createLabelFromFont:font textColor:color];
    label.numberOfLines=numberOfLines;
    return label;
}

+(UILabel *)createLabelWithFrame:(CGRect)frame backgoudColor:(UIColor *)color{

    UILabel *label=[[UILabel alloc]initWithFrame:frame];
    label.backgroundColor=color;
    
    return label;
}
+(UILabel *)createLabelWithFrame:(CGRect)frame backgoudColor:(UIColor *)color tag:(NSInteger)tag{

    UILabel *label=[self createLabelWithFrame:frame backgoudColor:color];
    label.tag=tag;
    
    return label;
}

+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(int)font Text:(NSString*)text
{
    
    
    UILabel*label=[[UILabel alloc]initWithFrame:frame];
    //限制行数
    label.numberOfLines=0;
    //对齐方式
    label.textAlignment=NSTextAlignmentLeft;
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont systemFontOfSize:font];
    //单词折行
    label.lineBreakMode=NSLineBreakByWordWrapping;
    //默认字体颜色是白色
    label.textColor=[UIColor blackColor];
    //自适应（行数~字体大小按照设置大小进行设置）
    label.adjustsFontSizeToFitWidth=YES;
    label.text=text;
    return label;
}

+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(UIFont*)font Text:(NSString*)text color:(UIColor*)color 
{
     UILabel*label=nil;
    if (!CGRectEqualToRect(frame,CGRectZero) && !CGRectEqualToRect(frame,CGRectNull)) {
        label=[[UILabel alloc]initWithFrame:frame];
    }else{
        label=[[UILabel alloc]init];
    }
    
   

    label.font= font;
    //单词折行
    label.lineBreakMode=NSLineBreakByWordWrapping;
    //默认字体颜色是白色
    label.textColor= color;
    //自适应（行数~字体大小按照设置大小进行设置）
    label.text=text;
    return label;
}

+(UILabel *)createLabelWithFrame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text color:(UIColor *)color tag:(NSInteger)tag{
    
    UILabel *label=[LSHControl createLabelWithFrame:frame Font:font Text:text color:color];
    label.tag=tag;
    return label;

}

+(UILabel *)createLabelWithFrame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text color:(UIColor *)color textAlignment:(NSTextAlignment)alignment{
    

    UILabel*label= [self createLabelWithFrame:frame Font:font Text:text color:color];
    label.textAlignment=alignment;
    return label;

}
+(UILabel *)createLabelWithFrame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text color:(UIColor *)color textAlignment:(NSTextAlignment)alignment backgroundColor:(UIColor *)backgroundColor{
    
    UILabel *label=[self createLabelWithFrame:frame Font:font Text:text color:color textAlignment:alignment];
    label.backgroundColor=backgroundColor;
    return label;
}
+(UILabel *)createLabelWithFrame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text color:(UIColor *)color textAlignment:(NSTextAlignment)alignment backgroundColor:(UIColor *)backgroundColor cornerRadius:(CGFloat)cornerRadius{
 
    UILabel *label=[self createLabelWithFrame:frame Font:font Text:text color:color textAlignment:alignment backgroundColor:backgroundColor];
    label.layer.cornerRadius=cornerRadius;
    label.layer.masksToBounds=YES;
    
    return label;
}
+(UILabel *)createLabelWithFrame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text color:(UIColor *)color textAlignment:(NSTextAlignment)alignment numberOfLines:(NSInteger)numberOfLines{
    
    
    UILabel*label= [self createLabelWithFrame:frame Font:font Text:text color:color textAlignment:alignment];
    label.numberOfLines=numberOfLines;
    return label;
    
}
+(UILabel *)createLabelWithFrame:(CGRect)frame Font:(UIFont *)font Text:(NSString *)text color:(UIColor *)color textAlignment:(NSTextAlignment)alignment numberOfLines:(NSInteger)numberOfLines tag:(NSInteger)tag{
 
    UILabel *label=[self createLabelWithFrame:frame Font:font Text:text color:color textAlignment:alignment numberOfLines:numberOfLines];
    label.tag=tag;
    
    return label;
}


#pragma mark ----  create UIButton  ----------

+(UIButton *)createButtonWithTitleFont:(UIFont *)font titleColor:(UIColor *)titleColor contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment{

    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font=font;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.contentHorizontalAlignment =horizontalAlignment;
   
    return button;
}

+(UIButton*)createButtonWithTitleFont:(UIFont *)font titleColor:(UIColor *)titleColor contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment selectedTitleColor:(UIColor *)selectedColor borderColor:(CGColorRef)borderColor borderWidth:(CGFloat)borderWidth title:(NSString *)title{
   
    UIButton *button=[LSHControl createButtonWithTitleFont:font titleColor:titleColor contentHorizontalAlignment:horizontalAlignment ];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    button.layer.borderColor=borderColor;
    button.layer.borderWidth=borderWidth;
    
    return button;
}

+(UIButton *)createButtonWithTitleFont:(UIFont *)font titleColor:(UIColor *)titleColor contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets{
    
    UIButton *button=[LSHControl createButtonWithTitleFont:font titleColor:titleColor contentHorizontalAlignment:horizontalAlignment];
    button.titleEdgeInsets=titleEdgeInsets;
    
    return button;
}

+(UIButton *)createButtonWithTitleFont:(UIFont *)font titleColor:(UIColor *)titleColor contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets title:(NSString *)title{

    UIButton *button = [LSHControl createButtonWithTitleFont:font titleColor:titleColor contentHorizontalAlignment:horizontalAlignment titleEdgeInsets:titleEdgeInsets ];
    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}
+(UIButton *)createButtonWithTitleFont:(UIFont *)font titleColor:(UIColor *)titleColor contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment titleEdgeInsets:(UIEdgeInsets)titleEdgeInsets title:(NSString *)title selectedTitleColor:(UIColor *)selectedColor{

     UIButton *button =  [LSHControl createButtonWithTitleFont:font titleColor:titleColor contentHorizontalAlignment:horizontalAlignment titleEdgeInsets:titleEdgeInsets title:title];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    
    return button;

}

+(UIButton*)createButtonWithFrame:(CGRect)frame Target:(id)target Action:(SEL)action Title:(NSString*)title titlColor:(UIColor *)color font:(UIFont *)textFont tag:(NSInteger)tag;{

    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    

    if (!CGRectEqualToRect(frame,CGRectZero) && !CGRectEqualToRect(frame,CGRectNull)) {
        button.frame=frame;
    }
    
    
    button.frame=frame;
    button.tag=tag;
    button.titleLabel.font=textFont;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;


}
+(UIButton *)createButtonWithFrame:(CGRect)frame Target:(id)target Action:(SEL)action Title:(NSString *)title titlColor:(UIColor *)color font:(UIFont *)textFont tag:(NSInteger)tag backgroundColor:(UIColor *)backgroudColor{
 
    UIButton *button=[self createButtonWithFrame:frame Target:target Action:action Title:title titlColor:color font:textFont tag:tag];
    button.backgroundColor=backgroudColor;
    return button;
    
}


+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title
{
   
    UIButton *button=[self createButtonWithFrame:frame ImageName:imageName selectedImage:nil Target:target Action:action Title:title tag:0];
    return button;
    
}
//创建一个button,显示正常和选择状态的图片
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName selectedImage:(NSString *)selected Target:(id)target Action:(SEL)action Title:(NSString*)title tag:(NSInteger)tag{
   
    UIButton*button=[UIButton buttonWithType:UIButtonTypeCustom];
    if (!CGRectEqualToRect(frame,CGRectZero) && !CGRectEqualToRect(frame,CGRectNull)) {
        button.frame=frame;
    }
    button.tag=tag;
    [button setTitle:title forState:UIControlStateNormal];
    //设置背景图片，可以使文字与图片共存
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;

}

+(UIButton *)createButtonWithFrame:(CGRect)frame buttonImage:(NSString *)imageName action:(ActionBlock)action{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    if (!CGRectEqualToRect(frame,CGRectZero) && !CGRectEqualToRect(frame,CGRectNull)) {
        button.frame=frame;
    }
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [button handleControlEventWithBlock:action];
    return button;
}
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonImage:(NSString *)imageName selectedImage:(NSString *)selected action:(ActionBlock)action{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    if (!CGRectEqualToRect(frame,CGRectZero) && !CGRectEqualToRect(frame,CGRectNull)) {
        button.frame=frame;
    }
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    [button handleControlEventWithBlock:action];
    return button;
}

+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title action:(ActionBlock)action{
    UIButton *button=[self createButtonWithFrame:frame];
    button.titleLabel.font=font;
    [button setTitle:title forState:UIControlStateNormal];
     [button handleControlEventWithBlock:action];
    return button;
}
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonImage:(NSString *)imageName buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title action:(ActionBlock)action{
    UIButton *button=[self createButtonWithFrame:frame];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.titleLabel.font=font;
    [button setTitle:title forState:UIControlStateNormal];
    [button handleControlEventWithBlock:action];
    return button;
}
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor action:(ActionBlock)action{
    UIButton *button=[self createButtonWithFrame:frame buttonTitleFont:font buttonTitle:title action:action];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    return button;
}
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonImage:(NSString *)imageName selectedImage:(NSString *)selected buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor action:(ActionBlock)action{
    UIButton *button=[self createButtonWithFrame:frame buttonTitleFont:font buttonTitle:title buttonTitleColor:titleColor action:action];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    return button;
}
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonImage:(NSString *)imageName selectedImage:(NSString *)selected buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor{
    UIButton *button=[self createButtonWithFrame:frame buttonTitleFont:font buttonTitle:title buttonTitleColor:titleColor];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    return button;
}
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonImage:(UIImage *)buttonImage selectedImage:(UIImage *)selectedImage buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor selectedColor:(UIColor *)selectedColor{
    UIButton *button=[self createButtonWithFrame:frame buttonTitleFont:font buttonTitle:title buttonTitleColor:titleColor];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    [button setTitleColor:selectedColor forState:UIControlStateSelected];
    return button;
}




+(UIButton *)createButtonWithFrame:(CGRect)frame{
   
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    if (!CGRectEqualToRect(frame,CGRectZero) && !CGRectEqualToRect(frame,CGRectNull)) {
        button.frame=frame;
    }
    
    return button;
}
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonImage:(NSString *)imageName{

    UIButton *button=[self createButtonWithFrame:frame];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    return button;

}
+(UIButton *)createButtonWithFrame:(CGRect)frame Image:(UIImage *)image{

    UIButton *button=[self createButtonWithFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    return button;

}
+(UIButton *)createButtonWithFrame:(CGRect)frame Image:(UIImage *)image action:(ActionBlock)block{

    UIButton *button=[self createButtonWithFrame:frame];
    [button setImage:image forState:UIControlStateNormal];
    [button handleControlEventWithBlock:block];
    return button;

}
+(UIButton *)createButtonWithButtonImage:(UIImage *)image{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}
+(UIButton *)createButtonWithButtonImage:(UIImage *)image selectedImage:(UIImage *)selectedImage{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    return button;
}
+(UIButton *)createButtonWithButtonImage:(UIImage *)image action:(ActionBlock)action{
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];

    [button setImage:image forState:UIControlStateNormal];
    [button handleControlEventWithBlock:action];
    return button;
}

+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title{
    
    UIButton *button=[self createButtonWithFrame:frame];
    button.titleLabel.font=font;
    [button setTitle:title forState:UIControlStateNormal];
    
    return button;
}
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor{
    
    UIButton *button=[self createButtonWithFrame:frame buttonTitleFont:font buttonTitle:title];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    return button;
}
+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment{

    UIButton *button = [self createButtonWithFrame:frame buttonTitleFont:font buttonTitle:title buttonTitleColor:titleColor];
    button.contentHorizontalAlignment=horizontalAlignment;
    
    return button;
}

+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor backgorudColor:(UIColor *)backgorudColor{

    UIButton *button=[self createButtonWithFrame:frame buttonTitleFont:font buttonTitle:title buttonTitleColor:titleColor];
    button.backgroundColor=backgorudColor;
    
    return button;
}

+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor backgorudColor:(UIColor *)backgorudColor contentHorizontalAlignment:(UIControlContentHorizontalAlignment)horizontalAlignment{

    UIButton *button=[self createButtonWithFrame:frame buttonTitleFont:font buttonTitle:title buttonTitleColor:titleColor backgorudColor:backgorudColor];
    button.contentHorizontalAlignment = horizontalAlignment;
    return button;

}

+(UIButton *)createButtonWithFrame:(CGRect)frame buttonTitleFont:(UIFont *)font buttonTitle:(NSString *)title buttonTitleColor:(UIColor *)titleColor backgorudColor:(UIColor *)backgorudColor borderColor:(CGColorRef)borderColor borderWidth:(CGFloat)borderWidth{

    UIButton *button=[self createButtonWithFrame:frame buttonTitleFont:font buttonTitle:title buttonTitleColor:titleColor backgorudColor:backgorudColor];
    button.layer.borderColor=borderColor;
    button.layer.borderWidth=borderWidth;
    
    return button;

}


#pragma mark ----- 创建tableView -----
+(UITableView *)createTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style  dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate{
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:frame style:style];
    tableView.dataSource=dataSource;
    tableView.delegate=delegate;
     [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if (@available(iOS 11.0, *)) {
           tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
           tableView.scrollIndicatorInsets = tableView.contentInset;
           tableView.estimatedRowHeight = 0;
           tableView.estimatedSectionHeaderHeight = 0;
           tableView.estimatedSectionFooterHeight = 0;
       }
    
    return tableView;
}
+(UITableView *)createTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style backgroudColor:(UIColor *)backgroudColor dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate{
    
  UITableView *tableView=[self createTableViewWithFrame:frame style:style dataSource:dataSource delegate:delegate];
  tableView.backgroundColor=backgroudColor;
  return tableView;
}

+(UITableView *)createTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style backgroudColor:(UIColor *)backgroudColor dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle{
  
    UITableView *tableView=[self createTableViewWithFrame:frame style:style backgroudColor:backgroudColor dataSource:dataSource delegate:delegate];
    tableView.separatorStyle=separatorStyle;
    
    return tableView;
}

/*+(TPKeyboardAvoidingTableView *)createTPKeyboardAvoidingTableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style backgroudColor:(UIColor *)backgroudColor dataSource:(id<UITableViewDataSource>)dataSource delegate:(id<UITableViewDelegate>)delegate separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle{

    TPKeyboardAvoidingTableView *tableView=[[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, APPW, APPH-49-64) style:UITableViewStylePlain];
    tableView.delegate=delegate;
    tableView.dataSource=dataSource;
    tableView.backgroundColor=backgroudColor;
    tableView.separatorStyle=separatorStyle;
    
    return tableView;
}*/

#pragma mark ----- 创建UICollectionView -----

+(UICollectionView *)createCollectionViewFromFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout dataSource:(id<UICollectionViewDataSource>)dataSource delegate:(id<UICollectionViewDelegate>)delegate{
    
    UICollectionView *colltionView=[[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
    colltionView.delegate=delegate;
    colltionView.dataSource=dataSource;
    if (@available(iOS 11.0, *)) {
        colltionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        colltionView.scrollIndicatorInsets = colltionView.contentInset;
    }
    return colltionView;
    
}

+(UICollectionView *)createCollectionViewFromFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout dataSource:(id<UICollectionViewDataSource>)dataSource delegate:(id<UICollectionViewDelegate>)delegate backgroudColor:(UIColor *)backgroudColor{

    UICollectionView *collectionView=[self createCollectionViewFromFrame:frame collectionViewLayout:layout dataSource:dataSource delegate:delegate];
    collectionView.backgroundColor=backgroudColor;
    
    return collectionView;
}

#pragma ----- UIImageView部分  --------
+(UIImageView*)createImageViewWithImageName:(NSString*)imageName
{
    UIImageView*imageView=[[UIImageView alloc]init];
    if (imageName && imageName.length>0) {
        imageView.image=[UIImage imageNamed:imageName];
    }
    //imageView.userInteractionEnabled=YES;
    return imageView ;
}
+(UIImageView*)createImageViewWithImage:(UIImage*)image{
    UIImageView*imageView=[[UIImageView alloc]init];
    imageView.image=image;
    return imageView ;
}
//创建并返回一个UIImageview,设置大小和图片
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName
{
    UIImageView*imageView=[[UIImageView alloc]init];
    
    if (!CGRectEqualToRect(frame,CGRectZero) && !CGRectEqualToRect(frame,CGRectNull)) {
        imageView.frame=frame;
    }
    
    
    
    if (imageName && imageName.length>0) {
         imageView.image=[UIImage imageNamed:imageName];
    }
   
   // imageView.userInteractionEnabled=YES;
    
    return imageView ;
}
+(UIImageView *)createImageViewWithFrame:(CGRect)frame ImageName:(NSString *)imageName contentMode:(UIViewContentMode)contentMode{
 
    UIImageView *imageView=[self createImageViewWithFrame:frame ImageName:imageName];
    imageView.contentMode=contentMode;
    
    return imageView;
}

+(UIImageView *)createImageViewWithFrame:(CGRect)frame ImageName:(NSString *)imageName imageTagValue:(NSInteger)tag{
   
    UIImageView *imageView=[self createImageViewWithFrame:frame ImageName:imageName];
    imageView.tag=tag;
    
    return imageView;
}
#pragma -----  UIView部分   --------

+(UIView*)viewWithFrame:(CGRect)frame
{
    
    UIView*view=[[UIView alloc]init];
    if (!CGRectEqualToRect(frame,CGRectZero) && !CGRectEqualToRect(frame,CGRectNull)) {
        view.frame=frame;
    }
    return view ;
    
}
+(UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color{
 
    UIView *view=[LSHControl viewWithFrame:frame];
    view.backgroundColor=color;
    return view;
}
+(UIView*)viewWithBackgroundColor:(UIColor *)color{
    UIView *view=[LSHControl viewWithFrame:CGRectZero];
    view.backgroundColor=color;
    return view;
}
+(UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color borderColor:(CGColorRef)borderColor borderWidth:(CGFloat)borderWidth{
    
    UIView *view=[self viewWithFrame:frame backgroundColor:color];
    view.layer.borderColor=borderColor;
    view.layer.borderWidth=borderWidth;
    
    return view;
}
+(UIView *)viewWithFrame:(CGRect)frame backgroundColor:(UIColor *)color viewTagValue:(NSInteger)tag{
    
    UIView *view=[LSHControl viewWithFrame:frame backgroundColor:color];
    view.tag=tag;
    return view;
}

#pragma mark ----- UITextField部分 -------

+(UITextField *)creatTextfieldWithFrame:(CGRect)frame textfieldTextFont:(UIFont *)font textFieldTextColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment{
    UITextField *textField=[self creatTextfieldWithFrame:frame textfieldTextFont:font textFieldTextColor:textColor];
    textField.textAlignment = textAlignment;
    return textField;
}

+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder textfieldTextFont:(UIFont *)font textFieldTextColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment{
    UITextField *textField=[self creatTextfieldWithFrame:frame placeholder:placeholder textfieldTextFont:font textFieldTextColor:textColor];
    textField.textAlignment = textAlignment;
    return textField;
}

+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder
                       placeholderColor:(UIColor *)placeholderColor textfieldTextFont:(UIFont *)font textFieldTextColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment{
    UITextField *textField=[self creatTextfieldWithFrame:frame placeholder:placeholder placeholderColor:placeholderColor textfieldTextFont:font textFieldTextColor:textColor];
    textField.textAlignment = textAlignment;
    return textField;
}



+(UITextField *)creatTextfieldWithFrame:(CGRect)frame textfieldTextFont:(UIFont *)font textFieldTextColor:(UIColor *)textColor{
    UITextField *textField=[[UITextField alloc]init];
    if (!CGRectEqualToRect(frame,CGRectZero) && !CGRectEqualToRect(frame,CGRectNull)) {
        textField.frame=frame;
    }
    textField.font=font;
    textField.textColor=textColor;
    return textField;
}

+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder textfieldTextFont:(UIFont *)font textFieldTextColor:(UIColor *)textColor{
    UITextField *textField=[[UITextField alloc]init];
    if (!CGRectEqualToRect(frame,CGRectZero) && !CGRectEqualToRect(frame,CGRectNull)) {
        textField.frame=frame;
    }
    textField.placeholder=placeholder;
    textField.font=font;
    textField.textColor=textColor;
    
    return textField;
}

+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder placeholderColor:(UIColor *)placeholderColor textfieldTextFont:(UIFont *)font textFieldTextColor:(UIColor *)textColor{
    UITextField *textField=[self creatTextfieldWithFrame:frame placeholder:placeholder textfieldTextFont:font textFieldTextColor:textColor];
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc]initWithString:placeholder];
    [mutableString addAttribute:NSForegroundColorAttributeName
                             value:placeholderColor
                             range:NSMakeRange(0, placeholder.length)];//设置颜色
    
    textField.attributedPlaceholder = mutableString;
    
//     [textField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
    return textField;
}



+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder delegate:(id<UITextFieldDelegate>)delegate textfieldTextFont:(UIFont *)font clearButtonMode:(UITextFieldViewMode)clearButtonMode{

    UITextField *textField=[[UITextField alloc]init];
    if (!CGRectEqualToRect(frame,CGRectZero) && !CGRectEqualToRect(frame,CGRectNull)) {
        textField.frame=frame;
    }
    textField.delegate=delegate;
    textField.placeholder=placeholder;
    textField.font=font;
    textField.clearButtonMode=clearButtonMode;
    
  
   
    return textField;
}

+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder delegate:(id<UITextFieldDelegate>)delegate textfieldTextFont:(UIFont *)font clearButtonMode:(UITextFieldViewMode)clearButtonMode keyboardType:(UIKeyboardType)keyboardType{

 
    UITextField *textField=[self creatTextfieldWithFrame:frame placeholder:placeholder delegate:delegate textfieldTextFont:font clearButtonMode:clearButtonMode];
    textField.keyboardType=keyboardType;
    
    return textField;
}

+(UITextField *)creatTextfieldWithFrame:(CGRect)frame placeholder:(NSString *)placeholder delegate:(id<UITextFieldDelegate>)delegate textfieldTextFont:(UIFont *)font clearButtonMode:(UITextFieldViewMode)clearButtonMode keyboardType:(UIKeyboardType)keyboardType textColor:(UIColor *)color{

    UITextField *textField=[self creatTextfieldWithFrame:frame placeholder:placeholder delegate:delegate textfieldTextFont:font clearButtonMode:clearButtonMode keyboardType:keyboardType];
    textField.textColor=color;
   
    
    
    
    
    return textField;
}



+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font
{
    UITextField*textField=[[UITextField alloc]init];
    if (!CGRectEqualToRect(frame,CGRectZero) && !CGRectEqualToRect(frame,CGRectNull)) {
        textField.frame=frame;
    }
    //灰色提示框
    textField.placeholder=placeholder;
    //文字对齐方式
    textField.textAlignment=NSTextAlignmentLeft;
    textField.secureTextEntry=YESorNO;
    //边框
    //textField.borderStyle=UITextBorderStyleLine;
    //键盘类型
    textField.keyboardType=UIKeyboardTypeEmailAddress;
    //关闭首字母大写
    textField.autocapitalizationType=NO;
    //清除按钮
    textField.clearButtonMode=YES;
    //左图片
    textField.leftView=imageView;
    textField.leftViewMode=UITextFieldViewModeAlways;
    //右图片
    textField.rightView=rightImageView;
    //编辑状态下一直存在
    textField.rightViewMode=UITextFieldViewModeWhileEditing;
    //自定义键盘
    //textField.inputView
    //字体
    textField.font=[UIFont systemFontOfSize:font];
    //字体颜色
    textField.textColor=[UIColor blackColor];
    return textField ;
    
}
#pragma  mark 适配器方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName
{
    UITextField*text= [self createTextFieldWithFrame:frame placeholder:placeholder passWord:YESorNO leftImageView:imageView rightImageView:rightImageView Font:font];
    text.background=[UIImage imageNamed:imageName];
    return  text;
    
}
+(UIScrollView*)makeScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = size;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    return scrollView ;
}
+(UIPageControl*)makePageControlWithFram:(CGRect)frame
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:frame];
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    return pageControl;
}
+(UISlider*)makeSliderWithFrame:(CGRect)rect AndImage:(UIImage*)image
{
    UISlider *slider = [[UISlider alloc]initWithFrame:rect];
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [slider setThumbImage:[UIImage imageNamed:@"qiu"] forState:UIControlStateNormal];
    slider.maximumTrackTintColor = [UIColor grayColor];
    slider.minimumTrackTintColor = [UIColor yellowColor];
    slider.continuous = YES;
    slider.enabled = YES;
    return slider ;
}
+(NSString *)stringFromDateWithHourAndMinute:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

#pragma -mark 判断导航的高度
+(float)isIOS7{
    
    float height;
    if (IOS7) {
        height=64.0;
    }else{
        height=44;
    }
    
    return height;
}
#pragma mark 内涵图需要的方法
+ (NSString *)stringDateWithTimeInterval:(NSString *)timeInterval
{
    NSTimeInterval seconds = [timeInterval integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [format stringFromDate:date];
}

+ (CGFloat)textHeightWithString:(NSString *)text width:(CGFloat)width fontSize:(NSInteger)fontSize
{
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    // 根据第一个参数的文本内容，使用280*float最大值的大小，使用系统14号字，返回一个真实的frame size : (280*xxx)!!
    CGRect frame = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
    return frame.size.height + 5;
}

// 返回一个整数字符串加1后的新字符串
+ (NSString *)addOneByIntegerString:(NSString *)integerString
{
    NSInteger integer = [integerString integerValue];
    return [NSString stringWithFormat:@"%ld",integer+1];
}



@end
