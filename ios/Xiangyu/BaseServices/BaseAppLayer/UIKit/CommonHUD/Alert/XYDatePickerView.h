//
//  XYDatePickerView.h
//  Xiangyu
//
//  Created by 沈阳 on 2021/1/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYDatePickerView : UIView

@property (nonatomic,strong) NSDate * date;

@property (nonatomic,copy) void(^dismissBlock)(void);

@property (nonatomic,copy) void(^selectedBlock)(NSDate * date);

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
