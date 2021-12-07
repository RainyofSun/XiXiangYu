//
//  YLRangeSliderViewDelegate.h
//  FantasyRealFootball
//
//  Created by Tom Thorpe on 16/04/2014.
//  Copyright (c) 2014 Yahoo inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XYRangeSlider;

@protocol XYRangeSliderDelegate <NSObject>

@optional

/**
 * Called when the RangeSlider values are changed
 */
-(void)rangeSlider:(XYRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum;

/**
 * Called when the user has finished interacting with the RangeSlider
 */
- (void)didEndTouchesInRangeSlider:(XYRangeSlider *)sender;

/**
 * Called when the user has started interacting with the RangeSlider
 */
- (void)didStartTouchesInRangeSlider:(XYRangeSlider *)sender;

@end
