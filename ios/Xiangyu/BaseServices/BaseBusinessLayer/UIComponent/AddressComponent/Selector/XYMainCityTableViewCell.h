//
//  XYMainCityTableViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/5/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYMainCityTableViewCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,assign)BOOL isSelected;

@property(nonatomic,assign)BOOL isCut;
@end

NS_ASSUME_NONNULL_END
