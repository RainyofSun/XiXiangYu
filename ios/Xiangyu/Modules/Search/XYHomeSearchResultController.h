//
//  XYHomeSearchResultController.h
//  Xiangyu
//
//  Created by dimon on 18/03/2021.
//

#import "GKNavigationBarViewController.h"
#import "XYHomeSearchResultModel.h"

@interface XYHomeSearchResultController : GKNavigationBarViewController

@property (nonatomic,copy) NSString *keywords;

@property (nonatomic, strong) XYHomeSearchResultModel *searchData;

@end

