//
//  XYBaseTableView.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYBaseTableView.h"
#import "XYBaseTableViewCell.h"
#import "XYBaseTableViewSectionObject.h"
#import "XYBaseTableViewItem.h"
#import "XYRefreshFooter.h"
#import "XYRefreshHeader.h"
#import "XYBaseHeaderFooterView.h"

@implementation XYBaseTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.showsVerticalScrollIndicator = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.sectionHeaderHeight = 0;
        self.sectionFooterHeight = 0;
        self.delegate = self;
        self.isNeedPullDownToRefreshAction = NO;
        self.isNeedPullUpToRefreshAction = NO;
    }
    return self;
}

- (void)setXYDataSource:(id<XYBaseTableViewDataSource>)XYDataSource {
    if (_XYDataSource != XYDataSource) {
        _XYDataSource = XYDataSource;
        self.dataSource = XYDataSource;
    }
}

#pragma mark - 上拉加载和下拉刷新
- (void)setIsNeedPullDownToRefreshAction:(BOOL)isEnable {
    if (_isNeedPullDownToRefreshAction == isEnable) {
        return;
    }
    _isNeedPullDownToRefreshAction = isEnable;
    if (_isNeedPullDownToRefreshAction) {
        @weakify(self);
        self.mj_header = [XYRefreshHeader headerWithRefreshingBlock:^{
            @strongify(self);
            if ([self.XYDelegate respondsToSelector:@selector(pullDownToRefreshAction)]) {
                [self.XYDelegate pullDownToRefreshAction];
            }
        }];
    }
}

- (void)setIsNeedPullUpToRefreshAction:(BOOL)isEnable
{
    if (_isNeedPullUpToRefreshAction == isEnable) {
        return;
    }
    _isNeedPullUpToRefreshAction = isEnable;
    @weakify(self);
    if (_isNeedPullUpToRefreshAction) {

        self.mj_footer = [XYRefreshFooter footerWithRefreshingBlock:^{
            @strongify(self);
            if ([self.XYDelegate respondsToSelector:@selector(pullUpToRefreshAction)]) {
                [self.XYDelegate pullUpToRefreshAction];
            }
        }];
    }
}

- (void)stopRefreshingAnimation {
    if ([self.mj_header isRefreshing]) {
        [self.mj_header endRefreshing];
    }
    if ([self.mj_footer isRefreshing]) {
        [self.mj_footer endRefreshing];
    }
}

- (void)triggerRefreshing {
    [self.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    id<XYBaseTableViewDataSource> dataSource = (id<XYBaseTableViewDataSource>)tableView.dataSource;
    
    XYBaseTableViewItem *object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    if (object.cellClass.isNotBlank) {
        return AdaptedHeight(object.cellHeight);
        
    } else {
        Class cls = [dataSource tableView:tableView cellClassForObject:object];
        
        object.cellHeight = [cls tableView:tableView rowHeightForObject:object];
        
        return object.cellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.XYDelegate respondsToSelector:@selector(didSelectObject:atIndexPath:)]) {
        id<XYBaseTableViewDataSource> dataSource = (id<XYBaseTableViewDataSource>)tableView.dataSource;
        id object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
        [self.XYDelegate didSelectObject:object atIndexPath:indexPath];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if ([self.XYDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.XYDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    id<XYBaseTableViewDataSource> dataSource = (id<XYBaseTableViewDataSource>)tableView.dataSource;
    XYBaseTableViewSectionObject *sectionObject = [((XYBaseTableViewDataSource *)dataSource).sections objectAtIndex:section];
    if (sectionObject.headerInfo.className.isNotBlank) {
        Class headerClass = NSClassFromString(sectionObject.headerInfo.className);
        XYBaseHeaderFooterView *header = (XYBaseHeaderFooterView *)[[headerClass alloc] init];
        header.info = sectionObject.headerInfo;
        return header;
        
    } else if ([self.XYDelegate respondsToSelector:@selector(headerViewForSectionObject:atSection:)]) {
        
        return [self.XYDelegate headerViewForSectionObject:sectionObject atSection:section];
    }
    else if ([self.XYDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]) {
        return [self.XYDelegate tableView:tableView viewForHeaderInSection:section];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    id<XYBaseTableViewDataSource> dataSource = (id<XYBaseTableViewDataSource>)tableView.dataSource;
    XYBaseTableViewSectionObject *sectionObject = [((XYBaseTableViewDataSource *)dataSource).sections objectAtIndex:section];
    
    if (sectionObject.headerInfo.className.isNotBlank) {
        return sectionObject.headerInfo.height;
        
    } else if ([self.XYDelegate respondsToSelector:@selector(headerHeightForSectionObject:atSection:)]) {
        return [self.XYDelegate headerHeightForSectionObject:sectionObject atSection:section];
    }
    else if ([self.XYDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
        return [self.XYDelegate tableView:tableView heightForHeaderInSection:section];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    id<XYBaseTableViewDataSource> dataSource = (id<XYBaseTableViewDataSource>)tableView.dataSource;
    XYBaseTableViewSectionObject *sectionObject = [((XYBaseTableViewDataSource *)dataSource).sections objectAtIndex:section];
    
    if (sectionObject.footerInfo.className.isNotBlank) {
        Class headerClass = NSClassFromString(sectionObject.footerInfo.className);
        XYBaseHeaderFooterView *footer = (XYBaseHeaderFooterView *)[[headerClass alloc] init];
        footer.info = sectionObject.footerInfo;
        return footer;
        
    } else if ([self.XYDelegate respondsToSelector:@selector(footerViewForSectionObject:atSection:)]) {
        return [self.XYDelegate footerViewForSectionObject:sectionObject atSection:section];
        
    } else if ([self.XYDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]) {
        return [self.XYDelegate tableView:tableView viewForFooterInSection:section];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    id<XYBaseTableViewDataSource> dataSource = (id<XYBaseTableViewDataSource>)tableView.dataSource;
    XYBaseTableViewSectionObject *sectionObject = [((XYBaseTableViewDataSource *)dataSource).sections objectAtIndex:section];
    if (sectionObject.footerInfo.className.isNotBlank) {
        return sectionObject.footerInfo.height;
    } else if ([self.XYDelegate respondsToSelector:@selector(footerHeightForSectionObject:atSection:)]) {
        return [self.XYDelegate footerHeightForSectionObject:sectionObject atSection:section];
    }
    else if ([self.XYDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]) {
        return [self.XYDelegate tableView:tableView heightForFooterInSection:section];
    }
    return 0;
}

#pragma mark - 传递原生协议

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    id<XYBaseTableViewDataSource> dataSource = (id<XYBaseTableViewDataSource>)tableView.dataSource;
    
    XYBaseTableViewItem *object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, object.leftSepartMargin, 0, object.rightSepartMargin)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, object.leftSepartMargin, 0, object.rightSepartMargin)];
    }
    if ([self.XYDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.XYDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section  {
    if ([self.XYDelegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]) {
        [self.XYDelegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

@end
