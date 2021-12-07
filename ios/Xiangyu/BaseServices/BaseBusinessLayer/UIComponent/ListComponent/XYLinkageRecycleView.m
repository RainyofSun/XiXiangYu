//
//  XYLinkageRecycleView.m
//  Xiangyu
//
//  Created by dimon on 02/02/2021.
//

#import "XYLinkageRecycleView.h"
#import "XYLinkageRecycleCell.h"

@interface XYLinkageRecycleView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *leftListView;

@property (nonatomic,strong) UITableView *rightListView;

@end

@implementation XYLinkageRecycleView
- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = ColorHex(XYThemeColor_B);
    [self addSubview:self.leftListView];
    [self addSubview:self.rightListView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.leftListView.frame = CGRectMake(0, 0, self.XY_width*0.4, self.XY_height);
  self.rightListView.frame = CGRectMake(self.XY_width*0.4, 16, self.XY_width*0.6, self.XY_height-16);
}

- (void)setDataSource:(NSArray<XYIndustryModel *> *)dataSource {
  _dataSource = dataSource;
  self.selectedLeftIndex = @(0);
  [self.leftListView reloadData];
  [self.rightListView reloadData];
  self.selectedRightIndex = nil;
  [self.leftListView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedLeftIndex.integerValue inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (tableView == self.leftListView) {
    self.selectedRightIndex = nil;
    self.selectedLeftIndex = @(indexPath.row);
    [self.rightListView reloadData];
  } else {
    self.selectedRightIndex = @(indexPath.row);
    if (self.selectedBlock) {
      self.selectedBlock(self.selectedLeftIndex, self.selectedRightIndex);
    }
  }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView == self.leftListView) {
    return self.dataSource.count;
  } else {
    return self.dataSource[self.selectedLeftIndex.integerValue].list.count;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (tableView == self.leftListView) {
    static NSString *leftReuseID = @"kLinkageRecycleLeftCell";
    XYLinkageRecycleLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:leftReuseID];
    if (!cell) {
        cell = [[XYLinkageRecycleLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftReuseID];
    }
    cell.title = self.dataSource[indexPath.row].name;
    return cell;
  } else {
    static NSString *rightReuseID = @"kLinkageRecycleRightCell";
    XYLinkageRecycleRightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightReuseID];
    if (!cell) {
        cell = [[XYLinkageRecycleRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightReuseID];
    }
    cell.title = self.dataSource[self.selectedLeftIndex.integerValue].list[indexPath.row].name;
    return cell;
  }
}

#pragma mark - getter

- (UITableView *)leftListView {
    if (!_leftListView) {
        _leftListView = [[UITableView alloc] init];
        _leftListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftListView.dataSource = self;
        _leftListView.delegate = self;
        _leftListView.rowHeight = 60;
        _leftListView.backgroundColor = ColorHex(XYThemeColor_F);
    }
    return _leftListView;
}

- (UITableView *)rightListView {
    if (!_rightListView) {
        _rightListView = [[UITableView alloc] init];
        _rightListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightListView.dataSource = self;
        _rightListView.delegate = self;
        _rightListView.rowHeight = 56;
    }
    return _rightListView;
}
@end
