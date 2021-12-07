//
//  XYRollingNoticeView.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYRollingNoticeCell.h"

@class XYRollingNoticeView;
@protocol XYRollingNoticeViewDataSource <NSObject>
@required
- (NSInteger)numberOfRowsForNoticeView:(XYRollingNoticeView *)noticeView;

- (XYRollingNoticeCell *)noticeView:(XYRollingNoticeView *)noticeView atIndex:(NSUInteger)index;

@end

@protocol XYRollingNoticeViewDelegate <NSObject>
@optional
- (void)didClickNoticeView:(XYRollingNoticeView *)noticeView atIndex:(NSUInteger)index;

@end

@interface XYRollingNoticeView : UIView

@property (nonatomic, assign) id<XYRollingNoticeViewDataSource> dataSource;

@property (nonatomic, assign) id<XYRollingNoticeViewDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval stayInterval;

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

- (__kindof XYRollingNoticeCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)reloadDataAndStartRolling;

- (void)stopRolling;
@end
