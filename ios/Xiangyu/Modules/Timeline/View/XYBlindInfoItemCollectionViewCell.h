//
//  XYBlindInfoItemCollectionViewCell.h
//  Xiangyu
//
//  Created by Kang on 2021/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XYBlindInfoItemCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *titleLabel;

+(CGSize)getItemCellSizeWithData:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
