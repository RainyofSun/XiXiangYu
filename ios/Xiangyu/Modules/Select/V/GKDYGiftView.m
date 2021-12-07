//
//  GKDYGiftView.m
//  Xiangyu
//
//  Created by GQLEE on 2021/3/13.
//

#import "GKDYGiftView.h"
#import "UIImage+GKCategory.h"
#import "GKBallLoadingView.h"
#import "XYGeneralAPI.h"
#import "XYGiftCollectionViewCell.h"
#import "LHHorizontalPageFlowlayout.h"
#import "XYGiftPaymentController.h"

@interface GKDYGiftView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate> {
  NSArray *_dataArr;
}

@property (nonatomic, strong) UIVisualEffectView    *effectView;
@property (nonatomic, strong) UIView                *topView;
@property (nonatomic, strong) UIPageControl                *footView;
@property (nonatomic, strong) UILabel               *countLabel;
@property (nonatomic, strong) UITextField                *tf;
@property (nonatomic, strong) UIButton                *querBtn;

@property (nonatomic, strong) UICollectionView         *collectionView;

@property (nonatomic, assign) NSInteger             count;


@end

@implementation GKDYGiftView


- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.topView];
        //[self addSubview:self.effectView];
        [self addSubview:self.countLabel];
        [self addSubview:self.closeBtn];
        [self addSubview:self.collectionView];
      [self addSubview:self.footView];
      
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(ADAPTATIONRATIO * 100.0f);
        }];
        
//        [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
          make.left.equalTo(self.topView.mas_left).offset(15);
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView);
            make.right.equalTo(self).offset(-ADAPTATIONRATIO * 16.0f);
            make.width.height.mas_equalTo(ADAPTATIONRATIO * 36.0f);
        }];
      
      [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.mas_equalTo(-20);
          make.top.mas_equalTo(self.topView.mas_bottom);
        }];
      [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.right.equalTo(self);
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(20);
      }];

      
        self.countLabel.text = @"礼物";
    }
    return self;
}

- (void)requestData {
    GKBallLoadingView *loadingView = [GKBallLoadingView loadingViewInView:self.collectionView];
    [loadingView startLoading];
    
  NSString *method = @"api/v1/Gift/GetGiftConf";
  NSDictionary *params = @{@"type":self.type?:@(1)};

  XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
    api.apiRequestMethodType = XYRequestMethodTypePOST;
  
  api.requestParameters = params ?: @{};
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    [loadingView stopLoading];
    [loadingView removeFromSuperview];
    if (!error) {
      NSArray *dataArr =data;
      self.count = dataArr.count;
      _dataArr = dataArr;
      [self.collectionView reloadData];
      
    } else {

    }
  };
  [api start];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [loadingView stopLoading];
    [loadingView removeFromSuperview];
  });
}

#pragma mark -- UICollectionViewDataSource ---定义展示的UICollectionViewCell的个数---
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  int a = ceilf(_dataArr.count / 6.0);
  
  self.footView.numberOfPages = a;
  
    return a * 6;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"XYGiftCollectionViewCell";
  XYGiftCollectionViewCell *cell = (XYGiftCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
  if (indexPath.row < _dataArr.count) {
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:_dataArr[indexPath.row][@"iconUrl"]]];
    cell.titleLab.text =_dataArr[indexPath.row][@"name"];
    if ([self.type integerValue] == 2) {
      cell.decLab.text =[NSString stringWithFormat:@"%@元",_dataArr[indexPath.row][@"amt"]];
    }else{
      cell.decLab.text =[NSString stringWithFormat:@"%@乡币",_dataArr[indexPath.row][@"goldCount"]];
    }
    
  
  }else {
    [cell.iconImg sd_setImageWithURL:nil];
    cell.titleLab.text =@"";
    cell.decLab.text =@"";
  }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( SCREEN_WIDTH / 3, 140);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [self sendGift:_dataArr[indexPath.row]];
  
  if (self.closePage) {
      self.closePage();
  }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
  int a = floorf(scrollView.contentOffset.x / SCREEN_WIDTH);
//
  _footView.currentPage = a;
  
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //确定是水平滚动，还是垂直滚动
      LHHorizontalPageFlowlayout * layout = [[LHHorizontalPageFlowlayout alloc] initWithRowCount:2 itemCountPerRow:3];
      [layout setColumnSpacing:0 rowSpacing:0 edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
      layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      //    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
      //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
      layout.minimumLineSpacing = 0;
      layout.minimumInteritemSpacing = 0;

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
      _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[XYGiftCollectionViewCell class] forCellWithReuseIdentifier:@"XYGiftCollectionViewCell"];
        
    }
    return _collectionView;
}

#pragma mark - 懒加载
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    }
    return _effectView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADAPTATIONRATIO * 100.0f)];
        _topView.backgroundColor =[UIColor whiteColor];
        
        //CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, ADAPTATIONRATIO * 100.0f);
        //绘制圆角 要设置的圆角 使用“|”来组合
      //  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
        
      //  CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        //设置大小
       // maskLayer.frame = frame;
        
        //设置图形样子
      //  maskLayer.path = maskPath.CGPath;
        
        //_topView.layer.mask = maskLayer;
      [_topView roundSize:AutoSize(12) andCorner:UIRectCornerTopLeft|UIRectCornerTopRight];
    }
    return _topView;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel.font = [UIFont systemFontOfSize:17.0f];
        _countLabel.textColor = ColorHex(XYTextColor_666666);
      _countLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _countLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:[UIImage gk_changeImage:[UIImage imageNamed:@"close"] color:[UIColor grayColor]] forState:UIControlStateNormal];
    }
    return _closeBtn;
}


- (UIPageControl *)footView {
    if (!_footView) {
      _footView = [UIPageControl new];
      _footView.backgroundColor = [UIColor whiteColor];
    
      _footView.hidesForSinglePage = YES;
      _footView.pageIndicatorTintColor = ColorHex(XYTextColor_999999);
      _footView.currentPageIndicatorTintColor = ColorHex(XYTextColor_635FF0);
      //[_footView setBounds:CGRectMake(0,0,16*(2-1)+16,16)]; //页面控件上的圆点间距基本在16左右。
  //  [_footView.layer setCornerRadius:8]; // 圆角层
    }
    return _footView;
}

- (void)sendGift:(NSDictionary *)dataDic {
  XYGiftPaymentController *toVC = [[XYGiftPaymentController alloc] init];
  toVC.type = self.type;
  toVC.dicData = dataDic;
  toVC.user_id = _user_id;
  @weakify(toVC);
  MJWeakSelf
    toVC.payWithSuccess = ^{
      [weak_toVC dismissViewControllerAnimated:YES completion:nil];
      if (weakSelf.payWithSuccessGift) {
        weakSelf.payWithSuccessGift();
      }
    };
    [[self getCurrentVC] presentViewController:toVC animated:YES completion:nil];
   
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
@end
