//
//  XYWithdrawMoneyTableViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/7/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYWithdrawMoneyTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@property(nonatomic,strong)NSArray *dataSource;

@property(nonatomic,strong)NSString *currentObj;

@property (nonatomic,copy) void(^selectedBlock)(NSString *item);
@end

NS_ASSUME_NONNULL_END
