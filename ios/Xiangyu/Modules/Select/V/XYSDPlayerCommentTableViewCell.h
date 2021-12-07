//
//  XYSDPlayerCommentTableViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/8/6.
//

#import <UIKit/UIKit.h>
#import "XYDynamicsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYSDPlayerCommentTableViewCell : UITableViewCell
@property (nonatomic, strong) XYCommentModel * model;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic,copy) void(^deleteBlock)(void);
@end

NS_ASSUME_NONNULL_END
