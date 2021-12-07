//
//  XYScreeningItemTableViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYScreeningItemTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,assign)BOOL isSelected;
@end

NS_ASSUME_NONNULL_END
