//
//  XYHomeDoubleTableView.h
//  Xiangyu
//
//  Created by Kang on 2021/6/21.
//

#import <UIKit/UIKit.h>
#import "XYAddressItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYHomeDoubleTableView : UIView
@property (nonatomic,copy) NSArray <XYAddressItem *> *proviceData;
@property (nonatomic,copy) NSArray <XYAddressItem *> *cityData;
@property (nonatomic,copy) NSArray <XYAddressItem *> *hotCityData;
@property (nonatomic,copy) void(^selectedBlock)(XYAddressItem *item);
@property(nonatomic,strong)XYAddressItem * __nullable proviceItem;
@property(nonatomic,strong)XYAddressItem *cityItem;
@property(nonatomic,strong)XYAddressItem *cutCity;
@end

NS_ASSUME_NONNULL_END
