//
//  UIFont+Extension.m
//  Xiangyu
//
//  Created by 沈阳 on 2020/12/29.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)
+ (UIFont *)pingFangSCWithWeight:(FontStyle)fontWeight size:(CGFloat)fontSize {
    if (fontWeight < FontStyleMedium || fontWeight > FontStyleThin) {
        fontWeight = FontStyleRegular;
    }

    NSString *fontName = @"PingFangSC-Regular";
    switch (fontWeight) {
        case FontStyleMedium:
            fontName = @"PingFangSC-Medium";
            break;
        case FontStyleSemibold:
            fontName = @"PingFangSC-Semibold";
            break;
        case FontStyleLight:
            fontName = @"PingFangSC-Light";
            break;
        case FontStyleUltralight:
            fontName = @"PingFangSC-Ultralight";
            break;
        case FontStyleRegular:
            fontName = @"PingFangSC-Regular";
            break;
        case FontStyleThin:
            fontName = @"PingFangSC-Thin";
            break;
    }

    UIFont *font = [UIFont fontWithName:fontName size:fontSize];

    return font ?: [UIFont systemFontOfSize:fontSize];
}
@end
