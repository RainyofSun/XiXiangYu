//
//  XYDynamicsListController.h
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import <UIKit/UIKit.h>
#import "XYDynamicsListDataManager.h"

@interface XYDynamicsListController : UIViewController

@property (nonatomic,assign) BOOL blendedMode;

//查询他人的动态传入此用户的ID
@property (nonatomic,strong) NSNumber *hisUserId;

@property (nonatomic, assign) XYDynamicsViewType viewType;

@property (strong, nonatomic) UITableView *listView;
@property (nonatomic, strong) XYDynamicsListDataManager *dataManager;
@property (nonatomic, assign) BOOL vcCanScroll;

-(void)reshScreollEnabel;
@end
