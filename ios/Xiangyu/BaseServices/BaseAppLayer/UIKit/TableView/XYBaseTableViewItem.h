//
//  XYBaseTableViewItem.h
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYBaseTableViewItem : NSObject

@property (nonatomic,copy) NSString *cellClass;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGFloat leftSepartMargin;

@property (nonatomic, assign) CGFloat rightSepartMargin;

@property (nonatomic,weak) id target;

@end
