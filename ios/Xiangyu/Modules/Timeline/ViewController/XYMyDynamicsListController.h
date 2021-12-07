//
//  XYMyDynamicsListController.h
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "GKNavigationBarViewController.h"
#import "XYDynamicsListDataManager.h"

@interface XYMyDynamicsListController : GKNavigationBarViewController

@property (nonatomic, assign) BOOL needRefresh;

@property (nonatomic, assign, getter=isLocalData) BOOL localData;

@property (nonatomic, strong) XYDynamicsListDataManager *dataManager;

@end
