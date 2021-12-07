//
//  UIFont+Extension.h
//  Xiangyu
//
//  Created by 沈阳 on 2020/12/29.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FontStyle) {
    FontStyleMedium, // 中黑体
    FontStyleSemibold, // 中粗体
    FontStyleLight, // 细体
    FontStyleUltralight, // 极细体
    FontStyleRegular, // 常规体
    FontStyleThin, // 纤细体
};

@interface UIFont (Extension)

/**
 苹方字体

 @param fontWeight 字体粗细（字重)
 @param fontSize 字体大小
 @return 返回指定字重大小的苹方字体
 */
+ (UIFont *)pingFangSCWithWeight:(FontStyle)fontWeight size:(CGFloat)fontSize;

@end
