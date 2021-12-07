//
//  XYBaseTableViewCell.h
//  TopjeXYicking
//
//  Created by 沈阳 on 2017/8/24.
//  Copyright © 2017年 ShangHai Topjet Information & Technology Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYBaseTableViewItem;
@interface XYBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) XYBaseTableViewItem * object;

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(XYBaseTableViewItem *)object;

@end
