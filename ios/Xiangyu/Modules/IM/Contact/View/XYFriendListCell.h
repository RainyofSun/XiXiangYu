//
//  XYFriendListCell.h
//  Xiangyu
//
//  Created by dimon on 04/02/2021.
//

#import <UIKit/UIKit.h>
#import "XYFriendItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYFriendListCell : UITableViewCell

@property (nonatomic, copy) void(^actionBlock)(XYFriendItem *item);

@property (nonatomic, assign) BOOL isFriend;

@property (nonatomic, assign) BOOL centerAction;

@property (nonatomic, strong) XYFriendItem * item;

@end

NS_ASSUME_NONNULL_END
