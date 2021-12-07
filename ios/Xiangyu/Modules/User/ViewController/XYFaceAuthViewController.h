//
//  XYFaceAuthViewController.h
//  Xiangyu
//
//  Created by dimon on 23/03/2021.
//

#import "GKNavigationBarViewController.h"

@interface XYFaceAuthViewController : GKNavigationBarViewController

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, copy) void(^successBlock)(void);

@end
