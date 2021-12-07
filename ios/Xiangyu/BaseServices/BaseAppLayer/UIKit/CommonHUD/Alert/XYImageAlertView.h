//
//  XYImageAlertView.h
//  Baiqu
//
//  Created by Jacky Dimon on 2018/1/18.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,XYAlertActionType){
    XYAlertActionTypeDefault,
    XYAlertActionTypeForce,
};

typedef void(^AlertActionBlock)(void);

@interface XYImageAlertView : UIView

@property (nonatomic,assign) XYAlertActionType type;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic,copy) NSString *detailText;

- (void)addEvent:(NSString *)event action:(AlertActionBlock)action;

- (void)show;

- (void)dismiss;

@end
