//
//  XYScreeningItemCollectionViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
//

#import "XYHomeBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYScreeningItemCollectionViewCell : XYHomeBaseCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,assign)BOOL isSelected;

@property(nonatomic,assign)NSInteger colortype;
@end

NS_ASSUME_NONNULL_END
