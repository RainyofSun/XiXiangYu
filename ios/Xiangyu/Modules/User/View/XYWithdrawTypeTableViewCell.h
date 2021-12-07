//
//  XYWithdrawTypeTableViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/7/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYWithdrawTypeTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *headerImage;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *selectBtn;

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
