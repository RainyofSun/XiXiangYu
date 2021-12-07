//
//  XYSubSearchFriendController.h
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "GKNavigationBarViewController.h"
#import "XYSearchVideoDataManager.h"

@interface XYSubSearchFriendController : GKNavigationBarViewController

@property (nonatomic, assign) BOOL needRefresh;

- (void)fetchNewDataWithKeywords:(NSString *)keywords;

@property (nonatomic,strong) XYSearchVideoDataManager *dataManager;

@end

