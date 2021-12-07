//
//  XYSubSearchListController.h
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "GKNavigationBarViewController.h"
#import "XYSearchCell.h"

@interface XYSubSearchListController : GKNavigationBarViewController

@property (nonatomic, copy) NSArray <XYDemandModel *> *demandData;

@property (nonatomic, copy) NSArray <XYActivityModel *> *activityData;

@property (nonatomic, copy) NSString *cellClassString;

@property (nonatomic,assign) CGFloat cellHeight;


@end

