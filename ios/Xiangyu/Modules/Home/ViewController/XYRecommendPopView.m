//
//  XYRecommendPopView.m
//  Xiangyu
//
//  Created by dimon on 29/03/2021.
//

#import "XYRecommendPopView.h"
#import "XYHomeRecommendCell.h"
#import "FriendRequestViewController.h"

@interface XYRecommendPopView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UIView *contentView;

@property (strong, nonatomic) UILabel *titleLable;

@property (strong, nonatomic) UIButton *closeBtn;

@property (strong, nonatomic) UITableView *listView;

@end

@implementation XYRecommendPopView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      self.backgroundColor = UIColorAlpha(XYThemeColor_D, XYColorAlpha_0);
      [self addSubviews];
      [self layoutPageSubviews];
    }
    return self;
}

- (void)addSubviews {
  [self addSubview:self.contentView];
  [self.contentView addSubview:self.titleLable];
  [self.contentView addSubview:self.closeBtn];
  [self.contentView addSubview:self.listView];
}

- (void)layoutPageSubviews {
  self.contentView.frame = CGRectMake(16, 120, kScreenWidth-32, kScreenHeight-240-TABBAR_HEIGHT);
    
  self.closeBtn.frame = CGRectMake(kScreenWidth-62, 8, 22, 22);
  
  self.titleLable.frame = CGRectMake(0, 24, kScreenWidth-32, 44);
  
  self.listView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLable.frame), kScreenWidth-32, CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(self.titleLable.frame));
    
}
- (void)showOnView:(UIView *)view {
    [view addSubview:self];
    self.frame = view.bounds;
    self.contentView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight-120-TABBAR_HEIGHT);
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = UIColorAlpha(XYThemeColor_D, XYColorAlpha_40);
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeTranslation(0, kScreenHeight-120-TABBAR_HEIGHT);
    } completion:^(BOOL finished) {
        if (self.dismissBlock) self.dismissBlock();
        [self removeFromSuperview];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 76;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *reuseID = @"kHomeRecommendCell";
  XYHomeRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[XYHomeRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
  cell.item = self.data[indexPath.row];
  cell.addBlock = ^(XYInterestItem *item) {
    if (item.isGroup) {
      if (self.addBlock) self.addBlock(item, YES);
    } else {
      if (self.addBlock) self.addBlock(item, NO);
    }
  };
    return cell;
}

#pragma mark - getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
      _contentView.backgroundColor = ColorHex(XYThemeColor_B);
      _contentView.layer.cornerRadius = 12;
      _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.dataSource = self;
        _listView.delegate = self;
    }
    return _listView;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
      _titleLable = [[UILabel alloc] init];
      _titleLable.textColor = ColorHex(XYTextColor_222222);
      _titleLable.font = AdaptedMediumFont(XYFont_G);
      _titleLable.text = @"可能感兴趣的好友和群";
      _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}

- (UIButton *)closeBtn {
  if (!_closeBtn) {
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setImage:[UIImage imageNamed:@"icon-pop-Close"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
  }
  return _closeBtn;
}

@end
