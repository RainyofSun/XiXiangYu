//
//  XYDoubleTableView.h
//  Xiangyu
//
//  Created by Kang on 2021/5/26.
//

#import <UIKit/UIKit.h>
#import "XYAddressItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYDoubleTableView : UIView
@property (nonatomic,copy) NSArray <XYAddressItem *> *proviceData;
@property (nonatomic,copy) NSArray <XYAddressItem *> *cityData;
@property (nonatomic,copy) void(^selectedBlock)(XYAddressItem *item);
@property(nonatomic,strong)XYAddressItem * __nullable proviceItem;
@property(nonatomic,strong)XYAddressItem *cityItem;
@property(nonatomic,strong)XYAddressItem *cutCity;
@end

NS_ASSUME_NONNULL_END
