//
//  XYPageContentView.h
//  Huim
//
//  Created by huim on 2017/4/28.
//  Copyright © 2017年 huim. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYPageContentView;

@protocol XYPageContentViewDelegate <NSObject>

@optional

/**
 XYPageContentView开始滑动

 @param contentView XYPageContentView
 */
- (void)XYContentViewWillBeginDragging:(XYPageContentView *)contentView;

/**
 XYPageContentView滑动调用

 @param contentView XYPageContentView
 @param startIndex 开始滑动页面索引
 @param endIndex 结束滑动页面索引
 @param progress 滑动进度
 */
- (void)XYContentViewDidScroll:(XYPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress;

/**
 XYPageContentView结束滑动

 @param contentView XYPageContentView
 @param startIndex 开始滑动索引
 @param endIndex 结束滑动索引
 */
- (void)XYContenViewDidEndDecelerating:(XYPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

/**
 scrollViewDidEndDragging

 @param contentView XYPageContentView
 */
- (void)XYContenViewDidEndDragging:(XYPageContentView *)contentView;

@end

@interface XYPageContentView : UIView

/**
 对象方法创建XYPageContentView

 @param frame frame
 @param childVCs 子VC数组
 @param parentVC 父视图VC
 @param delegate delegate
 @return XYPageContentView
 */
- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<XYPageContentViewDelegate>)delegate;

@property (nonatomic, weak) id<XYPageContentViewDelegate>delegate;

/**
 设置contentView当前展示的页面索引，默认为0
 */
@property (nonatomic, assign) NSInteger contentViewCurrentIndex;

/**
 设置contentView能否左右滑动，默认YES
 */
@property (nonatomic, assign) BOOL contentViewCanScroll;

@end
