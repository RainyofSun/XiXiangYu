//
//  FSBaseTableView.h
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYScrollContentView.h"

@interface FSBottomTableViewCell : UITableViewCell
@property (nonatomic, strong) XYPageContentView *pageContentView;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, assign) BOOL cellCanScroll;

- (void)refreshVideo;
- (void)refreshDynamic;

@end

@interface FSBaseTableView : UITableView<UIGestureRecognizerDelegate>

@end
