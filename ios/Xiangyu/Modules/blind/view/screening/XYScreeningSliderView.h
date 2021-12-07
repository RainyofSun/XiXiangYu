//
//  XYScreeningSliderView.h
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
//

#import <UIKit/UIKit.h>
#import "XYRangeSlider.h"
NS_ASSUME_NONNULL_BEGIN

@interface XYScreeningSliderView : UIView
@property(nonatomic,strong)NSString *title;
//@property(nonatomic,strong)NSString *unit;
- (instancetype)initWithMinValue:(NSUInteger)minValue maxValue:(NSUInteger)maxValue  minSelectValue:(NSUInteger)minSelectValue maxSelectValue:(NSUInteger)maxSelectValue  unit:(NSString *)unit;

-(void)insetMinSelectValue:(NSUInteger)minSelectValue maxSelectValue:(NSUInteger)maxSelectValue ;

@property (nonatomic,strong) XYRangeSlider *slider;
@property (nonatomic,copy) void(^selectedBlock)(NSNumber *min, NSNumber *max);
@end

NS_ASSUME_NONNULL_END
