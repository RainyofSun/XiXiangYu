//
//  ShowImagesView.h
//  TimeClock
//
//  Created by Apple on 2019/12/24.
//  Copyright © 2019 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^backBlock)(id obj);
typedef void(^selctedBlock)(NSInteger index,id   obj);
NS_ASSUME_NONNULL_BEGIN

@interface ShowImagesView : UIView
/**
 * 添加图片的时候使用
 */
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,assign)NSInteger maxNum; //最大数量 默认9
@property(nonatomic,assign)BOOL canAdd; // 默认开启
@property(nonatomic,assign)BOOL canDel; // 默认开启
@property(nonatomic,assign)BOOL isNarmol;//默认YES 展示数据的时候显示
@property(nonatomic,assign)BOOL isFirestAdd;        //添加图片在第一个  默认在最后一个
@property(nonatomic,assign)CGFloat spaceItem;//中间间距
@property(nonatomic,assign)CGFloat setoff;//边距
@property(nonatomic,assign)NSInteger lineNum;//每行个数


@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)selctedBlock selectedblock;
@property(nonatomic,strong)backBlock addblock;
@end

NS_ASSUME_NONNULL_END
