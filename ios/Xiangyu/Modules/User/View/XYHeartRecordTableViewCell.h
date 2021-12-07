//
//  XYHeartRecordTableViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/6/28.
//

#import "XYBaseTableViewCell.h"
#import "XYGetProfessModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYHeartRecordTableViewCell : XYBaseTableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *sexView;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *iconHeart;

@property(nonatomic,strong)XYQueryXdListModel *model;
@end

NS_ASSUME_NONNULL_END
