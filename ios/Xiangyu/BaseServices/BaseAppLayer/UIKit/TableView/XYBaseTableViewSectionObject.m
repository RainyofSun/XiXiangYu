//
//  XYBaseTableViewSectionObject.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseTableViewSectionObject.h"

@implementation XYBaseHeaderFooterObject

@end

@implementation XYBaseTableViewSectionObject

- (instancetype)init {
    self = [super init];
    if (self) {
        self.items = @[].mutableCopy;
    }
    return self;
}

- (instancetype)initWithItems:(NSArray <XYBaseTableViewItem *> *)items {
    self = [self init];
    if (self) {
        [self.items addObjectsFromArray:items];
    }
    return self;
}
@end
