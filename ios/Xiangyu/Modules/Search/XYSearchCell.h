//
//  XYDemandCell.h
//  Xiangyu
//
//  Created by dimon on 04/02/2021.
//

#import <UIKit/UIKit.h>
#import "XYHomeSearchResultModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYDemandCell : UITableViewCell

@property (nonatomic, strong) XYDemandModel * item;

@end

@interface XYActivityCell : UITableViewCell

@property (nonatomic, strong) XYActivityModel * item;

@end

NS_ASSUME_NONNULL_END
