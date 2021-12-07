//
//  XYColorConfig.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/18.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ColorHex(color) [UIColor colorWithHexString:(color)]
#define FormattString(A,B) [NSString stringWithFormat:@"%@%@",A,B]
#define UIColorAlpha(color,alpha) ColorHex(FormattString((color),(alpha)))

/**
 *  @brief 不透明
 */
XY_EXTERN NSString * const XYColorAlpha_100;

/**
 *  @brief 透明度90
 */
XY_EXTERN NSString * const XYColorAlpha_90;

/**
 *  @brief 透明度80
 */
XY_EXTERN NSString * const XYColorAlpha_80;

/**
 *  @brief 透明度70
 */
XY_EXTERN NSString * const XYColorAlpha_70;

/**
 *  @brief 透明度60
 */
XY_EXTERN NSString * const XYColorAlpha_60;

/**
 *  @brief 透明度50
 */
XY_EXTERN NSString * const XYColorAlpha_50;

/**
 *  @brief 透明度40
 */
XY_EXTERN NSString * const XYColorAlpha_40;

/**
 *  @brief 透明度30
 */
XY_EXTERN NSString * const XYColorAlpha_30;

/**
 *  @brief 透明度20
 */
XY_EXTERN NSString * const XYColorAlpha_20;

/**
 *  @brief 透明度10
 */
XY_EXTERN NSString * const XYColorAlpha_10;

/**
 *  @brief 全透明
 */
XY_EXTERN NSString * const XYColorAlpha_0;
