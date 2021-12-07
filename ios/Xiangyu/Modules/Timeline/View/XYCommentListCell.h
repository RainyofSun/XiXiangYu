//
//  XYCommentListCell.h
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDynamicsModel.h"

@interface XYCommentListCell : UITableViewCell

@property (nonatomic, strong) XYCommentModel * model;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic,assign) BOOL isFirstCell;
@property (nonatomic,assign) BOOL ishiddenCell;
@property (nonatomic,copy) void(^deleteBlock)(void);

@end
