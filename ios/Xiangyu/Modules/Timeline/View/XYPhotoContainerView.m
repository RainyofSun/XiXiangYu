//
//  XYPhotoContainerView.m
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

#import "XYPhotoContainerView.h"

#import <UIImageView+WebCache.h>

//#import "YBImageBrowser.h"


@interface XYPhotoContainerView ()

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation XYPhotoContainerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    NSMutableArray *temp = [NSMutableArray new];
    
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [UIImageView new];
        [self addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
      imageView.layer.cornerRadius = 8;
      imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
      
      UIImageView *playImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_22bofang"]];
      playImageView.hidden = YES;
      [imageView addSubview:playImageView];
      
        [temp addObject:imageView];
    }
    
    self.imageViewsArray = [temp copy];
}


- (void)setPicPathStringsArray:(NSArray *)picPathStringsArray
{
    _picPathStringsArray = picPathStringsArray;
    
    for (long i = _picPathStringsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
        imageView.subviews.firstObject.hidden = YES;
    }
    
    if (_picPathStringsArray.count == 0) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0, 0);
        return;
    }
    
    CGFloat itemW = [XYPhotoContainerView itemWidthForPicPathArray:_picPathStringsArray];
    CGFloat itemH = _picPathStringsArray.count == 1 ? itemW*0.8 : itemW;
  
    long perRowItemCount = [XYPhotoContainerView perRowItemCountForPicPathArray:_picPathStringsArray];
    CGFloat margin = 5;
    
    [_picPathStringsArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        long columnIndex = idx % perRowItemCount;
        long rowIndex = idx / perRowItemCount;
        UIImageView *imageView = [_imageViewsArray objectAtIndex:idx];
        imageView.hidden = NO;

        NSURL * url = [NSURL URLWithString:_picPathStringsArray[idx]];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeHolderImg"] options:SDWebImageRetryFailed];
        imageView.frame = CGRectMake(columnIndex * (itemW + margin), rowIndex * (itemH + margin), itemW, itemH);
      imageView.contentMode=itemW==itemH? UIViewContentModeScaleAspectFill:UIViewContentModeScaleAspectFit;
      imageView.subviews.firstObject.hidden = !self.isVideoImage;
      imageView.subviews.firstObject.XY_centerX = imageView.XY_centerX;
      imageView.subviews.firstObject.XY_centerY = imageView.XY_centerY;
      imageView.subviews.firstObject.XY_width = 22;
      imageView.subviews.firstObject.XY_height = 22;
    }];
    
    CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
    int columnCount = ceilf(_picPathStringsArray.count * 1.0 / perRowItemCount);
    CGFloat h = columnCount * itemH + (columnCount - 1) * margin;

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, w, h);
}

#pragma mark - private actions

- (void)tapImageView:(UITapGestureRecognizer *)tap {
//    NSMutableArray * items = [NSMutableArray array];
//    for (int i = 0; i < _picPathStringsArray.count; i++) {
//      YBIBImageData *data = [YBIBImageData new];
//      data.imageURL = [NSURL URLWithString:_picPathStringsArray[i]];
//      data.projectiveView = _imageViewsArray[i];
//      [items addObject:data];
//    }
//  YBImageBrowser *browser = [YBImageBrowser new];
//  browser.dataSourceArray = items;
//  browser.currentPage = tap.view.tag;
//  [browser show];
  if (self.clickBlock) {
    self.clickBlock();
  }
}

+ (CGFloat)itemWidthForPicPathArray:(NSArray *)array {
    if (array.count == 1) {
        return kScreenWidth-140;
    } else {
      CGFloat w = kScreenWidth > 320 ? 80 : 70;
      return w;
    }
}

+ (NSInteger)perRowItemCountForPicPathArray:(NSArray *)array {
    if (array.count < 4) {
        return array.count;
    } else if (array.count <= 4) {
        return 2;
    } else {
        return 3;
    }
}

+ (CGSize)getContainerSizeWithPicPathStringsArray:(NSArray *)picPathStringsArray {
  CGFloat itemW = [self itemWidthForPicPathArray:picPathStringsArray];
  CGFloat itemH = picPathStringsArray.count == 1 ? itemW*0.8 : itemW;

  long perRowItemCount = [self perRowItemCountForPicPathArray:picPathStringsArray];
  CGFloat margin = 5;
  
  CGFloat w = perRowItemCount * itemW + (perRowItemCount - 1) * margin;
  int columnCount = ceilf(picPathStringsArray.count * 1.0 / perRowItemCount);
  CGFloat h = columnCount * itemH + (columnCount - 1) * margin;
  
  return CGSizeMake(w, h);
}
@end
