//
//  XYReportView.m
//  Xiangyu
//
//  Created by GQLEE on 2021/4/21.
//

#import "XYReportView.h"
#import "MCMyTableViewCell.h"
#import "XYSuccessViewController.h"

@interface XYReportView()<UITableViewDelegate,UITableViewDataSource> {
  int a;
  NSArray *_titleArr;
}
@property (nonatomic, strong) UIView * shareView;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIView * headerView;



@end


#define TopSpace 29
#define MidSpace 36
#define BottomSpace 34

#define ImageSize 58
#define ImageLabelSpace 13
#define ItemFontSize 10
#define CancelItemHeight 61
#define CancelFontSize 13

#define LineColor [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]
#define FontColor [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0]

@implementation XYReportView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      a = 0;
      _titleArr = @[@"违法违规",@"色情低俗",@"恶意广告",@"政治相关",@"标题党、封面党",@"抽烟、辱骂等行为",@"不适合未成年观看",@"其他"];
      
    }
    return self;
}
- (UIView *)shareView {
  if (!_shareView) {
    _shareView = [[UIView alloc] init];
    _shareView.backgroundColor = [UIColor whiteColor];
    [_shareView addSubview:self.tableView];
  }
  return  _shareView;
}

- (void)addView {
  self.hidden = NO;
  [self addSubview:self.shareView];
  self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
  self.shareView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, SCREEN_WIDTH, 440);
  [UIView animateWithDuration:0.3 animations:^{
      self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT-CGRectGetHeight(self.shareView.frame), CGRectGetWidth(self.shareView.frame), CGRectGetHeight(self.shareView.frame));
  }];
  [UIView animateWithDuration:0.5 animations:^{
      self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];;
  }];
}

- (void)setShareItemaaa {
  [self setShareItem];

XYSuccessViewController *toVC = [[XYSuccessViewController alloc] init];
  [[self getCurrentVC] presentViewController:toVC animated:YES completion:nil];
}
- (void)setShareItem {
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.frame = CGRectMake(0,SCREEN_HEIGHT, CGRectGetWidth(self.shareView.frame), CGRectGetHeight(self.shareView.frame));
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.0];;
    } completion:^(BOOL finished) {
      self.hidden = YES;
    }];
  
}

-(UIViewController *)getCurrentVC
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

-(UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
      
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {

        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
     
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
       
     
        currentVC = rootVC;
    }
    
    return currentVC;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setShareItem];
}

#pragma mark ------初始化------
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 440) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = self.bottomView;
      _tableView.tableHeaderView = self.headerView;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}
-(UIView *)headerView {
  if (!_headerView) {
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 44)];
    [_headerView addSubview:btn];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [btn setTitle:@"请选择您要举报的内容" forState:UIControlStateNormal];
    [btn setTitleColor:ColorHex(@"#666666") forState:UIControlStateNormal];
  }
  return  _headerView;
}
- (UIView *)bottomView {
  if (!_bottomView) {
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 44)];
    [_bottomView addSubview:btn];
    [btn addTarget:self action:@selector(setShareItemaaa) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 22;
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:ColorHex(@"#F92B5E")];
  }
  return  _bottomView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return _titleArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MCMyTableViewCell *cell = [[MCMyTableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLab.text = _titleArr[indexPath.row];
  if (a == indexPath.row) {
    cell.arrowImg.image = [UIImage imageNamed:@"icon_22_option_sel"];
  }else {
    cell.arrowImg.image = [UIImage imageNamed:@"icon_22_option_def"];
  }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 40;
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  a = indexPath.row;
  [self.tableView reloadData];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
