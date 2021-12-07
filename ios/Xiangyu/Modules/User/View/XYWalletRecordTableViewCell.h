//
//  XYWalletRecordTableViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/6/28.
//

#import "XYBaseTableViewCell.h"
#import "XYWalletItemModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYWalletRecordTableViewCell : XYBaseTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *blanceLabel;

@property(nonatomic,strong)XYWalletItemModel *model;
@end

NS_ASSUME_NONNULL_END
