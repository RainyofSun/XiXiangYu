//
//  XYFontConfig.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/12.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline UIFont* AdaptedFont(CGFloat fontSize){
//    if (kScreenWidth <= 375) {
        return [UIFont systemFontOfSize:fontSize];
//    } else {
//        return [UIFont systemFontOfSize:fontSize * 1.1];
//    }
}

static inline UIFont* AdaptedMediumFont(CGFloat fontSize){
//    if (kScreenWidth <= 375) {
        return [UIFont pingFangSCWithWeight:FontStyleMedium size:fontSize];
//    } else {
//        return [UIFont pingFangSCWithWeight:FontStyleMedium size:fontSize * 1.1];
//    }
}

static inline UIFont* AdaptedBlodFont(CGFloat fontSize){
//    if (kScreenWidth <= 375) {
        return [UIFont pingFangSCWithWeight:FontStyleSemibold size:fontSize];
//    } else {
//        return [UIFont pingFangSCWithWeight:FontStyleSemibold size:fontSize * 1.1];
//    }
}

static inline UIFont* AdaptedRegularFont(CGFloat fontSize){
//    if (kScreenWidth <= 375) {
        return [UIFont pingFangSCWithWeight:FontStyleRegular size:fontSize];
//    } else {
//        return [UIFont pingFangSCWithWeight:FontStyleRegular size:fontSize * 1.1];
//    }
}

/**
 *  @brief 11号字体
 */
XY_EXTERN CGFloat const XYFont_A;

/**
 *  @brief 12号字体
 */
XY_EXTERN CGFloat const XYFont_B;

/**
 *  @brief 13号字体
 */
XY_EXTERN CGFloat const XYFont_C;

/**
 *  @brief 14号字体
 */
XY_EXTERN CGFloat const XYFont_D;

/**
 *  @brief 16号字体
 */
XY_EXTERN CGFloat const XYFont_E;

/**
 *  @brief 17号字体
 */
XY_EXTERN CGFloat const XYFont_F;

/**
 *  @brief 18号字体
 */
XY_EXTERN CGFloat const XYFont_G;

/**
 *  @brief 27号字体
 */
XY_EXTERN CGFloat const XYFont_H;

/**
 *  @brief 24号字体
 */
XY_EXTERN CGFloat const XYFont_I;
