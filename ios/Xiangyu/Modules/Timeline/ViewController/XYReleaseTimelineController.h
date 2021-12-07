//
//  XYReleaseTimelineController.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/3/14.
//

#import "GKNavigationBarViewController.h"
#import "XYReleaseDynamicDataManager.h"
typedef NS_ENUM(NSInteger, ReleaseDynamicType) {
  ReleaseDynamicType_Text = 1,
  ReleaseDynamicType_Shooting_Photo,
  ReleaseDynamicType_Shooting_Video,
  ReleaseDynamicType_Album_Photo,
  ReleaseDynamicType_Album_Video,
};
@interface XYReleaseTimelineController : GKNavigationBarViewController
@property (strong, nonatomic) XYReleaseDynamicDataManager *dataManager;
@property (nonatomic,assign) ReleaseDynamicType type;




@end
