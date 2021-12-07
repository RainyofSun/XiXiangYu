//
//  XYCommentListCell.h
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYTimelineProfileVideoCell : UICollectionViewCell

@property (nonatomic, assign) BOOL shouldEdit;

@property (nonatomic, assign) BOOL shouldDelete;

@property (nonatomic,copy) NSString *coverUrl;
@property (nonatomic,copy) NSString *locationUrl;
@property (nonatomic,copy) NSString *count;

@property (nonatomic,copy) void(^deleteBlock)(void);

@property (nonatomic,copy) void(^editBlock)(void);

@end
