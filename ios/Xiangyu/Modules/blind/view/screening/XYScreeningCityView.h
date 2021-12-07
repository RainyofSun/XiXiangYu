//
//  XYScreeningCityView.h
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
//

#import "FWPopupBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYScreeningCityView : FWPopupBaseView
@property(nonatomic,strong)XYAddressItem *proviceItem;
@property(nonatomic,strong)XYAddressItem *cityItem;
@property(nonatomic,strong)XYAddressItem * __nullable areaItem;

@property (nonatomic,copy) void(^selectedBlock)(XYAddressItem *proviceItem, XYAddressItem *cityItem, XYAddressItem *areaItem);
@end

NS_ASSUME_NONNULL_END
