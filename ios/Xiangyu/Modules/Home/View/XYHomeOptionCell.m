//
//  XYHomeOptionCell.m
//  Xiangyu
//
//  Created by 沈阳 on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYHomeOptionCell.h"

@interface XYHomeOptionCell ()

@property (strong, nonatomic) UIView *bgView;

@end

@implementation XYHomeOptionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      self.contentView.backgroundColor = ColorHex(XYThemeColor_F);
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    [self.contentView addSubview:self.bgView];
    
    self.bgView.frame = CGRectMake(16, 12, kScreenWidth-32, 96);

}

- (void)didClickOptions:(UIGestureRecognizer *)ges {
  id target = ((NSArray *)self.item)[ges.view.tag - 100][XYHome_Router];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  if ([target respondsToSelector:@selector(didClickOptions:)]) {
    [target performSelector:@selector(didClickOptions:) withObject:@(ges.view.tag - 100)];
  }
#pragma clang diagnostic pop
}

- (void)setItem:(NSArray *)items {
    [super setItem:items];
  NSUInteger index = 0;
  CGFloat item_W = (kScreenWidth-32)/4;
  if (self.bgView.subviews.count) return;
  
  for (NSDictionary *item in items) {
    NSString *title = item[XYHome_Title];
    NSString *picURL = item[XYHome_PicURL];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((index%4) * item_W, (index/4)*84, item_W, 84)];
    view.tag = index + 100;
    view.backgroundColor = ColorHex(XYThemeColor_B);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickOptions:)];
    [view addGestureRecognizer:tap];
    [self.bgView addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((item_W-44)/2, 16, 44, 44)];
    imageView.image = [UIImage imageNamed:picURL];
    [view addSubview:imageView];
    
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 66, item_W, 18)];
    titleLable.textColor = ColorHex(XYTextColor_222222);
    titleLable.font = AdaptedFont(XYFont_D);
    titleLable.text = title;
    titleLable.textAlignment = NSTextAlignmentCenter;
    [view addSubview:titleLable];
    
    index ++;
  }
}

#pragma mark - getter

- (UIView *)bgView {
    if (!_bgView) {
      _bgView = [[UIView alloc] init];
      _bgView.backgroundColor = ColorHex(XYThemeColor_B);
      _bgView.layer.cornerRadius = 12;
      _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

@end
