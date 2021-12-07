//
//  XYNearbyHomeScreenView.h
//  Xiangyu
//
//  Created by Kang on 2021/8/8.
//

#import "FWPopupBaseView.h"
#import "XYFriendItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYNearbyHomeScreenView : FWPopupBaseView
@property(nonatomic,strong)XYFriendDataReq *reqParams;

@property (nonatomic,copy) void(^selectedBlock)(NSDictionary *item);
@end

NS_ASSUME_NONNULL_END
