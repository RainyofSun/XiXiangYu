//
//  XYBaseTableViewDataSource.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseTableViewDataSource.h"
#import "XYBaseTableViewSectionObject.h"
#import "XYBaseTableViewCell.h"
#import "XYBaseTableViewItem.h"
#import <objc/runtime.h>

@implementation XYBaseTableViewDataSource

#pragma mark - XYTableViewDataSource
- (XYBaseTableViewItem *)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sections.count > indexPath.section) {
        XYBaseTableViewSectionObject *sectionObject = [self.sections objectAtIndex:indexPath.section];
        if ([sectionObject.items count] > indexPath.row) {
            return [sectionObject.items objectAtIndex:indexPath.row];
        }
    }
    return nil;
}

- (Class)tableView:(UITableView *)tableView cellClassForObject:(XYBaseTableViewItem *)object {
    return NSClassFromString(object.cellClass);
}

- (void)clearAllSections {
    [self.sections removeAllObjects];
}

- (void)clearAllItemsInSection:(NSInteger)section {
     if (self.sections.count < section) return;
    self.sections[section] = [[XYBaseTableViewSectionObject alloc] init];
}

- (void)appendItem:(XYBaseTableViewItem *)item atSection:(NSInteger)section {
    if (self.sections.count < section) return;
        
    XYBaseTableViewSectionObject *sectionObject = [self.sections objectAtIndex:section];
    [sectionObject.items addObject:item];
}


- (void)appendItems:(NSArray *)items atSection:(NSInteger)section {
    if (self.sections.count < section) return;
    
    XYBaseTableViewSectionObject *sectionObject = [self.sections objectAtIndex:section];
    [sectionObject.items addObjectsFromArray:items];
}

#pragma mark - UITableViewDataSource Required
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.sections.count > section) {
        XYBaseTableViewSectionObject *sectionObject = [self.sections objectAtIndex:section];
        return sectionObject.items.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYBaseTableViewItem *object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
    Class cellClass;
    if (object.cellClass.isNotBlank) {
        cellClass = NSClassFromString(object.cellClass);
    } else {
        cellClass = [self tableView:tableView cellClassForObject:object];
    }
    NSString *className = [NSString stringWithUTF8String:class_getName(cellClass)];
    
    XYBaseTableViewCell * cell = (XYBaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
    }
    [cell setObject:object];
    
    return cell;
}

#pragma mark - UITableViewDataSource Optional
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections ? self.sections.count : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.sections.count > section) {
        return @"";
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (self.sections.count > section) {
        return @"";
    }
    return nil;
}
@end
