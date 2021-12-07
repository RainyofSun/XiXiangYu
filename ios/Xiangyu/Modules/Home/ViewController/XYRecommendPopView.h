//
//  XYRecommendPopView.h
//  Xiangyu
//
//  Created by dimon on 29/03/2021.
//

#import <UIKit/UIKit.h>
#import "XYInterestModel.h"

@interface XYRecommendPopView : UIView

@property (nonatomic,copy) NSArray <XYInterestItem *> *data;

@property (nonatomic,copy) void(^dismissBlock)(void);

@property (nonatomic,copy) void(^addBlock)(XYInterestItem *item , BOOL group);

- (void)showOnView:(UIView *)view;

- (void)dismiss;

@end
