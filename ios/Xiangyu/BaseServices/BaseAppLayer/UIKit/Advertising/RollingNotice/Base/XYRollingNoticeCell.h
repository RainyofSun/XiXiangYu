//
//  XYRollingNoticeCell.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYRollingNoticeCell : UIView

@property (nonatomic, readonly, strong) UILabel *textLabel;

@property (nonatomic, readonly,   copy) NSString *reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
