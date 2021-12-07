//
//  XYSelectedCityViewController.h
//  Xiangyu
//
//  Created by Kang on 2021/5/26.
//

#import "GKNavigationBarViewController.h"
#import "XYAddressItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYSelectedCityViewController : GKNavigationBarViewController
@property (nonatomic,copy) void(^selectedBlock)(XYAddressItem *item);
@end

NS_ASSUME_NONNULL_END
