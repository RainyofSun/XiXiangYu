//
//  XYStarRateView.h
//  Xiangyu
//
//  Created by 沈阳 on 2018/6/1.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYStarRateView;
@protocol XYStarRateViewDelegate <NSObject>

@optional
- (void)starRateView:(XYStarRateView *)starRateView percentDidChange:(CGFloat)newPercent;
@end

@interface XYStarRateView : UIView

@property (nonatomic, assign) CGFloat score;

/** 评分时是否允许不是整星，默认为NO */
@property (nonatomic, assign) BOOL shouldRadix;

@property (nonatomic, assign) BOOL shouldGrade;

@property (nonatomic, weak) id<XYStarRateViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars;

@end
