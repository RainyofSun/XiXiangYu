//
//  XYSubSearchListController.m
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import "XYSubSearchListController.h"

@interface XYSubSearchListController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *listView;

@end

@implementation XYSubSearchListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.gk_navigationBar.hidden = YES;
    self.gk_popMaxAllowedDistanceToLeftEdge = 16.0;
  
    [self setupSubviews];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([self.cellClassString isEqualToString:@"XYDemandCell"]) {
    return self.demandData.count;
  } else {
    return self.activityData.count;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if ([self.cellClassString isEqualToString:@"XYDemandCell"]) {
    static NSString *reuseID = @"XYDemandCell";
    XYDemandCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
      if (!cell) {
          cell = [[XYDemandCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
      }
    cell.item = self.demandData[indexPath.row];
      return cell;
  } else {
    static NSString *reuseID = @"XYActivityCell";
    XYActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
      if (!cell) {
          cell = [[XYActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
      }
    cell.item = self.activityData[indexPath.row];
      return cell;
  }
}
#pragma - UI

- (void)setupSubviews {
  self.gk_navigationBar.hidden = YES;
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self.view addSubview:self.listView];
  [self.listView makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
  }];
}

- (UITableView *)listView {
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT+50, self.view.XY_width, self.view.XY_height - NAVBAR_HEIGHT-50)];
      if (![self.cellClassString isEqualToString:@"XYDemandCell"]) {
        _listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
      } else {
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
      }
        _listView.dataSource = self;
        _listView.delegate = self;
      UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
      _listView.tableFooterView = footer;
      _listView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    return _listView;
}
@end
