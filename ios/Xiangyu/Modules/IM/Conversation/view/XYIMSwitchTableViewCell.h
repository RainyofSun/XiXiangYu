//
//  XYIMSwitchTableViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/7/13.
//

#import <UIKit/UIKit.h>
#import "XYFirendInfoObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYIMSwitchTableViewCell : UITableViewCell
@property(nonatomic,strong)XYFirendInfoObject *model;
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@property(nonatomic,copy)void(^switchBlock)(BOOL on);

@end

NS_ASSUME_NONNULL_END
