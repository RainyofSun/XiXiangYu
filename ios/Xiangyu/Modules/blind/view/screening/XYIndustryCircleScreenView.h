//
//  XYIndustryCircleScreenView.h
//  Xiangyu
//
//  Created by Kang on 2021/8/9.
//

#import "FWPopupBaseView.h"
#import "XYFriendItem.h"
#import "GKNavigationBarViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYIndustryCircleScreenView : FWPopupBaseView
@property(nonatomic,strong)XYFriendDataReq *reqParams;
@property(nonatomic,strong)NSString *industryName;

@property (nonatomic,copy) void(^selectedBlock)(NSDictionary *item);
@property(nonatomic,strong)GKNavigationBarViewController *targetVc;

@end

NS_ASSUME_NONNULL_END
