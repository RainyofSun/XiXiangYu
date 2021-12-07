//
//  XYBaseTableView.h
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYBaseTableViewDataSource.h"

@class XYBaseTableViewSectionObject;
@protocol XYBaseTableViewDelegate <UITableViewDelegate>

@optional

- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

- (UIView *)headerViewForSectionObject:(XYBaseTableViewSectionObject *)sectionObject atSection:(NSInteger)section;

- (CGFloat)headerHeightForSectionObject:(XYBaseTableViewSectionObject *)sectionObject atSection:(NSInteger)section;

- (UIView *)footerViewForSectionObject:(XYBaseTableViewSectionObject *)sectionObject atSection:(NSInteger)section;

- (CGFloat)footerHeightForSectionObject:(XYBaseTableViewSectionObject *)sectionObject atSection:(NSInteger)section;

- (void)pullDownToRefreshAction;


- (void)pullUpToRefreshAction;

@end

@interface XYBaseTableView : UITableView<UITableViewDelegate>

@property (nonatomic, weak) id<XYBaseTableViewDataSource> XYDataSource;

@property (nonatomic, weak) id<XYBaseTableViewDelegate> XYDelegate;


@property (nonatomic, assign) BOOL isNeedPullDownToRefreshAction;

@property (nonatomic, assign) BOOL isNeedPullUpToRefreshAction;

- (void)stopRefreshingAnimation;

- (void)triggerRefreshing;

@end
