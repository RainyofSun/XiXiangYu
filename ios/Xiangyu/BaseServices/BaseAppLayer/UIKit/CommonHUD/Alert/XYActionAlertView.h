//
//  XYActionAlertView.h
//  Baiqu
//
//  Created by Jacky Dimon on 2018/1/21.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYActionAlertView;
@protocol XYActionAlertViewDelegate
@optional
- (void)didClickActionSheet:(XYActionAlertView *)actionSheet atIndex:(NSInteger)index;

@end


@interface XYActionAlertView : UIView

@property (nonatomic,copy) NSString *detail;

@property (nonatomic,strong) NSArray<NSString *> *dataSource;

@property (nonatomic,assign) NSString *destroy;

@property (nonatomic,weak) id delegate;

@property (nonatomic,copy) void(^dismissBlock)(void);

@property (nonatomic,copy) void(^selectedBlock)(NSInteger value);

- (void)show;

- (void)dismiss;

@end
