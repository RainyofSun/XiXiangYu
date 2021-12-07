//
//  XYActionSheetView.m
//  Xiangyu
//
//  Created by Jacky Dimon on 2018/1/21.
//  Copyright © 2018年 Shanghai xianmeng interconnection technology co., LTD. All rights reserved.
//

#import "XYActionSheetView.h"

@interface XYActionSheetCell : UITableViewCell

@property (nonatomic,strong) UIColor *titleColor;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) UILabel *lable;

@end

@implementation XYActionSheetCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.lable];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.lable.frame = self.contentView.bounds;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.lable.text = title;
}
- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.lable.textColor = titleColor;
}
- (UILabel *)lable {
    if (!_lable) {
        _lable = [[UILabel alloc] init];
        _lable.font = AdaptedFont(XYFont_E);
        _lable.textColor = ColorHex(XYTextColor_666666);
        _lable.numberOfLines = 1;
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}
@end

@interface XYActionSheetView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIView *topView;

@property (nonatomic,strong) UIView *line;

@property (nonatomic,strong) UILabel *detailLable;

@property (nonatomic,strong) UITableView *listView;

@property (nonatomic,strong) UIButton *sureButton;

@property (nonatomic,strong) UIButton *cancleButton;

@property (nonatomic,strong) NSNumber *selectedIndex;

@end

@implementation XYActionSheetView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColorAlpha(XYThemeColor_D, XYColorAlpha_0);
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
  [self addSubview:self.contentView];
  [self.contentView addSubview:self.topView];
  [self.topView addSubview:self.line];
  [self.topView addSubview:self.detailLable];
  [self.topView addSubview:self.cancleButton];
  [self.topView addSubview:self.sureButton];
  [self.contentView addSubview:self.listView];
}

- (void)layoutPageSubviews {
  self.contentView.frame = CGRectMake(0, 0, kScreenWidth, 0);
    
  self.topView.frame = CGRectMake(0, 0, kScreenWidth, 46);
  
  self.line.frame = CGRectMake(0, 45.5, kScreenWidth, 0.5);
  
  self.cancleButton.frame = CGRectMake(16, 12, 34, 22);
  
  self.sureButton.frame = CGRectMake(kScreenWidth-50, 12, 34, 22);
  
  self.detailLable.frame = CGRectMake(CGRectGetMaxX(self.cancleButton.frame), 0, kScreenWidth-100, 45);
  
  self.listView.frame = CGRectMake(0, 46, kScreenWidth, self.dataSource.count >7?294:self.dataSource.count*48);
  
  self.contentView.XY_height = CGRectGetMaxY(self.listView.frame)+44;
  self.contentView.XY_top = kScreenHeight-self.contentView.XY_height;
    
}
- (void)show {
    [kKeyWindow addSubview:self];
    self.frame = kKeyWindow.bounds;
    CGFloat height = 46+44+(self.dataSource.count >7?294:self.dataSource.count*48);
    self.contentView.transform = CGAffineTransformMakeTranslation(0, height);
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundColor = UIColorAlpha(XYThemeColor_D, XYColorAlpha_50);
        self.contentView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
      if (self.defaultRow>0) {
        [self.listView scrollToRow:self.defaultRow inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:NO];
      }
   
    }];
}

- (void)dismiss {
    CGFloat height = 46+44+(self.dataSource.count >7?294:self.dataSource.count*48);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
        self.contentView.transform = CGAffineTransformMakeTranslation(0, height);
    } completion:^(BOOL finished) {
        if (self.dismissBlock) self.dismissBlock();
        [self removeFromSuperview];
    }];
}

- (void)setDetail:(NSString *)detail {
    _detail = detail;
    self.detailLable.text = detail;
    [self layoutPageSubviews];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    self.listView.scrollEnabled = (dataSource.count > 7);
    [self.listView reloadData];
    [self layoutPageSubviews];
    
}

- (void)setPreIndex:(NSNumber *)preIndex {
  _preIndex = preIndex;
  
  XYActionSheetCell *cell = [self.listView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:preIndex.integerValue inSection:0]];
  if (cell) {
   cell.titleColor = ColorHex(XYTextColor_635FF0);
  }
  
  if (preIndex.integerValue < self.dataSource.count) {
    self.selectedIndex = @(preIndex.integerValue);
    self.sureButton.enabled = YES;
  }
}
-(void)setDefaultRow:(NSInteger)defaultRow{
  _defaultRow = defaultRow;

}
- (void)sure {
  if ([self.delegate respondsToSelector:@selector(didClickActionSheet:atIndex:)]) {
    [self.delegate didClickActionSheet:self atIndex:self.selectedIndex.integerValue];
  }
  if (self.selectedBlock) self.selectedBlock(self.selectedIndex.integerValue, self.dataSource[self.selectedIndex.integerValue]);
  
  [self dismiss];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  XYActionSheetCell *preCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex.integerValue inSection:0]];
  if (preCell) {
   preCell.titleColor = ColorHex(XYTextColor_666666);
  }
  
  self.selectedIndex = @(indexPath.row);
  
  XYActionSheetCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if (cell) {
   cell.titleColor = ColorHex(XYTextColor_635FF0);
  }
  
  self.sureButton.enabled = YES;
  
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"actionSheetCell";
    XYActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[XYActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    if (self.preIndex && self.preIndex.integerValue == indexPath.row) {
        cell.titleColor = ColorHex(XYTextColor_635FF0);
    }else {
        cell.titleColor = ColorHex(XYTextColor_666666);
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
      _contentView.backgroundColor = ColorHex(XYThemeColor_B);
    }
    return _contentView;
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] init];
        _listView.separatorColor = ColorHex(XYThemeColor_E);
        _listView.dataSource = self;
        _listView.delegate = self;
    }
    return _listView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = ColorHex(XYThemeColor_B);
    }
    return _topView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = ColorHex(XYThemeColor_E);
    }
    return _line;
}

- (UILabel *)detailLable {
    if (!_detailLable) {
        _detailLable = [[UILabel alloc] init];
        _detailLable.backgroundColor = ColorHex(XYThemeColor_B);
        _detailLable.font = AdaptedFont(XYFont_G);
        _detailLable.textColor = ColorHex(XYTextColor_222222);
        _detailLable.numberOfLines = 0;
        _detailLable.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLable;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setBackgroundColor:ColorHex(XYThemeColor_B)];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = AdaptedFont(15);
        [_sureButton setTitleColor:ColorHex(XYTextColor_FE2D63) forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
      _sureButton.enabled = NO;
    }
    return _sureButton;
}

- (UIButton *)cancleButton {
    if (!_cancleButton) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancleButton setBackgroundColor:ColorHex(XYThemeColor_B)];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancleButton.titleLabel.font = AdaptedFont(15);
        [_cancleButton setTitleColor:ColorHex(XYTextColor_666666) forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

@end
