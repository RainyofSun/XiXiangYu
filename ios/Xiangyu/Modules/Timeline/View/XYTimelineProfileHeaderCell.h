//
//  XYCommentListCell.h
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYTimelineProfileModel.h"

@interface XYTimelineProfileHeaderCell : UITableViewCell

@property (nonatomic,strong) XYTimelineProfileModel *model;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UIButton *attentionBtn;

@property (nonatomic,strong) UIImageView *iconBgView;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic,copy) void(^addFriendsBlock)(void);
@property (nonatomic,copy) void(^attentionBlock)(void);
@property (nonatomic,copy) void(^remarkBlock)(void);

@end
