//
//  XYLinkageRecycleViewController.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/19.
//

#import "GKNavigationBarViewController.h"

@interface XYLinkageRecycleViewController : GKNavigationBarViewController

@property (nonatomic,copy) void(^selectedBlock)(NSString *name, NSNumber *firstCode, NSNumber *secondCode);

@end
