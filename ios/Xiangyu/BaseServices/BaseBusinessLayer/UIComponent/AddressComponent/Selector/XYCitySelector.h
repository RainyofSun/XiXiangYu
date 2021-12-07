//
//  XYCitySelector.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/21.
//

#import "GKNavigationBarViewController.h"
#import "XYAddressItem.h"

@interface XYCitySelector : GKNavigationBarViewController

@property (nonatomic,copy) void(^selectedBlock)(XYAddressItem *item);

@end
