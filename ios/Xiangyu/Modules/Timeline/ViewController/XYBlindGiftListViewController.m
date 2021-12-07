//
//  XYBlindGiftListViewController.m
//  Xiangyu
//
//  Created by GQLEE on 2021/3/17.
//

#import "XYBlindGiftListViewController.h"
#import "XYBlindGiftListCCell.h"
#import "GKBallLoadingView.h"
#import "XYGeneralAPI.h"
#import "XYUserService.h"

@interface XYBlindGiftListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
  NSArray *_dataArr;
}
@property (nonatomic, strong) UICollectionView         *collectionView;

@end

@implementation XYBlindGiftListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [self setupNavBar];
  [self.view addSubview:self.collectionView];
  
  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
  [self requestData];
}
- (void)setupNavBar {
  self.gk_navLineHidden = YES;
  self.gk_navTitle = @"收到的礼物";
}

- (void)requestData {
    GKBallLoadingView *loadingView = [GKBallLoadingView loadingViewInView:self.collectionView];
    [loadingView startLoading];
    
  
  NSString *method = @"api/v1/Gift/GetMyGiftList";
  XYUserInfo *user = [[XYUserService service] fetchLoginUser];
  
  
  NSDictionary *params = @{
    @"page":@{
      @"pageSize":@99999,
      @"pageIndex":@1
    },
    @"userId":@([user.userId intValue]),
    @"queryType":@2

  };

  XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
    api.apiRequestMethodType = XYRequestMethodTypePOST;
  
  api.requestParameters = params ?: @{};
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    [loadingView stopLoading];
    [loadingView removeFromSuperview];
    if (!error) {
      
      
      NSArray *dataArr =data[@"list"];
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
    return _dataArr.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"XYBlindGiftListCCell";
  XYBlindGiftListCCell *cell = (XYBlindGiftListCCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:_dataArr[indexPath.row][@"iconUrl"]]];
    cell.titleLab.text =_dataArr[indexPath.row][@"name"];
  
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( SCREEN_WIDTH / 4, 100);
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

}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
     
          UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
          layout.scrollDirection = UICollectionViewScrollDirectionVertical;
      layout.minimumLineSpacing = 0;
      layout.minimumInteritemSpacing = 0;

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
      _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[XYBlindGiftListCCell class] forCellWithReuseIdentifier:@"XYBlindGiftListCCell"];
        
    }
    return _collectionView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
