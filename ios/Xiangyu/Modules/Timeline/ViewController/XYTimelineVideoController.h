//
//  XYTimelineVideoController.h
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "GKNavigationBarViewController.h"
#import "XYTimelineVideoDataManager.h"
@interface XYTimelineVideoController : GKNavigationBarViewController

@property (nonatomic,assign) BOOL blendedMode;

@property (nonatomic,strong) NSNumber *userId;

@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic,strong) XYTimelineVideoDataManager *dataManager;

@property (nonatomic,assign) BOOL vcCanScroll;
-(void)reshScreollEnabel;
@end

