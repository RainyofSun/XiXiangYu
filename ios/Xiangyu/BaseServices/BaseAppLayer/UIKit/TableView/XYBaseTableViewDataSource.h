//
//  XYBaseTableViewDataSource.h
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYBaseTableViewItem;

@protocol XYBaseTableViewDataSource <UITableViewDataSource>

@optional

- (XYBaseTableViewItem *)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath;

- (Class)tableView:(UITableView *)tableView cellClassForObject:(XYBaseTableViewItem *)object;


@end
@interface XYBaseTableViewDataSource : NSObject <XYBaseTableViewDataSource>

@property (nonatomic, strong) NSMutableArray *sections;

- (void)clearAllSections;

- (void)clearAllItemsInSection:(NSInteger)section;

- (void)appendItem:(XYBaseTableViewItem *)item atSection:(NSInteger)section;

- (void)appendItems:(NSArray <XYBaseTableViewItem *> *)items atSection:(NSInteger)section;


@end
