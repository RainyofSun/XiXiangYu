//
//  XYBaseTableViewSectionObject.h
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYBaseTableViewItem.h"

@interface XYBaseHeaderFooterObject : NSObject

@property (nonatomic,weak) id target;

@property (nonatomic,copy) NSString *className;

@property (nonatomic,assign) CGFloat height;

@end

@interface XYBaseTableViewSectionObject : NSObject

@property (nonatomic,weak) id target;

@property (nonatomic,strong) XYBaseHeaderFooterObject *headerInfo;

@property (nonatomic,strong) XYBaseHeaderFooterObject *footerInfo;

@property (nonatomic, strong) NSMutableArray <XYBaseTableViewItem *> *items;

- (instancetype)initWithItems:(NSArray <XYBaseTableViewItem *> *)items;
@end
