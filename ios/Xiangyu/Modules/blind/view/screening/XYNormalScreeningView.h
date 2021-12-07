//
//  XYNormalScreeningView.h
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
//

#import "FWPopupBaseView.h"
#import "XYFriendItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYNormalScreeningView : FWPopupBaseView
@property(nonatomic,strong)XYFriendDataReq *reqParams;

@property (nonatomic,copy) void(^selectedBlock)(NSDictionary *item);
@end

NS_ASSUME_NONNULL_END
