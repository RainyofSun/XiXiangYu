//
//  XYHomeRecommendPopController.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/23.
//

#import <UIKit/UIKit.h>

@interface XYHomeAwardController : UIViewController

@property (nonatomic, strong) NSNumber * gold;

@property (nonatomic, copy) void(^exchangeBlock)(void);

@property (nonatomic, copy) void(^dismissBlock)(void);

@end
