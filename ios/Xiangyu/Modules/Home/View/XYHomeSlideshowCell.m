//
//  XYHomeSlideshowCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/30.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYHomeSlideshowCell.h"
#import "SDCycleScrollView.h"

@interface XYHomeSlideshowCell ()<SDCycleScrollViewDelegate>

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@end

@implementation XYHomeSlideshowCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      self.contentView.backgroundColor = ColorHex(XYThemeColor_F);
      _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(16, 0, kScreenWidth-32, (kScreenWidth-32)*0.32) delegate:self placeholderImage:nil];
      _cycleScrollView.layer.cornerRadius = 12;
      _cycleScrollView.layer.masksToBounds = YES;
      _cycleScrollView.delegate = self;
      _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
      _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
      _cycleScrollView.hidden = YES;
      [self.contentView addSubview:_cycleScrollView];
    }
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
  id target = (((NSArray *)self.item)[index])[XYHome_Router];
  NSDictionary *dict = ((NSArray *)self.item)[index];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([target respondsToSelector:@selector(didClickCycleScrollViewWithParam:)]) {
    [target performSelector:@selector(didClickCycleScrollViewWithParam:) withObject:dict];
  }
#pragma clang diagnostic pop
}

- (void)setItem:(NSArray *)item {
    [super setItem:item];
  NSMutableArray *arr_M = @[].mutableCopy;
  for (NSDictionary *info in item) {
    NSString *picUrl = info[XYHome_ImageUrl];
    if (picUrl.isNotBlank) [arr_M addObject:picUrl];
  }
  self.cycleScrollView.imageURLStringsGroup = arr_M;
  self.cycleScrollView.hidden = NO;
  
}
@end
