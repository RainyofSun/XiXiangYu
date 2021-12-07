//
//  XYAddressSelector.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/23.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYAddressItem.h"

@interface XYAddressSelector : UIView

@property (nonatomic,copy) NSString *adcode;

@property(nonatomic,strong)NSString *descString;

@property (nonatomic,assign) BOOL narrowedOff;

@property (nonatomic, copy) void(^chooseFinish)(XYFormattedArea *area);

- (instancetype)initWithBaseViewController:(UIViewController *)baseViewController withTown:(BOOL)withTown;

- (instancetype)initWithBaseViewController:(UIViewController *)baseViewController withTown:(BOOL)withTown desc:(NSString *)desc;

- (void)show;

- (void)dismiss;

@end
