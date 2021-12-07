//
//  XYDefaultRollingNoticeView.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/5/29.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYDefaultRollingNoticeView.h"
#import "XYRollingNoticeView.h"
#import "XYDefaultRollingNoticeCell.h"

@interface XYDefaultRollingNoticeView () <XYRollingNoticeViewDataSource, XYRollingNoticeViewDelegate>

@property (nonatomic,strong) XYRollingNoticeView *noticeView;

@property (nonatomic,strong) UIImageView *bannerImageView;

@property (nonatomic,strong) UIView *separtView;

@end

@implementation XYDefaultRollingNoticeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    
    self.bannerImageView.frame = CGRectMake(10, 0, self.bannerImageView.image.size.width, self.bannerImageView.image.size.height);
    self.bannerImageView.centerY = self.XY_centerY;
    
    self.separtView.frame = CGRectMake(CGRectGetMaxX(self.bannerImageView.frame)+5, 0, 1, 16);
    self.separtView.centerY = self.XY_centerY;
    
    self.noticeView.frame = CGRectMake(CGRectGetMaxX(self.separtView.frame)+5, 0, self.XY_width - CGRectGetMaxX(self.separtView.frame)-5, self.XY_height);
    
    [self addSubview:self.bannerImageView];
    [self addSubview:self.separtView];
    [self addSubview:self.noticeView];
    
}

- (void)setItems:(NSArray *)items {
    _items = items;
    
    [self.noticeView reloadDataAndStartRolling];
}

- (NSInteger)numberOfRowsForNoticeView:(XYRollingNoticeView *)noticeView {
    return _items.count;
}

- (XYRollingNoticeCell *)noticeView:(XYRollingNoticeView *)noticeView atIndex:(NSUInteger)index {
    XYDefaultRollingNoticeCell *cell = [noticeView dequeueReusableCellWithIdentifier:@"XYDefaultRollingNoticeCell"];
    cell.content = _items[index];
    cell.index = [NSString stringWithFormat:@"%ld/%ld",index+1,_items.count];
    return cell;
}

- (void)didClickNoticeView:(XYRollingNoticeView *)noticeView atIndex:(NSUInteger)index {
    DLog(@"点击的index: %ld", index);
}

#pragma mark - getter
- (XYRollingNoticeView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[XYRollingNoticeView alloc] init];
        _noticeView.dataSource = self;
        _noticeView.delegate = self;
        [_noticeView registerClass:[XYDefaultRollingNoticeCell class] forCellReuseIdentifier:@"XYDefaultRollingNoticeCell"];
    }
    return _noticeView;
}

- (UIImageView *)bannerImageView {
    if (!_bannerImageView) {
        _bannerImageView = [[UIImageView alloc] init];
        _bannerImageView.image = [UIImage imageNamed:@"img_toutiao"];
    }
    return _bannerImageView;
}

- (UIView *)separtView {
    if (!_separtView) {
        _separtView = [[UIView alloc] init];
        _separtView.backgroundColor =ColorHex(XYThemeColor_F);
    }
    return _separtView;
}
@end
