//
//  ShowImagesView.m
//  TimeClock
//
//  Created by Apple on 2019/12/24.
//  Copyright © 2019 Apple. All rights reserved.
//
//------made in china-------
/**   The code comes frome breakfly
 *
 * 　　　┏┓　　　┏┓
 * 　　┏┛┻━━━┛┻┓
 * 　　┃　　　━　　　┃
 * 　　┃ 　^      ^ 　┃
 * 　　┃　　　┻　　　┃
 * 　　┗━━━━━━━┛
 *
 * --------萌萌哒-------
 */
#import "ShowImagesView.h"
#import "ShowImageItemCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"
@interface ShowImagesView ()<UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate>
@property(nonatomic,strong)WSLWaterFlowLayout *flowLayout;
@end

@implementation ShowImagesView
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self initData];
        [self newView];
    }
    return self;
}
-(void)initData{
    self.maxNum = 9;
    self.canAdd = YES;
    self.canDel = YES;
    self.isNarmol = YES;
    self.setoff = AutoSize(0);
    self.spaceItem = AutoSize(15);
    self.lineNum = 3;
    
}
-(WSLWaterFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[WSLWaterFlowLayout alloc] init];
        _flowLayout.delegate=self;
        _flowLayout.flowLayoutStyle = WSLWaterFlowVerticalEqualHeight;
    }
    return _flowLayout;
}
-(void)newView{
    
    
    UICollectionView *collectionView=[[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    collectionView.backgroundColor=[UIColor clearColor];
    collectionView.delegate=self;
    collectionView.dataSource = self;
    [collectionView registerClass:[ShowImageItemCollectionViewCell class] forCellWithReuseIdentifier:@"ItemCell"];
    collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        collectionView.scrollIndicatorInsets = collectionView.contentInset;
    }
    self.collectionView= collectionView;
    
    
  
    
    [self addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.leading.with.trailing.equalTo(self);
        make.bottom.equalTo(self).priority(800);
    }];
    
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.canAdd && self.dataSource.count<self.maxNum) {
        return self.dataSource.count+1;
    }
      return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShowImageItemCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCell" forIndexPath:indexPath];
    
    if (self.isFirestAdd && self.canAdd ) {
        if (indexPath.item>0) {
            [cell setCellItemWithData:[self.dataSource objectAtIndex:indexPath.item-1]];
            cell.delBtn.hidden = !self.canDel;
            [cell.delBtn handleControlEventWithBlock:^(id sender) {
                [self handelActionWithIndexPath:indexPath show:NO];
            }];
           // [cell.headerImage roundSize:6];
        }else{
            cell.delBtn.hidden = YES;
            cell.headerImage.image =[UIImage imageNamed:@"AlbumAddBtn"];
            cell.headerImage.contentMode = UIViewContentModeScaleAspectFit;
            [cell.headerImage roundSize:0];
        }
    }else{
        if (indexPath.item<self.dataSource.count) {
            [cell setCellItemWithData:[self.dataSource objectAtIndex:indexPath.item]];
            cell.delBtn.hidden = !self.canDel;
            [cell.delBtn handleControlEventWithBlock:^(id sender) {
                [self handelActionWithIndexPath:indexPath show:NO];
            }];
           // [cell.headerImage roundSize:6];
        }else{
            cell.delBtn.hidden = YES;
            cell.headerImage.image =[UIImage imageNamed:@"AlbumAddBtn"];
            cell.headerImage.contentMode = UIViewContentModeScaleAspectFit;
            [cell.headerImage roundSize:0];
        }
    }
    
    
   
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isFirestAdd && self.canAdd ) {
        if (indexPath.item>0) {
            [self handelActionWithIndexPath:[NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section] show:YES];
        }else{
            if (self.addblock) {
                self.addblock(nil);
            }
        }
    }else{
        if (indexPath.item<self.dataSource.count) {
            [self handelActionWithIndexPath:indexPath show:YES];
        }else{
            if (self.addblock) {
                self.addblock(nil);
            }
        }
    }
    
    
   
}
-(void)handelActionWithIndexPath:(NSIndexPath *)indexPath show:(BOOL)show{
    
    if (self.isFirestAdd && self.canAdd ) {
        if (self.selectedblock) {
            self.selectedblock(indexPath.item-1, @(show));
        }
    }else{
        if (self.selectedblock) {
            self.selectedblock(indexPath.item, @(show));
        }
    }
    
  
}

-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 2;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return self.spaceItem;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return self.spaceItem;
}

/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(0, self.setoff, 0, self.setoff);
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isNarmol) {
        CGFloat W = (self.collectionView.width - 2*self.setoff - (self.spaceItem-1)*self.lineNum-1)/self.lineNum;
        return CGSizeMake(W, W);
    }else{
        
        if (self.dataSource.count == 1) {
            CGFloat W = (self.collectionView.width - 2*self.setoff - (self.spaceItem-1)*self.lineNum-1);
            return CGSizeMake(W, W*3/4);
        }else if (self.dataSource.count == 2){
            CGFloat W = (self.collectionView.width - 2*self.setoff - self.spaceItem-1)/2.0-1;
            return CGSizeMake(W, W);
            
        }else if (self.dataSource.count == 4){
            CGFloat W = (self.collectionView.width - 2*self.setoff - self.spaceItem-1)/2.0;
            return CGSizeMake(W, W);
        }else{
            CGFloat W = (self.collectionView.width - 2*self.setoff - (self.spaceItem-1)*self.lineNum-1)/self.lineNum;
            return CGSizeMake(W, W);
            
        }
    }
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}


- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}




//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, self.setoff, 0, self.setoff);
//}
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return self.spaceItem;
//}
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return self.spaceItem;
//}
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.isNarmol) {
//        CGFloat W = (collectionView.width - 2*self.setoff - (self.spaceItem-1)*self.lineNum-1)/self.lineNum;
//        return CGSizeMake(W, W);
//    }else{
//
//        if (self.dataSource.count == 1) {
//            CGFloat W = (collectionView.width - 2*self.setoff - (self.spaceItem-1)*self.lineNum-1);
//            return CGSizeMake(W, W*3/4);
//        }else if (self.dataSource.count == 2){
//            CGFloat W = (collectionView.width - 2*self.setoff - self.spaceItem-1)/2.0-1;
//            return CGSizeMake(W, W);
//
//        }else if (self.dataSource.count == 4){
//            CGFloat W = (collectionView.width - 2*self.setoff - self.spaceItem-1)/2.0;
//            return CGSizeMake(W, W);
//        }else{
//            CGFloat W = (collectionView.width - 2*self.setoff - (self.spaceItem-1)*self.lineNum-1)/self.lineNum;
//            return CGSizeMake(W, W);
//
//        }
//    }
//}
-(void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    [self layoutIfNeeded];
  //  self.height= self.collectionView.collectionViewLayout.collectionViewContentSize.height;
    

    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGFloat heigth = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(heigth);
            make.bottom.equalTo(self).priority(800);
        }];
  //  });
    
  
    
    
    [self updateConstraintsIfNeeded];
}


@end
