//
//  XYIndustryCircleCell.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import <UIKit/UIKit.h>
#import "XYInterestModel.h"

@interface XYIndustryCircleCell : UITableViewCell

@property (nonatomic,copy) void(^addBlock)(XYInterestItem *item);

@property (nonatomic,strong) XYInterestItem *item;

@end
