//
//  XYHomeSelectedCityViewController.h
//  Xiangyu
//
//  Created by Kang on 2021/6/21.
//

#import "GKNavigationBarViewController.h"
#import "XYAddressItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYHomeSelectedCityViewController : GKNavigationBarViewController
@property (nonatomic,copy) void(^selectedBlock)(XYAddressItem *item);
@end

NS_ASSUME_NONNULL_END
