//
//  NSBundle+Extension.h
//  Xiangyu
//
//  Created by Jacky Dimon on 2017/10/13.
//  Copyright © 2017年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Extension)
/**
 *  @brief 从Picture.bundle中获取对应名称的图片
 *  @param name 图片名
 *  @param type 图片类型
 *
 */
+ (NSString *)pathForPictureName:(NSString *)name ofType:(NSString *)type;

/**
 *  @brief 从Resource.bundle中获取对应文件
 *  @param name 文件名
 *  @param type 文件类型
 *
 */
+ (NSString *)pathForResourceName:(NSString *)name ofType:(NSString *)type;

@end
