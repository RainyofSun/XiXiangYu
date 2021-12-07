//
//  XYBlindInfoCell.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/3/10.
//

#import <UIKit/UIKit.h>
#import "XYBlindProfileModel.h"

@interface XYBlindGiftListCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;

@property (nonatomic, copy) NSArray <XYBlindGiftModel *> * data;
@property (nonatomic, copy) void(^giftListClickToPage)(void);//

@end

