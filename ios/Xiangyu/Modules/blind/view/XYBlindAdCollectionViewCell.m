//
//  XYBlindAdCollectionViewCell.m
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
//
//------made in china-------
/**   The code comes frome breakfly
 *
 *       ┏┓　　 ┏┓
 *     ┏━┛┻━━━━┛┻┓
 * 　　┃　  　━　 ┃
 * 　　┃ 　 ^    ^ ┃
 * 　　┃　　　 ┻　 ┃
 * 　　┗━━━━━━━━━┛
 *
 * --------萌萌哒-------
 */
#import "XYBlindAdCollectionViewCell.h"
#import "SDCycleScrollView.h"
@interface XYBlindAdCollectionViewCell ()<SDCycleScrollViewDelegate>

@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;

@end
@implementation XYBlindAdCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      self.contentView.backgroundColor = ColorHex(XYThemeColor_F);
      _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds delegate:self placeholderImage:nil];
      _cycleScrollView.layer.cornerRadius = 8;
      _cycleScrollView.layer.masksToBounds = YES;
      _cycleScrollView.delegate = self;
      _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
      _cycleScrollView.currentPageDotColor = [UIColor whiteColor];
      _cycleScrollView.hidden = YES;
      [self.contentView addSubview:_cycleScrollView];
      
      [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.edges.equalTo(self.contentView);
      }];
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
