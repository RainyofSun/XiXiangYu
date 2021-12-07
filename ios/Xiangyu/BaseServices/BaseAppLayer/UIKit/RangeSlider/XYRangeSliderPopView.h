//
//  XYRangeSliderView.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYRangeSliderPopView : UIView

- (instancetype)initWithMinValue:(NSUInteger)minValue maxValue:(NSUInteger)maxValue unit:(NSString *)unit;

- (instancetype)initWithMinValue:(NSUInteger)minValue maxValue:(NSUInteger)maxValue  minSelectValue:(NSUInteger)minSelectValue maxSelectValue:(NSUInteger)maxSelectValue   unit:(NSString *)unit;

@property (nonatomic,copy) void(^dismissBlock)(void);

@property (nonatomic,copy) void(^selectedBlock)(NSNumber *min, NSNumber *max);

@property (nonatomic,copy) NSString *title;



- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
