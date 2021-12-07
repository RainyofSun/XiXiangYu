//
//  XYRefreshFooter.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYRefreshFooter.h"
#import <Lottie/Lottie.h>

@interface XYRefreshFooter ()

@property (weak, nonatomic) UILabel *textLable;

@property (weak, nonatomic) LOTAnimationView *animationView;

@end

@implementation XYRefreshFooter
    
- (void)prepare {
    [super prepare];
    self.XY_height = 60;
    UILabel *label = [[UILabel alloc] init];
    label.textColor = ColorHex(XYTextColor_666666);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = AdaptedFont(XYFont_A);
    [self addSubview:label];
    self.textLable = label;
    
    NSString *path = [NSBundle pathForResourceName:@"data" ofType:@"json"];
    LOTAnimationView *animation = [LOTAnimationView animationWithFilePath:path];
    [animation setLoopAnimation:YES];
    [self addSubview:animation];
    self.animationView = animation;
}
#pragma mark -
- (void)placeSubviews {
    [super placeSubviews];
  
    self.animationView.frame = CGRectMake(0, 10, 30, 30);
    
    self.animationView.XY_centerX = self.XY_centerX;
    
    self.textLable.frame = CGRectMake(0, 40, self.XY_width, 20);
    
    self.textLable.XY_centerX = self.XY_centerX;
}

#pragma mark -
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        self.textLable.text = @"上拉加载";
        break;
        case MJRefreshStateRefreshing:
        {
            self.textLable.text = @"加载中...";
            [self.animationView play];
        }
        break;
        case MJRefreshStateNoMoreData:
        self.textLable.text = @"我是有底线的";
        break;
        default:
        break;
    }
    
}
    
- (void)endRefreshing {
    [super endRefreshing];
    [self.animationView stop];
}

@end
