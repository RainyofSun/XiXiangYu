//
//  XYImNextTableViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/7/13.
//

#import <UIKit/UIKit.h>
#import "XYFirendInfoObject.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYImNextTableViewCell : UITableViewCell
@property(nonatomic,strong)XYFirendInfoObject *model;
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
