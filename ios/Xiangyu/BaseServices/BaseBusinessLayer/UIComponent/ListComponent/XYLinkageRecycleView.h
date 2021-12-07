//
//  XYLinkageRecycleView.h
//  Xiangyu
//
//  Created by dimon on 02/02/2021.
//

#import <UIKit/UIKit.h>
#import "XYPlatformService.h"

@interface XYLinkageRecycleView : UIView

@property (nonatomic, copy) void(^selectedBlock)(NSNumber *selectedLeftIndex , NSNumber * selectedRightIndex);

@property (nonatomic,strong) NSArray <XYIndustryModel *> *dataSource;

@property (nonatomic, strong) NSNumber * selectedLeftIndex;

@property (nonatomic, strong) NSNumber * selectedRightIndex;

@end
