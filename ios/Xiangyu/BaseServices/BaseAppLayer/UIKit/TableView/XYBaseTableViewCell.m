//
//  XYBaseTableViewCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseTableViewCell.h"
#import "XYBaseTableViewItem.h"

@implementation XYBaseTableViewCell

- (void)setObject:(XYBaseTableViewItem *)object {
    _object = object;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(XYBaseTableViewItem *)object {
    return object.cellHeight;
}

@end
