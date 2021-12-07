//
//  UIImage+Compress.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/25.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)
- (NSData *)compressImage {
    return [self resetImageDataWithImageWidth:640 maxFileSize:3*1024*1024];
}

- (UIImage *)imageByResizeToWidth:(CGFloat)width scale:(BOOL)scale
{
    if (self.size.width <= 0 || self.size.height <= 0) return nil;
    CGFloat height = width * self.size.height / self.size.width;
    return [self imageByResizeToSize:CGSizeMake(width, height) scale:scale];
}

- (UIImage *)imageByResizeToSize:(CGSize)size scale:(BOOL)scale
{
    if (size.width <= 0 || size.height <= 0) return nil;
    CGFloat scaleFactor = scale ? self.scale : 1.0;
    UIGraphicsBeginImageContextWithOptions(size, NO, scaleFactor);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

NS_INLINE CGFloat clampCompressionFactor(CGFloat factor)
{
    return factor <= 1e-5 ? 1e-5 : factor > 0.1 ? 0.1 : factor;
}

- (NSData *)compressToJPEGFormatDataWithFactor:(CGFloat)factor maxFileSize:(u_int64_t)fileSize
{
    if (!self) return nil;
    
    NSData *tempImageData = UIImageJPEGRepresentation(self, 1.0);
    if ([tempImageData length] <= fileSize) return tempImageData;
    
    NSData *targetImageData = nil;
    CGFloat compressionFactor = clampCompressionFactor(factor);
    CGFloat minFactor = 0;
    CGFloat maxFactor = 1.0;
    CGFloat midFactor = 0;
    
    while (fabs(maxFactor-minFactor) > compressionFactor)
    {
        @autoreleasepool
        {
            midFactor = minFactor + (maxFactor - minFactor)/2;
            tempImageData = UIImageJPEGRepresentation(self, midFactor);
            
            if ([tempImageData length] > fileSize)
            {
                maxFactor = midFactor;
            }
            else
            {
                minFactor = midFactor;
                targetImageData = tempImageData;
            }
        }
    }
    
    return targetImageData;
}

- (NSData *)resetImageDataWithImageWidth:(CGFloat)width maxFileSize:(uint64_t)maxFileSize
{
    // Image Size
    UIImage *newImage = [self imageByResizeToWidth:width scale:YES];
    
    // File Size
    return [newImage compressToJPEGFormatDataWithFactor:1e-5 maxFileSize:maxFileSize];
}

- (NSData *)resetImageDataWithImageSize:(CGSize)size maxFileSize:(uint64_t)maxFileSize
{
    // Image Size
    UIImage *newImage = [self imageByResizeToSize:size scale:YES];
    
    // File Size
    return [newImage compressToJPEGFormatDataWithFactor:1e-5 maxFileSize:maxFileSize];
}
- (UIImage*)imageWithCornerRadius:(CGFloat)radius{
  CGRect rect = (CGRect){0 ,0, self.size};
    // size——同UIGraphicsBeginImageContext,参数size为新创建的位图上下文的大小
    // opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
    // scale—–缩放因子
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    // 根据矩形画带圆角的曲线
  [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    [self drawInRect:rect];
    // 图片缩放，是非线程安全的
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return image;
}
@end
