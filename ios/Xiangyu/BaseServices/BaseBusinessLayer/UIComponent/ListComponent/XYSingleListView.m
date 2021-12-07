//
//  XYSingleListView.m
//  Xiangyu
//
//  Created by dimon on 02/02/2021.
//

#import "XYSingleListView.h"
#import "XYSingleListCell.h"

@interface XYSingleListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *listView;

@end

@implementation XYSingleListView
- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = ColorHex(XYThemeColor_B);
    [self addSubview:self.listView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.listView.frame = self.bounds;
}

- (void)setDataSource:(NSArray<NSString *> *)dataSource {
  _dataSource = dataSource;
  self.selectedIndex = @(0);
  [self.listView reloadData];
  [self.listView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex.integerValue inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  self.selectedIndex = @(indexPath.row);
  if (self.selectedBlock) {
    self.selectedBlock(self.selectedIndex);
  }
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *rightReuseID = @"XYSingleListViewCell";
  XYSingleListCell *cell = [tableView dequeueReusableCellWithIdentifier:rightReuseID];
  if (!cell) {
      cell = [[XYSingleListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightReuseID];
  }
  cell.title = self.dataSource[indexPath.row];
  return cell;
}

#pragma mark - getter

- (UITableView *)listView {
    if (!_listView) {
      _listView = [[UITableView alloc] init];
      _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
      _listView.dataSource = self;
      _listView.delegate = self;
      _listView.rowHeight = 44;
    }
    return _listView;
}

@end
