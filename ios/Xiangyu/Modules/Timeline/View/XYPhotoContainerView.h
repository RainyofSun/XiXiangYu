//
//  XYPhotoContainerView.h
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/12/23.
//  Copyright © 2015年 gsd. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * GSD_WeiXin
 *
 * QQ交流群: 459274049
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios/GSD_WeiXin
 * 新浪微博:GSD_iOS
 *
 * 此“高仿微信”用到了很高效方便的自动布局库SDAutoLayout（一行代码搞定自动布局）
 * SDAutoLayout地址：https://github.com/gsdios/SDAutoLayout
 * SDAutoLayout视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * SDAutoLayout用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 *
 *********************************************************************************
 
 */

#import <UIKit/UIKit.h>

@interface XYPhotoContainerView : UIView

@property (nonatomic, strong) NSArray *picPathStringsArray;

@property (nonatomic, strong) UIViewController * superView;
@property (nonatomic, assign) int customImgWidth;

@property (nonatomic, assign, getter=isVideoImage) BOOL videoImage;

@property (nonatomic, copy) void(^clickBlock)(void);

+ (CGSize)getContainerSizeWithPicPathStringsArray:(NSArray *)picPathStringsArray;

@end
