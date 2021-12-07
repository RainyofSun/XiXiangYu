//
//  XYAddressContentView.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/30.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYAddressService.h"

@interface XYAddressContentView : UIView

- (instancetype)initWithWithoutTitleView:(BOOL)withoutTitleView withTown:(BOOL)withTown withSure:(BOOL)withSure;
- (instancetype)initWithWithoutTitleView:(BOOL)withoutTitleView withTown:(BOOL)withTown withSure:(BOOL)withSure  withDesc:(NSString *)desc;

@property (nonatomic, copy) NSString * adcode;

@property (nonatomic, copy) NSString * desc;

@property (nonatomic, copy) void(^chooseFinish)(XYFormattedArea *area);

@property (nonatomic, copy) void(^dismissAction)(void);

@end
