//
//  XYActionAlertView.m
//  Baiqu
//
//  Created by Jacky Dimon on 2018/1/21.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYActionAlertView.h"
#import "XYActionAlertCell.h"

@interface XYActionAlertView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UITableView *listView;

@property (nonatomic,strong) UIButton *cancleButton;

@end

@implementation XYActionAlertView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorAlpha(@"#000000", XYColorAlpha_0);
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.listView];
    [self.contentView addSubview:self.cancleButton];
}

- (void)layoutPageSubviews {
    self.contentView.frame = CGRectMake(0, 0, kScreenWidth, 0);
    
    self.listView.frame = CGRectMake(0, 0, kScreenWidth, self.dataSource.count >7?294:self.dataSource.count*42);
    
    self.cancleButton.frame = CGRectMake(0, CGRectGetMaxY(self.listView.frame)+10, kScreenWidth, 42);
    
    self.contentView.XY_height = CGRectGetMaxY(self.cancleButton.frame);
    self.contentView.XY_top = kScreenHeight-self.contentView.XY_height;
    
}
- (void)show {
    [kKeyWindow addSubview:self];
    self.frame = kKeyWindow.bounds;
    CGFloat height = 42+10+(self.dataSource.count >7?294:self.dataSource.count*42);
    self.contentView.transform = CGAffineTransformMakeTranslation(0, height);
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = UIColorAlpha(@"#000000", XYColorAlpha_50);
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}

- (void)dismiss {
    CGFloat height = 42+10+(self.dataSource.count >7?294:self.dataSource.count*42);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeTranslation(0, height);
    } completion:^(BOOL finished) {
        if (self.dismissBlock) self.dismissBlock();
        [self removeFromSuperview];
    }];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    self.listView.scrollEnabled = (dataSource.count > 7);
    [self.listView reloadData];
    [self layoutPageSubviews];
    
}

- (void)setDestroy:(NSString *)destroy {
    _destroy = destroy;
    NSInteger index = [self.dataSource indexOfObject:destroy];
  XYActionAlertCell *cell = [self.listView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if (cell) {
     cell.titleColor = ColorHex(@"#F4333C");
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didClickActionSheet:atIndex:)]) {
        [self.delegate didClickActionSheet:self atIndex:indexPath.row];
    }
    if (self.selectedBlock) self.selectedBlock(indexPath.row);
    
    [self dismiss];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"actionSheetCell";
  XYActionAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[XYActionAlertCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    if ([self.dataSource[indexPath.row] isEqualToString:self.destroy]) {
        cell.titleColor = ColorHex(@"#F4333C");
    }else {
        cell.titleColor = ColorHex(@"#000000");
    }
    cell.title = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //设置separatorInset(iOS7之后)
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    //设置layoutMargins(iOS8之后)
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (touches.anyObject.view == self) {
        [self dismiss];
    }
}
#pragma mark - getter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = ColorHex(@"#F2F3F3");
    }
    return _contentView;
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
      _listView.separatorColor = ColorHex(@"#F2F3F3");
        _listView.dataSource = self;
        _listView.delegate = self;
    }
    return _listView;
}

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setBackgroundColor:ColorHex(@"#FFFFFF")];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = AdaptedFont(17);
        [_cancleButton setTitleColor:ColorHex(@"#000000") forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

#pragma mark - private
- (CGSize)_calculateHeightForLable:(UILabel *)lable {
    
    return [lable sizeThatFits:CGSizeMake(lable.XY_width, MAXFLOAT)];
    
}
@end
