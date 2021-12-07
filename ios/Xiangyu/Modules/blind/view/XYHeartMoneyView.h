//
//  XYHeartMoneyView.h
//  Xiangyu
//
//  Created by Kang on 2021/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYHeartMoneyView : UIView
@property(nonatomic,strong)NSArray *dataSource;
@property(nonatomic,strong)NSDictionary *currentObj;
@property (nonatomic,copy) void(^selectedBlock)(NSDictionary *item);
@end

NS_ASSUME_NONNULL_END
