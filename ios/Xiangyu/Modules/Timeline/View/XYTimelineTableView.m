//
//  FSBaseTableView.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "XYTimelineTableView.h"
#import "XYDynamicsListController.h"
#import "XYTimelineVideoController.h"

@implementation FSBottomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}
#pragma mark Setter
- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
}

- (void)setCellCanScroll:(BOOL)cellCanScroll
{
    _cellCanScroll = cellCanScroll;
    
    for (UIViewController *VC in _viewControllers) {
      if ([VC isKindOfClass:[XYDynamicsListController class]]) {
        XYDynamicsListController *vc = (XYDynamicsListController *)VC;
        vc.vcCanScroll = cellCanScroll;
       if (!cellCanScroll) {
          vc.listView.contentOffset = CGPointZero;
        }
      }
      if ([VC isKindOfClass:[XYTimelineVideoController class]]) {
        XYTimelineVideoController *vc = (XYTimelineVideoController *)VC;
        vc.vcCanScroll = cellCanScroll;
      
       if (!cellCanScroll) {
          vc.collectionView.contentOffset = CGPointZero;
       }
      }
    }
}

- (void)refreshVideo {
  for (UIViewController *ctrl in self.viewControllers) {
      if ([ctrl isKindOfClass:[XYTimelineVideoController class]]) {
        XYTimelineVideoController *vc = (XYTimelineVideoController *)ctrl;
//        vc.isRefresh = YES;
      }
  }
}

- (void)refreshDynamic {
  for (UIViewController *ctrl in self.viewControllers) {
      if ([ctrl isKindOfClass:[XYDynamicsListController class]]) {
        XYDynamicsListController *vc = (XYDynamicsListController *)ctrl;
//        vc.isRefresh = YES;
      }
  }
}

@end

@implementation FSBaseTableView

/**
 同时识别多个手势

 @param gestureRecognizer gestureRecognizer description
 @param otherGestureRecognizer otherGestureRecognizer description
 @return return value description
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
