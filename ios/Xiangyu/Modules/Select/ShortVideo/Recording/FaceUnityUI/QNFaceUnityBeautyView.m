//
//  QNFaceUnityBeautyView.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/30.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNFaceUnityBeautyView.h"
#import "FUManager.h"

@interface QNFaceUnityBeautyView ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) NSArray *itemArray;

@property (nonatomic, strong) NSArray *itemImageArray;
@property (nonatomic, strong) NSArray *itemSelectedImageArray;

@property(nonatomic,strong)NSIndexPath *indexPath;
@end

@implementation QNFaceUnityBeautyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.itemArray = @[@"素颜",@"美颜", @"美白", @"红润"];
      self.itemImageArray = @[@"none",@"meiyan0", @"meibai", @"hongrun"];
      self.itemSelectedImageArray = @[@"none",@"meiyan1", @"meibai1", @"hongrun1"];
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(60, 100);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        CGRect rc = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 60);
        self.collectionView = [[UICollectionView alloc] initWithFrame:rc collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.dataSource = self;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"Cell"];
        [self addSubview:self.collectionView];

        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(100);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.collectionView.numberOfSections > 0 && [self.collectionView numberOfItemsInSection:0] > 0) {
                [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:(UICollectionViewScrollPositionCenteredHorizontally)];
            }
        });
    }
    return self;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    static NSInteger imageViewTag = 0x1234;
    static NSInteger labelTag = 0x1235;
    
    if (nil == cell.selectedBackgroundView) {
        cell.selectedBackgroundView = [[UIView alloc] init];
      cell.backgroundView = [[UIView alloc] init];
    }
    
    UIImageView *imageView = [cell.contentView viewWithTag:imageViewTag];
    if (!imageView) {
        CGRect rc = CGRectMake((cell.bounds.size.width - 50)/2, 10, 50, 50);
        imageView = [[UIImageView alloc] initWithFrame:rc];
        imageView.tag = imageViewTag;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 50/2;
        [cell.contentView addSubview:imageView];
        int boardWidth = 2;
        rc =  CGRectMake(rc.origin.x - boardWidth, rc.origin.y - boardWidth, rc.size.width + 2 * boardWidth, rc.size.height + 2 * boardWidth);
      cell.backgroundView.frame = rc;
      cell.backgroundView.layer.borderWidth = boardWidth;
      cell.backgroundView.layer.borderColor = ColorHex(XYTextColor_999999).CGColor;
      cell.backgroundView.layer.cornerRadius = 5;
      
        cell.selectedBackgroundView.frame = rc;
        cell.selectedBackgroundView.layer.borderWidth = boardWidth;
        cell.selectedBackgroundView.layer.borderColor = ColorHex(XYTextColor_FE2D63).CGColor;
        cell.selectedBackgroundView.layer.cornerRadius = 5;
    }
    UILabel *label = [cell.contentView viewWithTag:labelTag];
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = ColorHex(XYTextColor_999999);
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = labelTag;
        label.frame = CGRectMake(0, 65, cell.bounds.size.width, 25);
        [cell.contentView addSubview:label];
    }
    
    label.text = self.itemArray[indexPath.row];
    imageView.image = [UIImage imageNamed:self.itemImageArray[indexPath.row]];
  imageView.highlightedImage = [UIImage imageNamed:self.itemSelectedImageArray[indexPath.row]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemArray.count;
}



-(void)itemWithIndexPath:(NSIndexPath *)indexPath selected:(BOOL)selcted{
  UICollectionViewCell* cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//  cell.selectedBackgroundView.layer.borderColor =selcted? ColorHex(XYTextColor_FE2D63).CGColor:ColorHex(XYTextColor_999999).CGColor;
  static NSInteger imageViewTag = 0x1234;
  static NSInteger labelTag = 0x1235;
  UILabel *label = [cell.contentView viewWithTag:labelTag];
  label.textColor = selcted?ColorHex(XYTextColor_FE2D63):ColorHex(XYTextColor_999999);
  UIImageView *imageView = [cell.contentView viewWithTag:imageViewTag];
  
  //NSString *imageName = [self.itemImageArray objectAtIndex:indexPath.item];
 // if (selcted) {
    //imageName = [NSString stringWithFormat:@"%@1",imageName];
//  }
  imageView.highlighted = selcted;
  //imageView.image = [UIImage imageNamed:imageName];
  
  
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(beautyView:didSelectedIndex:)]) {
        [self.delegate beautyView:self didSelectedIndex:indexPath.row];
    }
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionCenteredHorizontally) animated:YES];
  if (self.indexPath) {
    [self itemWithIndexPath:self.indexPath selected:NO];
  }
  self.indexPath = indexPath;
  
  [self itemWithIndexPath:indexPath selected:YES];
}

- (void)reset {
    NSArray *paths = [self.collectionView indexPathsForSelectedItems];
    if (paths.count) {
      
        NSIndexPath *indexPath = paths.firstObject;
        //[self collectionView:self.collectionView didSelectItemAtIndexPath:indexPath];
      [self itemWithIndexPath:indexPath selected:NO];
      [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
}

@end
