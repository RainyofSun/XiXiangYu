//
//  XYFabulousTableViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/7/4.
//

#import <UIKit/UIKit.h>
#import "XYDynamicsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYFabulousTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *sexImage;
@property(nonatomic,strong)UILabel *homeLabel;
@property(nonatomic,strong)UIButton *chatBtn;
@property(nonatomic,strong)XYLikesUserModel *model;

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
