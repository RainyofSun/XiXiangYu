//
//  UIButton+Helper.m
//  GeXiaZi
//
//  Created by apple on 16/6/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIButton+Helper.h"
#import <objc/runtime.h>
//#import "DefaultPageSource.h"
//国际化语言包切换
//#import "Localisator.h"

@implementation UIButton(Helper)
/**
 *  按钮上的图片跟文字，居中对齐
 */
-(void)TiaoZhengButtonWithOffsit:(CGFloat)offset TextImageSite:(UIButtonTextSite)site{
    if (site==UIButtonTextLeft) {
        [self TextImageLeftWithOffsit:offset];
    } else if (site==UIButtonTextTop) {
        [self TextImageTopWithOffsit:offset];
    } else  if (site==UIButtonTextBottom) {
        [self TextImageBottomWithOffsit:offset];
    }else{
        
        [self TextImageRightWithOffsit:offset];
    }
}
/**
 *  文字在右边，图片在左边，居中对齐
 *
 *  @param offset 文字跟图片间的间距大小
 */
-(void)TextImageRightWithOffsit:(CGFloat)offset{
    
    CGFloat offsetBetweenImageAndText = offset;
    CGFloat insetAmount = offsetBetweenImageAndText / 2.0;
    self.imageEdgeInsets = UIEdgeInsetsMake(0,-insetAmount, 0,insetAmount);
    self.titleEdgeInsets = UIEdgeInsetsMake(0,insetAmount, 0, -insetAmount);
    self.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
}
/**
 *  文字在左边，图片在右边，居中对齐
 *
 *  @param offset 文字跟图片间的间距大小
 */
-(void)TextImageLeftWithOffsit:(CGFloat)offset{
    CGFloat imgW=self.imageView.frame.size.width;
    CGFloat titleW=self.titleLabel.frame.size.width;
    CGFloat offsetBetweenImageAndText = offset;
    CGFloat insetAmount = offsetBetweenImageAndText / 2.0;
    self.imageEdgeInsets = UIEdgeInsetsMake(0,titleW+insetAmount, 0,-titleW-insetAmount);
    self.titleEdgeInsets = UIEdgeInsetsMake(0,-imgW-insetAmount, 0, imgW+insetAmount);
    self.contentEdgeInsets = UIEdgeInsetsMake(0, insetAmount, 0, insetAmount);
}
/**
 *  文字在下边，图片在上边，居中对齐
 *
 *  @param offset 文字跟图片间的间距大小
 */
-(void)TextImageBottomWithOffsit:(CGFloat)offset{
 //   CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    // 设置imageEdgeInsets
     self.titleLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat imgH=self.imageView.frame.size.height/2.0;
    CGFloat titleH=self.titleLabel.frame.size.height/2.0;
    
    CGFloat imgW=self.imageView.frame.size.width;
    CGFloat titleW=self.titleLabel.frame.size.width/2.0;
    
    CGFloat offsetBetweenImageAndText = offset;
    CGFloat insetAmount = offsetBetweenImageAndText / 2.0;
    
    CGFloat imageEdgeInsetsTop = -titleH-insetAmount;
    CGFloat imageEdgeInsetsLeft = titleW; // endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = imgH+insetAmount;
    CGFloat titleEdgeInsetsLeft = -imgW; //endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight =0;
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
}
/**
 *  文字在上边，图片在下边，居中对齐
 *
 *  @param offset 文字跟图片间的间距大小
 */
-(void)TextImageTopWithOffsit:(CGFloat)offset{
    CGPoint buttonBoundsCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    // 找出imageView最终的center
    CGPoint endImageViewCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetMidY(self.imageView.bounds));
    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointMake(buttonBoundsCenter.x, CGRectGetHeight(self.bounds)-CGRectGetMidY(self.titleLabel.bounds));
    // 取得imageView最初的center
    CGPoint startImageViewCenter = self.imageView.center;
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    // 设置imageEdgeInsets
    CGFloat imgH=self.imageView.frame.size.height/2.0;
    CGFloat titleH=self.titleLabel.frame.size.height/2.0;
    CGFloat offsetBetweenImageAndText = offset;
    CGFloat insetAmount = offsetBetweenImageAndText / 2.0;
    
    CGFloat imageEdgeInsetsTop = titleH+insetAmount;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = -imgH-insetAmount;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
}
#pragma mark - 获取验证码倒计时
-(NSString *)disableTitle{
//
    return objc_getAssociatedObject(self, @selector(setDisableTitle:));
}
-(void)setDisableTitle:(NSString *)disableTitle{
    objc_setAssociatedObject(self, @selector(setDisableTitle:), disableTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSTimer *)timer{
      return objc_getAssociatedObject(self, @selector(setTimer:));
}
-(void)setTimer:(NSTimer *)timer{
    objc_setAssociatedObject(self, @selector(setTimer:), timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSInteger)timeout1{
    return [objc_getAssociatedObject(self, @selector(setTimeout1:)) integerValue];
}
-(void)setTimeout1:(NSInteger)timeout1{
    objc_setAssociatedObject(self, @selector(setTimeout1:), @(timeout1), OBJC_ASSOCIATION_ASSIGN);
}
-(void)StartMsgCodeTimeDown
{
   self. timeout1 = MsgCodeTime;
    
    
//    [self setTitle:[self.disableTitle==nil? LOCALIZATION(@"Login_Code_Btn_Action"):self.disableTitle stringByReplacingOccurrencesOfString:@"XXX" withString:[@(self.timeout1) toString]] forState:UIControlStateDisabled];
      self.enabled=NO;
   // self.layer.borderColor = blackLineColore.CGColor;
    self.timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeji) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}
-(void)timeji{
    NSTimer *_timer=self.timer;
       self. timeout1--;
    if (  self. timeout1 <= 0) {
        [_timer invalidate];
        _timer = nil;
        self.enabled=YES;
      //  self.layer.borderColor = mainColor.CGColor;
    }else {
//         [self setTitle:[self.disableTitle==nil? LOCALIZATION(@"Login_Code_Btn_Action"):self.disableTitle stringByReplacingOccurrencesOfString:@"XXX" withString:[@(self.timeout1) toString]] forState:UIControlStateDisabled];
        self.enabled = NO;
    }
}
-(void)dealloc{
    NSTimer *_timer=self.timer;
    if (_timer) {
       [_timer invalidate];
       _timer = nil;
    }
}
- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &@selector(handleControlEvent:withBlock:), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(outActionBlock:) forControlEvents:event];
}
- (void) handleControlEventWithBlock:(ActionBlock)action{
    objc_setAssociatedObject(self, &@selector(handleControlEventWithBlock:), action, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)outActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &@selector(handleControlEvent:withBlock:));
    if (block) {
        block(sender);
    }
}

- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &@selector(handleControlEventWithBlock:));
    if (block) {
        block(sender);
    }
}
@end
