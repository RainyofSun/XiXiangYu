//
//  GuideViewController.m
//  Wedding
//
//  Created by apple on 15/7/3.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "GuideViewController.h"
//#import <SVGAPlayer/SVGAPlayer.h>
#import "XYGuideCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"
#import "TAPageControl.h"

#import "UIImage+Compress.h"
@interface GuideViewController()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
@property(nonatomic,strong)WSLWaterFlowLayout *flowLayout;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,strong)TAPageControl *pageControl;

@property(nonatomic,assign)NSInteger timeLoop;
@end
@implementation GuideViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self newNav];
    [self newView];
}
-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  [self playerWithIndex:self.currentIndex];
}
-(void)newView{

  self.collectionView = [LSHControl createCollectionViewFromFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:self.flowLayout dataSource:self delegate:self];
  self.collectionView.pagingEnabled = YES;
  self.collectionView.bounces = NO;
  self.collectionView.showsHorizontalScrollIndicator=NO;
  self.collectionView.backgroundColor = ColorHex(XYTextColor_FFFFFF);
  [self.collectionView registerClass:NSClassFromString(@"XYGuideCollectionViewCell") forCellWithReuseIdentifier:@"XYGuideCollectionViewCell"];
  [self.view addSubview:self.collectionView];
  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
  }];
  
  
  [self.view addSubview:self.pageControl];
  [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.view);
    make.bottom.equalTo(self.view).offset(-AutoSize(40)-GK_SAFEAREA_BTM);
  }];
//  self.imagesArr = @[@"page1",@"page2",@"page3",@"page4"];
//    for (int i=0; i<_imagesArr.count; i++){
//      SVGAPlayer *_player = [[SVGAPlayer alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//      NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"bundle"];
//      NSBundle *resourceBundle = [NSBundle bundleWithPath:bundlePath];
//      SVGAParser *parser = [[SVGAParser alloc] init];
//      [parser parseWithNamed:[_imagesArr objectAtIndex:i] inBundle:resourceBundle completionBlock:^(SVGAVideoEntity * _Nonnull videoItem) {
//        _player.videoItem = videoItem;
//      } failureBlock:nil];
//      [self.scrollView addSubview:_player];
//      [self.playerArray addObject:_player];
//      
//     
//      
//    }
//  self.scrollView.contentSize = CGSizeMake( self.imagesArr.count*SCREEN_WIDTH, SCREEN_HEIGHT);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  XYGuideCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"XYGuideCollectionViewCell" forIndexPath:indexPath];
  cell.model = [self.dataSource objectAtIndex:indexPath.item];
  
  [cell.actionBtn handleControlEventWithBlock:^(id sender) {
    [self EnterButtonEvent:sender];
  }];
  cell.actionBtn.hidden = indexPath.item<(self.dataSource.count-1);
  

  return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}

-(CGFloat)rowCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 1;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return AutoSize(0);
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
  return AutoSize(0);
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(AutoSize(0), AutoSize(0), AutoSize(0), AutoSize(0));
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
-(NSMutableArray *)dataSource{
  if (!_dataSource) {
    _dataSource = [NSMutableArray new];
    [_dataSource addObjectsFromArray:@[@{@"title":@"精准推荐附近同乡异性",@"subtitle":@"恋爱不异地，结婚不远嫁",@"page":@"page1"},@{@"title":@"互推海量老乡短视频",@"subtitle":@"走心的内容给懂你的人看",@"page":@"page2"},@{@"title":@"查阅同城老乡动态",@"subtitle":@"关注聊天结识有趣的人",@"page":@"page3"},@{@"title":@"拓展同城老乡关系网",@"subtitle":@"喜乡遇一直在路上",@"page":@"page4"}]];
  }
  return _dataSource;
}

-(void)EnterButtonEvent:(UIButton *)button{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.alpha = 0;
    }completion:^(BOOL finished) {
      
      [[NSUserDefaults standardUserDefaults] setValue:[XYAppVersion currentVersion] forKey:@"GuideKey"];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
}
#pragma mark - ScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
  
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
   CGPoint point=[scrollView contentOffset];
 NSInteger index=(NSInteger)point.x/(self.view.width);
  [self playerWithIndex: index];
}

-(void)playerWithIndex:(NSInteger)index{

  XYGuideCollectionViewCell *cell =(XYGuideCollectionViewCell*) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
  
 SVGAPlayer *_player  = cell.player;
  if (self.currentIndex != index) {
    self.timeLoop = 0;
  }
 
  self.currentIndex = index;
  if (!_player.videoItem) {
    self.timeLoop ++;
    if (self.timeLoop>3) {
      return;
    }
    [self playerWithIndex: self.currentIndex];
  }else{
    _player.clearsAfterStop = NO;
     [_player startAnimation];
  }
  
  self.pageControl.currentPage = index;
}


-(WSLWaterFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[WSLWaterFlowLayout alloc] init];
        _flowLayout.delegate=self;
        _flowLayout.flowLayoutStyle = WSLWaterFlowHorizontalEqualHeight;
    }
    return _flowLayout;
}
-(TAPageControl *)pageControl{
  if (!_pageControl) {
    _pageControl = [[TAPageControl alloc] init];
    _pageControl.numberOfPages = self.dataSource.count;
    _pageControl.userInteractionEnabled = NO;
    _pageControl.dotSize = CGSizeMake(6, 6);
    _pageControl.dotImage = [[UIImage imageWithColor:ColorHex(@"#FFC2D1") size:CGSizeMake(6, 6) ] imageWithCornerRadius:3 ];
    _pageControl.currentDotImage = [[UIImage imageWithColor:ColorHex(@"#F92B5E") size:CGSizeMake(6, 6)] imageWithCornerRadius:3];
    
  }
  return _pageControl;
}
#pragma mark - 导航
-(void)newNav{
   // self.navigationController.navigationBarHidden=YES;
  //  self.NavImg.hidden=YES;
  //  self.view.backgroundColor=whiteLineColore;
}
@end
