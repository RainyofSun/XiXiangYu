//
//  XYTopicTableViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/7/3.
//

#import <UIKit/UIKit.h>
#import "XYTopicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYTopicTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *tipLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *hotLabel;
@property(nonatomic,strong)UILabel *descLabel;

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property(nonatomic,strong)XYTopicModel *model;
@end

NS_ASSUME_NONNULL_END
