//
//  XYCommentLikeCell.h
//  Xiangyu
//
//  Created by dimon on 09/02/2021.
//

#import <UIKit/UIKit.h>
#import "XYDynamicsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYCommentLikeCell : UITableViewCell

@property (nonatomic, copy) NSArray <XYLikesUserModel *> * configData;

@end

NS_ASSUME_NONNULL_END
